package controller

import (
	"database/sql"
	"html/template"
	"log"
	"net/http"
	"path/filepath"
)

type indDivisi struct {
	ID          int
	Name        string
	Description string
	LeaderID    int
	ImgURL      string
	CreatedAt   string
	DeletedAt   *string
}

func ServeAssets(w http.ResponseWriter, r *http.Request) {
	filePath := filepath.Join("assets", r.URL.Path)
	http.ServeFile(w, r, filePath)
}

func NewIndexUtama(db *sql.DB) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		rows, err := db.Query("SELECT id, name, description, leader_id, img_url, created_at, deleted_at FROM divisions WHERE deleted_at IS NULL")
		if err != nil {
			log.Println("Error querying database:", err)
			w.Write([]byte(err.Error()))
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		var divisions []indDivisi
		for rows.Next() {
			var division indDivisi
			if err := rows.Scan(&division.ID, &division.Name, &division.Description, &division.LeaderID, &division.ImgURL, &division.CreatedAt, &division.DeletedAt); err != nil {
				log.Println("Error scanning rows:", err)
				w.Write([]byte(err.Error()))
				w.WriteHeader(http.StatusInternalServerError)
				return
			}
			divisions = append(divisions, division)
		}
		if err := rows.Err(); err != nil {
			log.Println("Error iterating rows:", err)
			w.Write([]byte(err.Error()))
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		funcMap := template.FuncMap{
			"add": func(x, y int) int {
				return x + y
			},
		}

		fp := filepath.Join("views", "index.html")
		tmp, err := template.New("index.html").Funcs(funcMap).ParseFiles(fp)
		if err != nil {
			w.Write([]byte(err.Error()))
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		err = tmp.Execute(w, divisions)
		if err != nil {
			w.Write([]byte(err.Error()))
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
	}
}
