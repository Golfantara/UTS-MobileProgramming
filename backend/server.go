package main

import (
	"fmt"
	"net/http"
	"uts-flutter/config"
	"uts-flutter/features/auth"
	"uts-flutter/features/tours"
	"uts-flutter/helpers"
	"uts-flutter/middlewares"
	"uts-flutter/routes"
	"uts-flutter/utils"

	"github.com/labstack/echo/v4"

	ah "uts-flutter/features/auth/handler"
	ar "uts-flutter/features/auth/repository"
	au "uts-flutter/features/auth/usecase"

	th "uts-flutter/features/tours/handler"
	tr "uts-flutter/features/tours/repository"
	tu "uts-flutter/features/tours/usecase"
)

func main() {
	e := echo.New()
	cfg := config.InitConfig()
	jwtService := helpers.NewJWT(*cfg)
	
	middlewares.LogMiddlewares(e)
	routes.Auth(e, AuthHandler(), jwtService, *cfg)
	routes.Tours(e, ToursHandler(), jwtService, *cfg)

	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello anjay mabar!")
	})
	e.Start(fmt.Sprintf(":%s", cfg.SERVER_PORT))
}

func AuthHandler() auth.Handler{
	config := config.InitConfig()

	db := utils.InitDB()
	jwt := helpers.NewJWT(*config)
	hash := helpers.NewHash()
	validation := helpers.NewValidationRequest()

	repo := ar.New(db)
	ac := au.New(repo, jwt, hash, validation)
	return ah.New(ac)
}

func ToursHandler() tours.Handler{
	config := config.InitConfig()
	cdn := utils.CloudinaryInstance(*config)
	db := utils.InitDB()
	validation := helpers.NewValidationRequest()

	repo := tr.New(db, cdn, config)
	tc := tu.New(repo, validation)
	return  th.New(tc)
}