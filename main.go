package main

import (
	"net/http"

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
