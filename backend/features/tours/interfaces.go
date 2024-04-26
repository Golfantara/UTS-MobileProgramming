package tours

import (
	"mime/multipart"
	"time"
	"uts-flutter/features/tours/dtos"

	"github.com/labstack/echo/v4"
)

type Repository interface {
	Paginate(page, size int) []Tours
	Insert(newTours *Tours) (*Tours, error)
	SelectByID(toursID int) *Tours
	Update(tours Tours) int64
	DeleteByID(toursID int) int64
	UploadFile(fileHeader *multipart.FileHeader, name string) (string, error)
	GetTotalDataTours() int64
	GetTimeNow() time.Time
}

type Usecase interface {
	FindAll(page, size int) ([]dtos.ResTours, int64) 
	FindByID(newsID int) *dtos.ResTours
	Create(newNews dtos.InputTours,file *multipart.FileHeader) (*dtos.ResTours,[]string, error)
	Modify(newsData dtos.InputTours, newsID int, file *multipart.FileHeader) bool
	Remove(newsID int) bool
}

type Handler interface {
	GetTours() echo.HandlerFunc
	ToursDetails() echo.HandlerFunc
	CreateTours() echo.HandlerFunc
	UpdateTours() echo.HandlerFunc
	DeleteTours() echo.HandlerFunc
}
