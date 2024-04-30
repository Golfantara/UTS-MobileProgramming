package routes

import (
	"uts-flutter/config"
	"uts-flutter/features/auth"
	"uts-flutter/helpers"

	m "uts-flutter/middlewares"

	"github.com/labstack/echo/v4"
)

func Auth(e *echo.Echo, handler auth.Handler, jwt helpers.JWTInterface, config config.ProgramConfig){
	auth := e.Group("/auth")
	auth.POST("/register", handler.RegisterUser())
	auth.POST("/login", handler.Login())
	auth.POST("/refresh-jwt", handler.RefreshJWT(), m.AuthorizeJWT(jwt, 3, config.SECRET) )
	auth.GET("/me", handler.MyProfile(), m.AuthorizeJWT(jwt, 3, config.SECRET))
}