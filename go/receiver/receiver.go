package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("Received request: %s %s from %s\n", r.Method, r.URL.Path, r.RemoteAddr)
	fmt.Fprintf(w, "Hello, World!\n")
}

func healthCheck(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusNoContent)
}
func main() {
	port := "80"
	fmt.Println("Listening on port:",port)
	http.HandleFunc("GET /healthz", healthCheck)
	http.HandleFunc("GET /", handler)
	http.ListenAndServe(":"+port, nil)
}
