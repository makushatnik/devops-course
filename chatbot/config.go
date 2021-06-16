package main

import (
  "fmt"
  "os"
  "log"
  "io/ioutil"
  "encoding/json"
)

func getConfig(path string) config {
  Config := config{}
  file, fileErr := os.Open(path)
  if fileErr != nil {
    LogError(fileErr)
    log.Panic("File absent")
    os.Exit(1)
  }
  data, dataErr := ioutil.ReadAll(file)
  if dataErr != nil {
    LogError(dataErr)
    log.Panic("Can't read config's data")
    os.Exit(1)
  }
  err := json.Unmarshal(data, &Config)
  if err != nil || Config.Token == "" {
    LogError(err)
    log.Panic("Telegram API Token is required")
    os.Exit(1)
  }
  return Config
}
