package main

import (
  "github.com/stretchr/testify/assert"
  "testing"
  "net/http"
  "net/http/httptest"
)

func TestGetHelloHandler(t *testing.T) {
  router := setupRouter()
  w      := httptest.NewRecorder()
  req, _ := http.NewRequest("GET", "/", nil)
  router.ServeHTTP(w, req)

  assert.Equal(t, http.StatusOK, w.Code)
  assert.Equal(t, "Hello, World!", w.Body.String())
}
