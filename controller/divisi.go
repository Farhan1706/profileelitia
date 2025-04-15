package controller

import (
	"database/sql"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/Farhan1706/profileelitia/database"
	"github.com/google/uuid"
	"github.com/gorilla/mux"
)

const maxUploadSize = 10 << 20 // 10MB

type Division struct {
	ID          int
	Name        string
	Description string
	LeaderID    *int
	ImgURL      string
	CreatedAt   string
	DeletedAt   *string
}

type Divisi struct {
    ID          int
    Name        string
    Description string
    LeaderID    int
    ImgURL      string
    DeletedAt   sql.NullTime
}

type User struct {
    ID       int
    Username string
    Nama     string
    ImgURL   sql.NullString
}

func ShowDivisi(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		rows, err := db.Query(`
			SELECT id, name, description, leader_id, img_url, created_at, deleted_at
			FROM divisions
			WHERE deleted_at IS NULL
		`)
		if err != nil {
			http.Error(w, fmt.Sprintf("Failed to fetch divisions: %v", err), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		var divisions []Division
		for rows.Next() {
			var div Division
			if err := rows.Scan(&div.ID, &div.Name, &div.Description, &div.LeaderID, &div.ImgURL, &div.CreatedAt, &div.DeletedAt); err != nil {
				http.Error(w, fmt.Sprintf("Error scanning data: %v", err), http.StatusInternalServerError)
				return
			}
			divisions = append(divisions, div)
		}

		if err := rows.Err(); err != nil {
			http.Error(w, fmt.Sprintf("Error iterating rows: %v", err), http.StatusInternalServerError)
			return
		}

		// Kirim data divisi ke template
		data := map[string]interface{}{
			"Title":       "Manajemen Divisi",
			"CurrentPath": r.URL.Path,
			"Divisions":   divisions,
		}

		// Render template dengan data divisi
		if err := RenderTemplate(w, "show_divisi.html", data); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	}
}


func AddDivisi() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		db := database.InitDatabase()

		row, err := db.Query("SELECT id, username, nama FROM users")
		if err != nil {
			log.Fatal(err)
		}
		defer row.Close()
		
		var users []struct{
			ID int
			Username string
			Nama string
		}

		for row.Next() {
			var user struct {
				ID int
				Username string
				Nama string
			}
			if err := row.Scan(&user.ID, &user.Username, &user.Nama); err != nil {
				log.Fatal(err)
			}
			user.Username = strings.ToUpper(user.Username)
			users = append(users, user)
		}
		if err := row.Err(); err != nil {
			log.Fatal(err)
		}
		

		data := map[string]interface{}{
			"Title":       "Tambah Divisi",
			"CurrentPath": r.URL.Path,
			"Users": users,
		}

		if err := RenderTemplate(w, "tambah_divisi.html", data); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	}
}

func InsertDivisi(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "Invalid request method", http.StatusMethodNotAllowed)
			http.Redirect(w, r, "/divisi", http.StatusFound)
			return
		}

		err := r.ParseMultipartForm(maxUploadSize)
		if err != nil {
			http.Error(w, "Ukuran file terlalu besar. Maksimal 10MB.", http.StatusRequestEntityTooLarge)
			http.Redirect(w, r, "/divisi", http.StatusFound)
			return
		}

		file, _, err := r.FormFile("image")
		if err != nil && err.Error() != "http: no such file" {
			http.Error(w, "Gagal membaca file gambar", http.StatusBadRequest)
			http.Redirect(w, r, "/divisi", http.StatusFound)
			return
		}

		var fileName string
		if err == nil {
			err = os.MkdirAll("assets/images/uploads", os.ModePerm)
			if err != nil {
				http.Error(w, "Gagal membuat folder penyimpanan", http.StatusInternalServerError)
				http.Redirect(w, r, "/divisi", http.StatusFound)
				return
			}

			fileName = fmt.Sprintf("assets/images/uploads/%s.png", uuid.New().String())

			outFile, err := os.Create(fileName)
			if err != nil {
				http.Error(w, "Gagal membuat file gambar", http.StatusInternalServerError)
				http.Redirect(w, r, "/divisi", http.StatusFound)
				return
			}
			defer outFile.Close()

			_, err = io.Copy(outFile, file)
			if err != nil {
				http.Error(w, "Gagal menyimpan gambar", http.StatusInternalServerError)
				http.Redirect(w, r, "/divisi", http.StatusFound)
				return
			}
		} else {
			fileName = ""
		}

		name := r.FormValue("name")
		description := r.FormValue("description")
		leader_id := r.FormValue("leader_id")

		query := `
			INSERT INTO divisions (name, description, leader_id, img_url, created_at)
			VALUES (?, ?, ?, ?, NOW())
		`

		_, err = db.Exec(query, name, description, leader_id, fileName)
		if err != nil {
			log.Fatal(err)
			http.Error(w, "Failed to insert into database", http.StatusInternalServerError)
			http.Redirect(w, r, "/divisi", http.StatusFound)
			return
		}

		http.Redirect(w, r, "/divisi", http.StatusFound)
	}
}

func EditDivisi(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		id := vars["id"] 

		var divisi Divisi
		err := db.QueryRow("SELECT id, name, description, leader_id, img_url FROM divisions WHERE id = ?", id).Scan(&divisi.ID, &divisi.Name, &divisi.Description, &divisi.LeaderID, &divisi.ImgURL)
		if err != nil {
			http.Error(w, "Divisi tidak ditemukan", http.StatusNotFound)
			return
		}

		rows, err := db.Query("SELECT id, username, nama FROM users")
		if err != nil {
			http.Error(w, "Gagal memuat data ketua divisi", http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		var users []User
		for rows.Next() {
			var user User
			if err := rows.Scan(&user.ID, &user.Username, &user.Nama); err != nil {
				http.Error(w, "Gagal memuat data pengguna", http.StatusInternalServerError)
				return
			}
			user.Username = strings.ToUpper(user.Username)
			users = append(users, user)
		}

		data := map[string]interface{}{
			"Title":       "Sunting Divisi",
			"CurrentPath": r.URL.Path,
			"Divisi":      divisi, 
			"Users":       users,  
		}


		if err := RenderTemplate(w, "sunting_divisi.html", data); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	}
}