package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"net/http"
	"time"
)

var port = flag.String("port", "3000", "Specify port for http server")
var text = flag.String("text", "Hello", "Specify the response text")

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
	http.HandleFunc("/", answer)
	log.Printf("Server listening to port: %s with text: %s\n", *port, *text)
	log.Fatal(http.ListenAndServe(":"+*port, nil))
}
