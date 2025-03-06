package controller

import (
	"database/sql"
	"html/template"
	"net/http"
	"path/filepath"

	"golang.org/x/crypto/bcrypt"

	"github.com/gorilla/sessions"
)

var store = sessions.NewCookieStore([]byte("your-secret-key"))

func PageLogin(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			username := r.FormValue("username")
			password := r.FormValue("password")

			var storedUsername, storedPassword, storedRole string
			err := db.QueryRow("SELECT username, password, role FROM users WHERE username = ?", username).Scan(&storedUsername, &storedPassword, &storedRole)
			if err != nil {
				if err == sql.ErrNoRows {
					http.Redirect(w, r, "/lah-ngatur", http.StatusFound)
					return
				}
				w.Write([]byte(err.Error()))
				w.WriteHeader(http.StatusInternalServerError)
				return
			}

			err = bcrypt.CompareHashAndPassword([]byte(storedPassword), []byte(password))
			if err != nil {
				http.Redirect(w, r, "/lah-ngatur", http.StatusFound)
				return
			}

			session, _ := store.Get(r, "session-name")
			session.Values["username"] = storedUsername
			session.Values["role"] = storedRole

			if storedRole == "Tuhan" {
				http.Redirect(w, r, "/main", http.StatusFound)
			} else if storedRole == "Admin" {
				w.Write([]byte("Admin"))
			} else if storedRole == "Anggota" {
				w.Write([]byte("Anggota"))
			} else {
				w.Write([]byte("Unknown Role"))
			}

			session.Save(r, w)
			http.Redirect(w, r, "/", http.StatusFound)
			return
		}

		fp := filepath.Join("views", "login.html")
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

func Logout(w http.ResponseWriter, r *http.Request) {
	session, _ := store.Get(r, "session-name")

	// Menghapus session username dan role saat logout
	delete(session.Values, "username")
	delete(session.Values, "role")

	// Menyimpan session setelah perubahan
	session.Save(r, w)

	// Redirect ke halaman login setelah logout
	http.Redirect(w, r, "/lah-ngatur", http.StatusFound)
}
