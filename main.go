package main

import (
	"net/http"
	"strings"

	"github.com/Farhan1706/profileelitia/database"
	"github.com/Farhan1706/profileelitia/routes"
)

func main() {
	db := database.InitDatabase()
	server := http.NewServeMux()

	routes.MapRoutes(server, db)

	err := http.ListenAndServe(":8081", server)
	if err != nil {
		panic(err)
	}

}

func splitPath(path string) []string {
	return strings.Split(path, "/")
}

func sub1(i int) int {
	if i == 0 {
		return 0
	}
	return i - 1
}

func title(s string) string {
	return strings.Title(strings.ReplaceAll(s, "-", " "))
}
