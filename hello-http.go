package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"
)

var (
	Version string
	Build   string
)

var (
	version = flag.Bool("version", false, "Version of hello-http-go")
	port    = flag.String("port", "3000", "Specify port for http server")
	text    = flag.String("text", "Hello", "Specify the response text")
)

type response struct {
	Text string `json:"text"`
	Time string `json:"time"`
}

func answer(w http.ResponseWriter, r *http.Request) {
	data, err := json.Marshal(&response{Text: *text, Time: time.Now().Format("2006-01-02 15:04:05")})
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(w, "Error occured: %s", err.Error())
	}
	w.Write(data)
}

func main() {
	flag.Parse()

	if *version {
		fmt.Printf("hello-http-go [version: %s, build: %s]\n", Version, Build)
		os.Exit(0)
	}
	http.HandleFunc("/", answer)
	log.Printf("Server listening to port: %s with text: %s\n", *port, *text)
	log.Fatal(http.ListenAndServe(":"+*port, nil))
}
