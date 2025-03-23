package main

import (
	"fmt"
	"net/http"
	"net/http/httptrace"
	"os"
	"strconv"
	"time"
)

func main() {
	seconds := checkSecondsVar("SECS")
	timeout := checkSecondsVar("TIMEOUT")
	endpoint := "http://" + os.Getenv("URL") + "/"
	PlaysForever(seconds,timeout, endpoint)
}

func checkSecondsVar(varName string) int {
	seconds, err := strconv.Atoi(os.Getenv(varName))

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	} else if seconds < 1 {
		fmt.Println("Please define seconds more than 1",varName)
		os.Exit(1)
	}

	return seconds
}

func play(ch chan struct{}, seconds int) {

	time.Sleep(time.Duration(seconds) * time.Second)
	ch <- struct{}{}
}

func PlaysForever(seconds int,timeout int, endpoint string) {
	wait := make(chan struct{})
	for {
		MakeRequest(endpoint,timeout)
		go play(wait, seconds)
		<-wait
	}
}

func MakeRequest(endpoint string,timeout int) {
	client := &http.Client{
		Timeout: time.Duration(timeout) * time.Second,
	}

	req, err := http.NewRequest("GET", endpoint, nil) // Replace with your URL
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	var lastIP string

	trace := &httptrace.ClientTrace{
		GotConn: func(connInfo httptrace.GotConnInfo) {
			if connInfo.Conn != nil { //check for nil
				lastIP = connInfo.Conn.RemoteAddr().String()
			}
		},
	}

	req = req.WithContext(httptrace.WithClientTrace(req.Context(), trace))
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error performing request:", err)
		return
	}
	fmt.Println("Response Status:", resp.StatusCode, "ip:", lastIP)
	resp.Body.Close()
	return
}
