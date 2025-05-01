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

type Organisasi struct {
	ID          int
	Deskripsi   string
}

// ShowDeskripsi menampilkan deskripsi organisasi.
func ShowDeskripsi(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var organisasi Organisasi
		err := db.QueryRow("SELECT id, deskripsi FROM description LIMIT 1").Scan(&organisasi.ID, &organisasi.Deskripsi)
		if err != nil {
			if err == sql.ErrNoRows {
				// Jika tidak ada data, tampilkan pesan.
				organisasi.Deskripsi = "Belum ada deskripsi organisasi yang tersedia."
			} else {
				// Tangani kesalahan database lainnya.
				http.Error(w, fmt.Sprintf("Gagal mengambil data organisasi: %v", err), http.StatusInternalServerError)
				return
			}
		}

		data := map[string]interface{}{
			"Title":       "Deskripsi Organisasi",
			"Organisasi":  organisasi,
		}

		fp := filepath.Join("views", "organisasi", "deskripsi.html") // Pastikan path benar
		tmpl, err := template.ParseFiles(fp)
		if err != nil {
			log.Println(err)
			http.Error(w, "Gagal memproses template", http.StatusInternalServerError)
			return
		}

		err = tmpl.Execute(w, data)
		if err != nil {
			log.Println(err)
			http.Error(w, "Gagal mengeksekusi template", http.StatusInternalServerError)
			return
		}
	}
}

// EditDeskripsiForm menampilkan formulir untuk mengedit deskripsi organisasi.
func EditDeskripsiForm(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var organisasi Organisasi
		err := db.QueryRow("SELECT id, deskripsi FROM description LIMIT 1").Scan(&organisasi.ID, &organisasi.Deskripsi)
		if err != nil {
			if err == sql.ErrNoRows {
				organisasi.Deskripsi = "" // Set deskripsi kosong jika tidak ada di database
			} else {
				http.Error(w, fmt.Sprintf("Gagal mengambil data organisasi: %v", err), http.StatusInternalServerError)
				return
			}
		}

		data := map[string]interface{}{
			"Title":       "Edit Deskripsi Organisasi",
			"Organisasi":  organisasi,
		}

		fp := filepath.Join("views", "organisasi", "edit_deskripsi.html") // Pastikan path benar
		tmpl, err := template.ParseFiles(fp)
		if err != nil {
			log.Println(err)
			http.Error(w, "Gagal memproses template", http.StatusInternalServerError)
			return
		}

		err = tmpl.Execute(w, data)
		if err != nil {
			log.Println(err)
			http.Error(w, "Gagal mengeksekusi template", http.StatusInternalServerError)
			return
		}
	}
}

// UpdateDeskripsi memperbarui deskripsi organisasi di database.
func UpdateDeskripsi(db *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "Metode tidak diizinkan", http.StatusMethodNotAllowed)
			return
		}

		// Ambil deskripsi dari form
		err := r.ParseForm()
		if err != nil {
			http.Error(w, "Gagal memproses form", http.StatusBadRequest)
			return
		}
		deskripsi := r.Form.Get("deskripsi")

		// Asumsikan ID deskripsi yang ingin diubah adalah 1.
		result, err := db.Exec("UPDATE description SET deskripsi = ? WHERE id = 1", deskripsi)
		if err != nil {
			http.Error(w, fmt.Sprintf("Gagal memperbarui deskripsi organisasi: %v", err), http.StatusInternalServerError)
			return
		}

		rowsAffected, err := result.RowsAffected()
		if err != nil {
			http.Error(w, fmt.Sprintf("Gagal mendapatkan jumlah baris yang terpengaruh: %v", err), http.StatusInternalServerError)
			return
		}

		if rowsAffected == 0 {
			http.Error(w, "Tidak ada data yang diubah. Deskripsi mungkin belum ada.", http.StatusBadRequest)
			return
		}

		// Setelah berhasil diperbarui, redirect ke halaman tampilan
		http.Redirect(w, r, "/organisasi/deskripsi", http.StatusFound)
	}
}
