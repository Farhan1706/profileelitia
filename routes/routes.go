package routes

import (
	"database/sql"
	"net/http"

	"github.com/Farhan1706/profileelitia/controller"
)

func MapRoutes(server *http.ServeMux, db *sql.DB) {
	server.HandleFunc("/logout/", controller.Logout)
	server.HandleFunc("/", controller.NewIndexUtama())
	server.HandleFunc("/lah-ngatur/", controller.PageLogin(db))
	server.HandleFunc("/lah-ngatur/oprec/", controller.PageRegister(db))
	server.HandleFunc("/main/", controller.LandingPage())

	// File Statis
	server.Handle("/assets/", http.StripPrefix("/assets/", http.FileServer(http.Dir("./assets"))))
	server.Handle("/frontend/", http.StripPrefix("/frontend/", http.FileServer(http.Dir("./frontend"))))
}
