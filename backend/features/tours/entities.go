package tours

import (
	"time"

	"gorm.io/gorm"
)

type Tours struct {
	gorm.Model

	ID 			int 	`gorm:"type:int(11)"`
	UserID      int     `gorm:"type:int(11)"`
	Name		string  `gorm:"type:string"`
	Provinsi 	string	`gorm:"type:string"`
	ProvinsiID  string  `gorm:"type:string"`
	Kabkot		string	`gorm:"type:string"`
	KabkotID  string  `gorm:"type:string"`
	Latitude    string	`gorm:"type:string"`
	Longtitude  string	`gorm:"type:string"`
	Images		string	`gorm:"type:text"`
	NewsCreated time.Time 
}

