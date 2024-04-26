package repository

import (
	"context"
	"fmt"
	"mime/multipart"
	"time"
	"uts-flutter/config"
	"uts-flutter/features/tours"
	"uts-flutter/helpers"

	"github.com/cloudinary/cloudinary-go"
	"github.com/cloudinary/cloudinary-go/api/uploader"
	"github.com/labstack/gommon/log"
	"gorm.io/gorm"
)

type model struct {
	db *gorm.DB
	cdn *cloudinary.Cloudinary
	config *config.ProgramConfig
}

func New(db *gorm.DB, cdn *cloudinary.Cloudinary, config *config.ProgramConfig) tours.Repository {
	return &model {
		db: db,
		cdn: cdn,
		config: config,
	}
}

func (mdl *model) Paginate(page, size int) []tours.Tours {
	var tours []tours.Tours

	offset := (page - 1) * size

	result := mdl.db.Offset(offset).Limit(size).Find(&tours)
	
	if result.Error != nil {
		log.Error(result.Error)
		return nil
	}

	return tours
}

func (mdl *model) Insert(newTours *tours.Tours) (*tours.Tours, error) {
	result := mdl.db.Create(&newTours)

	if result.Error != nil {
		log.Error(result.Error)
		return nil, result.Error
	}

	return newTours, nil
}

func (mdl *model) SelectByID(toursID int) *tours.Tours {
	var tours tours.Tours
	result := mdl.db.First(&tours, toursID)

	if result.Error != nil {
		log.Error(result.Error)
		return nil
	}

	return &tours
}

func (mdl *model) Update(tours tours.Tours) int64 {
	result := mdl.db.Updates(&tours)

	if result.Error != nil {
		log.Error(result.Error)
	}

	return result.RowsAffected
}

func (mdl *model) DeleteByID(toursID int) int64 {
	result := mdl.db.Delete(&tours.Tours{}, toursID)
	
	if result.Error != nil {
		log.Error(result.Error)
		return 0
	}

	return result.RowsAffected
}

func (mdl *model) UploadFile(fileHeader *multipart.FileHeader, name string) (string, error){
	file := helpers.OpenFileHeader(fileHeader)

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	cfg := mdl.config.CDN_FOLDER_NAME

	resp, err := mdl.cdn.Upload.Upload(ctx, file, uploader.UploadParams{
		Folder: cfg,
		PublicID: name,
	})

	if err != nil {
		fmt.Println(err.Error())
		return "", nil
	}
	return resp.SecureURL, nil
}

func (mdl *model) GetTotalDataTours() int64 {
	var totalData int64

	result := mdl.db.Table("news").Where("deleted_at IS NULL").Count(&totalData)

	if result.Error != nil {
		log.Error(result.Error)
		return 0
	}

	return totalData
}

func (mdl *model) GetTimeNow() time.Time {
	wibLocation, _ := time.LoadLocation("Asia/Jakarta")

	return time.Now().In(wibLocation)
}