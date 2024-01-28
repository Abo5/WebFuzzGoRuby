# README.md for Fuzzing Tools in Go and Ruby

## Description
**WebFuzzGoRuby:** Efficient Web Fuzzing Tools in Go and Ruby

WebFuzzGoRuby offers a pair of powerful, easy-to-use web fuzzing tools, developed in both Go and Ruby. These tools are designed for web security enthusiasts and professionals to perform fuzz testing on web applications. Efficient and adaptable, they support both random string generation and wordlist-based fuzzing methods. Whether you're targeting APIs, web directories, or file paths, WebFuzzGoRuby provides a robust solution to discover hidden or vulnerable resources in web applications. Embrace the simplicity and effectiveness of WebFuzzGoRuby for your web security testing needs!

## Overview
This repository contains two powerful fuzzing tools, one written in Go and the other in Ruby. These tools are designed to perform web fuzzing operations, helping to identify potential vulnerabilities in web applications by generating and sending a variety of requests.

## Features
- **Two Languages, Double Efficiency:** Implementations in both Ruby and Go offer flexibility and efficiency.
- **Random and Wordlist Modes:** Both tools support random string generation and wordlist-based fuzzing for comprehensive testing.
- **Customizable Options:** Set target URLs, control request counts and timeouts, and more.
- **Efficient HTTP Handling:** The Go version leverages the `fasthttp` library for high-performance HTTP requests.
- **Clean and Intuitive Output:** Real-time, clear output of fuzzing process and results.

## Tools Description

### Ruby Tool
The Ruby script is a comprehensive fuzzing tool that leverages the `httparty` and `securerandom` libraries to send a multitude of HTTP requests to a target URL. It offers options for random string generation and wordlist-based fuzzing, and it handles HTTP requests with customizable timeouts.

#### Key Features:
- Threading for parallel request handling.
- Customizable request count and timeout settings.
- Automatic appending of a slash to the target URL if missing.
- Real-time display of successful requests and continuous checking updates.

### Go Tool
The Go tool is built for high-speed fuzzing operations using the `fasthttp` library. It shares similar features with the Ruby tool, providing an efficient way to send numerous HTTP requests based on either random strings or predefined wordlists.

#### Key Features:
- Utilizes `fasthttp` for faster HTTP requests.
- Handles large numbers of requests with efficient memory management.
- Offers similar random and wordlist modes as the Ruby tool.
- Clean output with immediate flushing for real-time updates.

## Usage

### Ruby Tool
```
ruby fuzzing_tool.rb [options]
```
**Options:**
- `-m, --mode MODE`: Select mode ('random' or 'wordlist').
- `-u, --url URL`: Target URL with http/https.
- `-c, --count COUNT`: Number of random strings (default: 10).
- `-t, --timeout TIMEOUT`: Timeout of requests (default: 5 seconds).

### Go Tool
```
go run fuzzing_tool.go [options]
```
**Options:**
- `-mode`: Select mode ('random' or 'wordlist').
- `-url`: Target URL with http/https.
- `-count`: Number of random strings (default: 10).
- `-timeout`: Timeout of requests (default: 5 seconds).

## Installation
### Ruby Dependencies
Ensure Ruby is installed and then install required gems:
```
gem install httparty
gem install securerandom
```

### Go Dependencies
Ensure Go is installed and then set up `fasthttp`:
```
go get -u github.com/valyala/fasthttp
```

## Contributing
Contributions, issues, and feature requests are welcome. Feel free to check [issues page](https://github.com/Abo5/WebFuzzGoRuby/issues) for open issues or to open a new issue.

## License
Distributed under the MIT License. See `LICENSE` for more information.

---

Developed with ❤️ by Maven 
