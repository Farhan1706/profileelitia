package routes

import (
	"database/sql"
	"net/http"

	"github.com/Farhan1706/profileelitia/controller"
	"github.com/gorilla/mux"
)

func MapRoutes(server *http.ServeMux, db *sql.DB) {
    r := mux.NewRouter()

    r.HandleFunc("/logout/", controller.Logout)
    r.HandleFunc("/", controller.NewIndexUtama(db))
    r.HandleFunc("/lah-ngatur", controller.PageLogin(db))
    r.HandleFunc("/lah-ngatur/oprec/", controller.PageRegister(db))
    r.HandleFunc("/main", controller.LandingPage())
    r.HandleFunc("/log", controller.DataLog())
    r.HandleFunc("/log/data", controller.GetLogs(db))
    r.HandleFunc("/divisi", controller.ShowDivisi(db))
    r.HandleFunc("/divisi/tambah", controller.AddDivisi())
    r.HandleFunc("/divisi/sunting/{id}", controller.EditDivisi(db))
    r.HandleFunc("/divisi/tambah/proses", controller.InsertDivisi(db))

    // file statis
    r.PathPrefix("/assets/").Handler(http.StripPrefix("/assets/", http.FileServer(http.Dir("./assets"))))

    server.Handle("/", r)
}

