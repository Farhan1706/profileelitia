package controller

import (
	"database/sql"
	"html/template"
	"net/http"
	"path/filepath"

	"golang.org/x/crypto/bcrypt" // Import bcrypt untuk hashing password
)

func PageRegister(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			nama := r.FormValue("nama")
			username := r.FormValue("username")
			password := r.FormValue("password")
			foto := r.FormValue("foto")

			// bcrypt
			hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
			if err != nil {
				w.Write([]byte("Error hashing password"))
				w.WriteHeader(http.StatusInternalServerError)
				return
			}

			_, err = db.Exec("INSERT INTO users (nama, role, username, password, img_url) VALUES (?,?,?,?,?)",
				nama, "Anggota", username, string(hashedPassword), foto)

			if err != nil {
				w.Write([]byte(err.Error()))
				w.WriteHeader(http.StatusInternalServerError)
				return
			}

			http.Redirect(w, r, "/lah-ngatur/", http.StatusMovedPermanently)
			return
		} else if r.Method == "GET" {
			fp := filepath.Join("views", "crt_akun.html")
			tmp, err := template.ParseFiles(fp)
			if err != nil {
				w.Write([]byte(err.Error()))
				w.WriteHeader(http.StatusInternalServerError)
				return
			}

			err = tmp.Execute(w, nil)
			if err != nil {
				w.Write([]byte(err.Error()))
				w.WriteHeader(http.StatusInternalServerError)
				return
			}
		}
	}
}
