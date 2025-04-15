package controller

import (
	"html/template"
	"net/http"
	"strings"
	"unicode"
)

func SplitPath(path string) []string {
	return strings.Split(path, "/")
}

func Sub1(i int) int {
	if i <= 0 {
		return 0
	}
	return i - 1
}

func Title(s string) string {
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

func RenderTemplate(w http.ResponseWriter, templateName string, data any) error {
	tmpl := template.New("layout.html").Funcs(template.FuncMap{
		"splitPath": SplitPath,
		"sub1":      Sub1,
		"title":     Title,
	})

	files := []string{
		"views/layout.html",
		"views/sidebar.html",
		"views/navbar.html",
		"views/footer.html",
		"views/" + templateName,
	}

	tmpl, err := tmpl.ParseFiles(files...)
	if err != nil {
		return err
	}

	return tmpl.ExecuteTemplate(w, "layout", data)
}
