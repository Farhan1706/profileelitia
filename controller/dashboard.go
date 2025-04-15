package controller

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"unicode"

	"github.com/Farhan1706/profileelitia/models"
)

func splitPath(path string) []string {
	return strings.Split(path, "/")
}

func sub1(i int) int {
	if i <= 0 {
		return 0
	}
	return i - 1
}

func title(s string) string {
	words := strings.Split(strings.ReplaceAll(s, "-", " "), " ")
	for i, w := range words {
		if len(w) > 0 {
			runes := []rune(w)
			runes[0] = unicode.ToUpper(runes[0])
			for j := 1; j < len(runes); j++ {
				runes[j] = unicode.ToLower(runes[j])
			}
			words[i] = string(runes)
		}
	}
	return strings.Join(words, " ")
}

func LandingPage() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		data := map[string]interface{}{
			"Title":       "Dashboard - Elitia",
			"CurrentPath": r.URL.Path,
		}

		if err := RenderTemplate(w, "dashboard.html", data); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	}
}

func DataLog() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		data := map[string]interface{}{
			"Title":       "Data Log",
			"CurrentPath": r.URL.Path,
		}

		if err := RenderTemplate(w, "log.html", data); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	}
}

func GetLogs(db *sql.DB) http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        limit := r.URL.Query().Get("length")
        offset := r.URL.Query().Get("start")

        query := fmt.Sprintf(`
            SELECT log_id, action, table_name, record_id, user_id, previous_data, new_data, timestamp
            FROM activity_logs
            LIMIT %s OFFSET %s`, limit, offset)

        rows, err := db.Query(query)
        if err != nil {
            http.Error(w, fmt.Sprintf("Failed to fetch logs: %v", err), http.StatusInternalServerError)
            return
        }
        defer rows.Close()

        var logs []models.Log

        for rows.Next() {
            var log models.Log
            if err := rows.Scan(&log.LogID, &log.Action, &log.TableName, &log.RecordID, &log.UserID, &log.PreviousData, &log.NewData, &log.Timestamp); err != nil {
                http.Error(w, fmt.Sprintf("Error scanning data: %v", err), http.StatusInternalServerError)
                return
            }
            logs = append(logs, log)
        }

        if err := rows.Err(); err != nil {
            http.Error(w, fmt.Sprintf("Error iterating rows: %v", err), http.StatusInternalServerError)
            return
        }

        response := map[string]interface{}{
            "draw":            1,
            "recordsTotal":    len(logs),
            "recordsFiltered": len(logs),
            "data":            logs,
        }

        w.Header().Set("Content-Type", "application/json")
        json.NewEncoder(w).Encode(response)
    }
}