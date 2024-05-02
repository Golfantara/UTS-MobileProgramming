package dtos

import "time"

type ResTours struct {
	ID			int		`json:"id" form:"id"`
	UserID		int		`json:"user_id" form:"user_id"`
	Name       string `json:"name" form:"name"`
	ProvinsiID string `json:"provinsi_id" form:"provinsi_id"`
	Provinsi   string `json:"provinsi" form:"provinsi"`
	KabkotID string `json:"kabkot_id" form:"kabkot_id"`
	Kabkot     string `json:"kabkot" form:"kabkot"`
	Latitude   string `json:"latitude" form:"latitude"`
	Longtitude string `json:"longtitude" form:"longtitude"`
	Images     string `json:"images" form:"images"`
	ToursCreated	time.Time `json:"created_at" form:"created_at"`
}