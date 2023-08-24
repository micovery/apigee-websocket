package main

import (
	"fmt"
	"github.com/labstack/echo/v4"
	"golang.org/x/net/websocket"
	"os"
)

func hello(c echo.Context) error {
	fmt.Println("Received call from: " + c.RealIP())
	s := websocket.Server{Handler: websocket.Handler(func(ws *websocket.Conn) {
		defer ws.Close()
		for {
			// Read
			msg := ""
			err := websocket.Message.Receive(ws, &msg)
			if err != nil {
				c.Logger().Error(err)
				break
			}

			// Write
			err = websocket.Message.Send(ws, msg)
			if err != nil {
				c.Logger().Error(err)
				break
			}

			fmt.Printf("%s\n", msg)
		}
	})}

	s.ServeHTTP(c.Response(), c.Request())
	return nil
}

func main() {
	port := os.Getenv("PORT")
	if len(port) == 0 {
		port = "8080"
	}

	e := echo.New()
	e.HideBanner = true
	e.GET("/*", hello)
	e.Logger.Fatal(e.Start(fmt.Sprintf(":%s", port)))
}
