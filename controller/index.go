package controller

import (
	"html/template"
	"net/http"
	"path/filepath"
)

func ServeAssets(w http.ResponseWriter, r *http.Request) {
	filePath := filepath.Join("assets", r.URL.Path)
	http.ServeFile(w, r, filePath)
}

func NewIndexUtama() func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		fp := filepath.Join("views", "index.html")
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
