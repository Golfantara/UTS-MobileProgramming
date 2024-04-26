package dtos

import "time"

type ResTours struct {
	ID			int		`json:"id" form:"id"`
	Name       string `json:"name" form:"name"`
	Provinsi   string `json:"provinsi" form:"provinsi"`
	Kabkot     string `json:"kabkot" form:"kabkot"`
	Latitude   string `json:"latitude" form:"latitude"`
	Longtitude string `json:"longtitude" form:"longtitude"`
	Images     string `json:"images" form:"images"`
	ToursCreated	time.Time `json:"created_at" form:"created_at"`
}