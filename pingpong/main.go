package main

import (
	"flag"
	"fmt"
	"math/rand"
	"net/http"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	log "github.com/sirupsen/logrus"
)

var (
	port   = flag.Int("port", 8080, "The server port")
	phrase = flag.String("phrase", "ping", "the reponse phrase")

	opsProcessed = promauto.NewCounter(prometheus.CounterOpts{
		Name: "health_ops_total",
		Help: "The total number of processed events",
	})
)

// EchoHandler echos back the request as a response
func EchoHandler(writer http.ResponseWriter, request *http.Request) {

	log.Println("Echoing back request made to " + request.URL.Path + " to client (" + request.RemoteAddr + ")")

	writer.Header().Set("Access-Control-Allow-Origin", "*")

	// allow pre-flight headers
	writer.Header().Set("Access-Control-Allow-Headers", "Content-Range, Content-Disposition, Content-Type, ETag")

	request.Write(writer)
}

func PingPongHandler(writer http.ResponseWriter, request *http.Request) {

	log.Println("Echoing back request made to " + request.URL.Path + " to client (" + request.RemoteAddr + ")")

	writer.Header().Set("Access-Control-Allow-Origin", "*")

	// allow pre-flight headers
	writer.Header().Set("Access-Control-Allow-Headers", "Content-Range, Content-Disposition, Content-Type, ETag")

	if *phrase == "ping" {
		fmt.Fprintf(writer, "pong\n")
	} else {
		fmt.Fprintf(writer, "ping\n")
	}

	request.Write(writer)
}

func PingPongClient() {
	var url string
	if *phrase == "ping" {
		url = fmt.Sprintf("http://pong:%d/pong", *port)
	} else {
		url = fmt.Sprintf("http://ping:%d/ping", *port)
	}

	for {
		wait := time.Second * time.Duration(rand.Int()%10)
		log.Printf("Waiting %v seconds\n", wait)
		time.Sleep(wait)
		resp, err := http.Get(url)
		if err != nil {
			log.Errorf("Error %v", err)
		} else {
			log.Println(resp)
		}
	}
}

func HealthHandler(writer http.ResponseWriter, request *http.Request) {
	opsProcessed.Inc()
	log.Println("Echoing back health request made to " + request.URL.Path + " to client (" + request.RemoteAddr + ")")

	writer.Header().Set("Access-Control-Allow-Origin", "*")

	// allow pre-flight headers
	writer.Header().Set("Access-Control-Allow-Headers", "Content-Range, Content-Disposition, Content-Type, ETag")

	fmt.Fprintf(writer, "true\n")

	request.Write(writer)
}

func main() {
	flag.Parse()

	log.Println("starting server, listening on port " + fmt.Sprintf("%v", (*port)))

	http.HandleFunc("/", EchoHandler)
	http.HandleFunc(fmt.Sprintf("/%s", *phrase), PingPongHandler)
	http.HandleFunc("/health", HealthHandler)
	http.Handle("/metrics", promhttp.Handler())

	go PingPongClient()

	http.ListenAndServe(":"+fmt.Sprintf("%v", (*port)), nil)

}
