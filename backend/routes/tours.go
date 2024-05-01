package routes

import (
	"uts-flutter/config"
	"uts-flutter/features/tours"
	"uts-flutter/helpers"

	m "uts-flutter/middlewares"

	"github.com/labstack/echo/v4"
)

func Tours(e *echo.Echo, handler tours.Handler, jwt helpers.JWTInterface, config config.ProgramConfig){
	tours := e.Group("/tours")

	tours.POST("", handler.CreateTours(), m.AuthorizeJWT(jwt, 3, config.SECRET))

	tours.GET("", handler.GetTours(), m.AuthorizeJWT(jwt, 3, config.SECRET))
	tours.GET("/:id", handler.ToursDetails(), m.AuthorizeJWT(jwt, 3, config.SECRET) )

	tours.PUT("/:id", handler.UpdateTours(), m.AuthorizeJWT(jwt, 3, config.SECRET))

	tours.DELETE("/:id", handler.DeleteTours(), m.AuthorizeJWT(jwt, 3, config.SECRET))
}