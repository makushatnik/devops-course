// Simple Webserver implemented with Gin.
//
// Evgeny Ageev [mailto:eageev.javaee@gmail.com]

package main

import (
  "net/http"
  "github.com/gin-gonic/gin"
)

func main() {
  router := setupRouter()
  router.Run()
}

func setupRouter() *gin.Engine {
  r := gin.Default()
  r.GET("/", getHelloHandler)
  return r
}

func getHelloHandler(c *gin.Context) {
  c.String(http.StatusOK, "Hello, World!")
}
