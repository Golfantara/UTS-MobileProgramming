package routes

import (
	"uts-flutter/features/tours"

	"github.com/labstack/echo/v4"
)

func Tours(e *echo.Echo, handler tours.Handler){
	tours := e.Group("/tours")

	tours.POST("", handler.CreateTours())

	tours.GET("", handler.GetTours())
	tours.GET("/:id", handler.ToursDetails())

	tours.PUT("/:id", handler.UpdateTours())

	tours.DELETE("/:id", handler.DeleteTours())
}