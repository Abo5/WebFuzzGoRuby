package main

import (
    "bufio"
    "flag"
    "fmt"
    "os"
    "time"
	"strings"
    "github.com/valyala/fasthttp"
)

func displayLogo() {
    logo := `
    ... [ create by Maven watch yourself ] ...
    ... [ version 2.0 ] ...
    `
    fmt.Println(logo)
}

func requestAndPrint(url string, foundCount *int) {
    req := fasthttp.AcquireRequest()
    defer fasthttp.ReleaseRequest(req)
    req.SetRequestURI(url)

    resp := fasthttp.AcquireResponse()
    defer fasthttp.ReleaseResponse(resp)

    err := fasthttp.Do(req, resp)
    if err != nil {
        fmt.Printf("\r[-] %s - Error: %s\n", url, err)
        return
    }

    responseSize := len(resp.Body())
    statusInfo := fmt.Sprintf("(CODE:%d|SIZE:%d)", resp.StatusCode(), responseSize)

	if resp.StatusCode() == fasthttp.StatusOK {
		// Print successful requests on a new line
		fmt.Printf("\r+ %s %s\n", url, statusInfo)
		*foundCount++
	} else {
		// Overwrite the same line for unsuccessful requests
		fmt.Printf("\rChecking: %s%s", url, strings.Repeat(" ", 20))
	}
	// Ensure the output is flushed immediately
	fmt.Print("")
}

func main() {
    var mode, url string
    var count, timeout int

    flag.StringVar(&mode, "mode", "", "Select mode: 'random' or 'wordlist'")
    flag.StringVar(&url, "url", "", "The target URL with http/https")
    flag.IntVar(&count, "count", 10, "Number of random strings (default: 10)")
    flag.IntVar(&timeout, "timeout", 5, "Timeout of requests (default: 5 seconds)")
    flag.Parse()

    if mode == "" || url == "" {
        fmt.Println("Missing required arguments")
        flag.Usage()
        return
    }

    displayLogo()

	if !strings.HasSuffix(url, "/") {
        url += "/"
    }
	
    foundCount := 0
    startTime := time.Now()
    fmt.Printf("\n\nSTART_TIME: %s\n", startTime)
    fmt.Printf("URL_BASE: %s\n", url)

    if mode == "wordlist" {
        wordlistPath := "./wordlist.txt"

        file, err := os.Open(wordlistPath)
        if err != nil {
            fmt.Printf("Error opening wordlist file: %s\n", err)
            return
        }
        defer file.Close()

        scanner := bufio.NewScanner(file)
        for scanner.Scan() {
            requestAndPrint(url+scanner.Text(), &foundCount)
        }

        if err := scanner.Err(); err != nil {
            fmt.Printf("Error reading wordlist file: %s\n", err)
            return
        }
    }

    endTime := time.Now()
    fmt.Printf("\nEND_TIME: %s\n", endTime)
    fmt.Printf("DOWNLOADED: %d - FOUND: %d\n", count, foundCount)
}