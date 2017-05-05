
[![Travis](https://img.shields.io/travis/npetzall/hello-http-go.svg?style=plastic)]() [![GitHub release](https://img.shields.io/github/release/npetzall/hello-http-go.svg?style=plastic)]()  
Simple webserver in go which responds with a text and a timestamp in json and the remote address (ip:port)

# hello-http-go

```
Usage of /hello-http-go:
  -port string
    	Specify port for http server (default "3000")
  -text string
    	Specify the response text (default "Hello")
  -version
    	Version of hello-http-go
```

## docker

`docker run npetzall/hello-http-go`  

Usage above can be applied to end of docker run command.  
Since it's added as a ENTRYPOINT and not CMD.  

Else use the normal -d and -P or -p for docker run
