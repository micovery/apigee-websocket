package main

import (
	"crypto/tls"
	"flag"
	"fmt"
	"golang.org/x/net/websocket"
	"log"
	"net/url"
	"os"
	"os/signal"
	"time"
)

var address = flag.String("address", "ws://localhost:8080", "Web socket server address")
var idleStart = flag.Int("idle-start", -1, "Start idling at this number of seconds")
var idleStop = flag.Int("idle-stop", -1, "Stop idling at this number of seconds")

func main() {
	flag.Parse()
	log.SetFlags(0)

	interrupt := make(chan os.Signal, 1)
	signal.Notify(interrupt, os.Interrupt)

	var u *url.URL
	var err error
	if u, err = url.Parse(*address); err != nil {
		log.Fatal("could not parse url\n", err)
	}
	log.Printf("connecting to %s", u.String())

	c, err := websocket.DialConfig(&websocket.Config{
		Location:  u,
		Origin:    u,
		Protocol:  []string{},
		Version:   13,
		TlsConfig: &tls.Config{InsecureSkipVerify: true},
		Header:    nil,
		Dialer:    nil,
	})
	if err != nil {
		log.Fatal("dial:", err)
	}
	defer c.Close()

	done := make(chan struct{})

	go func() {
		defer close(done)
		msg := [255]byte{}
		for {
			_, err := c.Read(msg[:])
			if err != nil {
				log.Println("error while reading from ws:", err)
				return
			}
			log.Printf("recv: %s", msg)
		}
	}()

	ticker := time.NewTicker(time.Second)
	defer ticker.Stop()

	start := int64(0)
	for {
		select {
		case <-done:
			return
		case t := <-ticker.C:
			time := t.Unix()
			if start == 0 {
				start = time
			}
			elapsed := time - start
			if elapsed > int64(*idleStart) && elapsed < int64(*idleStop) {
				fmt.Printf("idling: %v\n", elapsed)
				continue
			}

			msg := fmt.Sprintf("%v", elapsed)
			fmt.Printf("send: %s\n", msg)
			_, err := c.Write([]byte(msg))
			if err != nil {
				log.Println("error while writing to ws:", err)
				return
			}
		case <-interrupt:
			log.Println("interrupt")
			err := c.Close()
			if err != nil {
				log.Println("error while closing ws", err)
				return
			}
			select {
			case <-done:
			case <-time.After(time.Second):
			}
			return
		}
	}
}
