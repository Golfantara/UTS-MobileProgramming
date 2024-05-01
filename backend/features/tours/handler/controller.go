package handler

import (
	"errors"
	"strconv"
	"uts-flutter/helpers"

	"uts-flutter/features/tours"
	"uts-flutter/features/tours/dtos"

	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
)

type controller struct {
	service tours.Usecase
}

func New(service tours.Usecase) tours.Handler {
	return &controller {
		service: service,
	}
}

var validate *validator.Validate

func (ctl *controller) GetTours() echo.HandlerFunc {
	return func (ctx echo.Context) error  {
		pagination := dtos.Pagination{}
		ctx.Bind(&pagination)
		userID := ctx.Get("user_id").(int)

		if pagination.Page < 1 || pagination.Size < 1 {
			pagination.Page = 1
			pagination.Size = 5
		}
		
		page := pagination.Page
		size := pagination.Size

		tourss, totalData := ctl.service.FindAll(userID, page, size)

		if len(tourss) == 0 {
			return ctx.JSON(404, helpers.Response("There is No Tours!", map[string]any{
				"data": []string{},
			}))
		}

		paginationResponse := helpers.PaginationResponse(page, size, int(totalData))

		return ctx.JSON(200, helpers.Response("Success!", map[string]any {
			"data": tourss,
			"pagination":paginationResponse,
		}))
	}
}


func (ctl *controller) ToursDetails() echo.HandlerFunc {
	return func (ctx echo.Context) error  {
		toursID, err := strconv.Atoi(ctx.Param("id"))

		if err != nil {
			return ctx.JSON(400, helpers.Response(err.Error()))
		}

		tours := ctl.service.FindByID(toursID)

		if tours.ID < 0 {
			return ctx.JSON(404, helpers.Response("Tours Not Found!", map[string]any{
				"data":tours,
			}))
		}

		return ctx.JSON(200, helpers.Response("Success!", map[string]any {
			"data": tours,
		}))
	}
}

func (ctl *controller) CreateTours() echo.HandlerFunc {
	return func(ctx echo.Context) error {
		input := dtos.InputTours{}
		fileHeader, err := ctx.FormFile("images")
		if err != nil {
			return ctx.JSON(400, helpers.Response("missing some data", map[string]any{
				"error": err,
			}))
		}

		ctx.Bind(&input)
		userID := ctx.Get("user_id").(int)

		validate := validator.New(validator.WithRequiredStructEnabled())

		err = validate.Struct(input)

		if err != nil {
			errMap := helpers.ErrorMapValidation(err)
			return ctx.JSON(400, helpers.Response("Bad Request!", map[string]any {
				"error": errMap,
			}))
		}

		tours,errMap, err := ctl.service.Create(input, userID, fileHeader)
		
		if errMap != nil {
			return ctx.JSON(400, helpers.Response("missing some data", map[string]any{
				"error": errMap,
			}))
		}

		if err != nil {
			return errors.New("failed to create")
		}
		if tours == nil {
			return ctx.JSON(500, helpers.Response("something went wrong!", nil))
		}
		return ctx.JSON(200, helpers.Response("succes", map[string]any {
			"data": tours,
		}))
	}
}

func (ctl *controller) UpdateTours() echo.HandlerFunc {
	return func (ctx echo.Context) error {
		input := dtos.InputTours{}

		fileHeader, err := ctx.FormFile("images")

		toursID, errParam := strconv.Atoi(ctx.Param("id"))

		if errParam != nil {
			return ctx.JSON(400, helpers.Response(errParam.Error()))
		}

		tours := ctl.service.FindByID(toursID)

		if tours == nil {
			return ctx.JSON(404, helpers.Response("Tours Not Found!"))
		}
		
		ctx.Bind(&input)

		validate = validator.New(validator.WithRequiredStructEnabled())
		err = validate.Struct(input)

		if err != nil {
			errMap := helpers.ErrorMapValidation(err)
			return ctx.JSON(400, helpers.Response("Bad Request!", map[string]any {
				"error": errMap,
			}))
		}

		update := ctl.service.Modify(input, toursID, fileHeader)

		if !update {
			return ctx.JSON(500, helpers.Response("Something Went Wrong!"))
		}

		return ctx.JSON(200, helpers.Response("News Success Updated!"))
	}
}

func (ctl *controller) DeleteTours() echo.HandlerFunc {
	return func (ctx echo.Context) error  {
		toursID, err := strconv.Atoi(ctx.Param("id"))

		if err != nil {
			return ctx.JSON(400, helpers.Response(err.Error()))
		}

		tours := ctl.service.FindByID(toursID)

		if tours == nil {
			return ctx.JSON(404, helpers.Response("tours Not Found!"))
		}

		delete := ctl.service.Remove(toursID)

		if !delete {
			return ctx.JSON(500, helpers.Response("Something Went Wrong!"))
		}

		return ctx.JSON(200, helpers.Response("News Success Deleted!", map[string]any{
			"data":tours,
		}))
	}
}