package utils

import (
	"fmt"
	"uts-flutter/config"

	"github.com/cloudinary/cloudinary-go"
)

func CloudinaryInstance(config config.ProgramConfig) *cloudinary.Cloudinary {
	var urlCloudinary = fmt.Sprintf("cloudinary://%s:%s@%s",
		config.CDN_API_KEY,
		config.CDN_API_SECRET,
		config.CDN_CLOUD_NAME)

	CDNService, err := cloudinary.NewFromURL(urlCloudinary)
	if err != nil {
		return nil
	}

	return CDNService
}