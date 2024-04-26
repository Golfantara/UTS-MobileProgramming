package dtos

type InputTours struct {
	Name       string `json:"name" form:"name"`
	Provinsi   string `json:"provinsi" form:"provinsi"`
	Kabkot     string `json:"kabkot" form:"kabkot"`
	Latitude   string `json:"latitude" form:"latitude"`
	Longtitude string `json:"longtitude" form:"longtitude"`
	Images     string `json:"images" form:"images"`
}

type Pagination struct {
	Page int `query:"page"`
	Size int `query:"page_size"`
}