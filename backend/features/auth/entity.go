package auth

import (
	"time"
	"uts-flutter/features/tours"

	"gorm.io/gorm"
)

type User struct {
	ID             int    `gorm:"primaryKey;type:int(11)"`
	RoleID         int    `gorm:"type:int(1);default:1"`
	Username       string `gorm:"type:varchar(255);not null"`
	Fullname	   string `gorm:"type:varchar(255);not null"`
	Password       string `gorm:"type:varchar(255);not null"`
	CreatedAt      time.Time
	UpdatedAt      time.Time
	DeletedAt      gorm.DeletedAt `gorm:"index"`

	Tours		   []tours.Tours `gorm:"foreignKey:UserID;references:ID"`
}