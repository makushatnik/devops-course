package main

import (
  "os"
  "log"
  "io/ioutil"
  "encoding/json"
)

func getConfig(path string) config {
  Config := config{}
  file, fileErr := os.Open(path)
  LogError(fileErr)
  if fileErr != nil {
    log.Panic("File absent")
    os.Exit(1)
  }
  data, dataErr := ioutil.ReadAll(file)
  LogError(dataErr)
  if dataErr != nil {
    log.Panic("Can't read config's data")
    os.Exit(1)
  }
  err := json.Unmarshal(data, &Config)
  LogError(err)
  if err != nil || Config.Token == "" {
    log.Panic("Telegram API Token is required")
    os.Exit(1)
  }
  return Config
}
