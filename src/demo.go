package main

import (
    "net/http"
    "fmt"
    "log"
    "os"
)

func main () {
    http.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
        fmt.Fprint(writer, "Hello World")
    })
    http.HandleFunc("/bye", func(writer http.ResponseWriter, request *http.Request) {
        defer writer.(http.Flusher).Flush()
        fmt.Fprint(writer, "See you then")
        os.Exit(0)
    })
    log.Fatal(http.ListenAndServe(":8080", nil))
}
