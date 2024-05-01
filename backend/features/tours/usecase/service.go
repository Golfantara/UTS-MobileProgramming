package usecase

import (
	"errors"
	"io"
	"io/ioutil"
	"mime/multipart"
	"net/http"
	"uts-flutter/features/tours"
	"uts-flutter/features/tours/dtos"
	"uts-flutter/helpers"

	"github.com/labstack/gommon/log"
	"github.com/mashingan/smapping"
)

type service struct {
	model tours.Repository
	validator helpers.ValidationInterface
}

func New(model tours.Repository, validator helpers.ValidationInterface) tours.Usecase {
	return &service {
		model: model,
		validator: validator,
	}
}

func (svc *service) FindAll(UserID, page, size int) ([]dtos.ResTours, int64) {
	var tourss []dtos.ResTours

	tourssEnt := svc.model.Paginate(UserID, page, size)
	

	for _, tours := range tourssEnt {
		var data dtos.ResTours

		if err := smapping.FillStruct(&data, smapping.MapFields(tours)); err != nil {
			log.Error(err.Error())
		} 
		
		tourss = append(tourss, data)
	}
	var totalData int64 = 0
	totalData = svc.model.GetTotalDataTours()

	return tourss, totalData
}

func (svc *service) FindByID(toursID int) *dtos.ResTours {
	res := dtos.ResTours{}
	tours := svc.model.SelectByID(toursID)

	if tours == nil {
		return nil
	}

	res.ID = tours.ID
	res.UserID = tours.UserID
	res.Name = tours.Name
	res.Provinsi = tours.Provinsi
	res.Kabkot = tours.Kabkot
	res.Latitude = tours.Latitude
	res.Longtitude = tours.Longtitude
	res.Images = tours.Images

	return &res
}

func (svc *service) Create(newTours dtos.InputTours, UserID int, file *multipart.FileHeader) (*dtos.ResTours,[]string, error) {
	tours := tours.Tours{}

	if errorList, err := svc.ValidateInput(newTours, file); err != nil || len(errorList) > 0 {
		return nil, errorList, err
	}
	url, err := svc.model.UploadFile(file, "")
	if err != nil {
		return nil,nil, errors.New("upload image failed")
	}

	tours.ID = helpers.NewGenerator().GenerateRandomID()
	tours.UserID = UserID
	tours.Images = url
	tours.Name = newTours.Name
	tours.Provinsi = newTours.Provinsi
	tours.Kabkot = newTours.Kabkot
	tours.Latitude = newTours.Latitude
	tours.Longtitude = newTours.Longtitude
	tours.NewsCreated = svc.model.GetTimeNow()

	result, err := svc.model.Insert(&tours)
	if err != nil {
		log.Error(err)
		return nil,nil, errors.New("failed to create tours")
	}

	resTours := dtos.ResTours{}
	resTours.UserID = result.UserID
	resTours.ID = result.ID
	resTours.Name = result.Name
	resTours.Provinsi = result.Provinsi
	resTours.Kabkot = result.Kabkot
	resTours.Latitude = result.Latitude
	resTours.Longtitude = result.Longtitude
	resTours.Images = result.Images

	return &resTours, nil,nil
}

func (svc *service) Modify(toursData dtos.InputTours, toursID int, file *multipart.FileHeader) bool {
	var url string

	if file != nil {
		var err error
		url, err = svc.model.UploadFile(file, toursData.Images)
		if err != nil {
			log.Error("failed upload images")
			return false
		}
	}

	newTours := tours.Tours{
		ID: toursID,
		Provinsi: toursData.Provinsi,
		Kabkot: toursData.Kabkot,
		Name: toursData.Name,
	}

	if file != nil {
		newTours.Images = url
	}

	

	rowsAffected := svc.model.Update(newTours)

	if rowsAffected <= 0 {
		log.Error("There is No Tours Updated!")
		return false
	}
	
	return true
}

func (svc *service) Remove(newsID int) bool {
	rowsAffected := svc.model.DeleteByID(newsID)

	if rowsAffected <= 0 {
		log.Error("There is No Tours Deleted!")
		return false
	}

	return true
}
func (svc *service) ValidateInput(input dtos.InputTours, fileHeader *multipart.FileHeader) ([]string, error) {
	const (
		minTitleLength      = 19
		maxDescriptionLength = 4999
		maxFileSize          = 2 * 1024 * 1024
	)

	var errorList []string

	if errMap := svc.validator.ValidateRequest(input); errMap != nil {
		errorList = append(errorList, errMap...)
	}

	if fileHeader != nil {
		file, err := fileHeader.Open()
		if err != nil {
			return nil, err
		}
		defer file.Close()

		buffer := make([]byte, 512)
		_, err = file.Read(buffer)

		if err != nil {
			return nil, err
		}

		contentType := http.DetectContentType(buffer)
		isImage := contentType[:5] == "image"

		if !isImage {
			errorList = append(errorList, "file must be image (png, jpg, or jpeg)")
		}

		fileSize, err := io.CopyN(ioutil.Discard, file, maxFileSize+1)
		if err != nil && err != io.EOF {
			return nil, err
		}

		if fileSize > maxFileSize {
			errorList = append(errorList, "file size exceeds the allowed limit (2MB)")
		}
	}

	return errorList, nil
}