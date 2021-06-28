// Config class.

package main

import (
  "os"
  "fmt"
  "log"
  "io/ioutil"
  "encoding/json"
  "path/filepath"
)

func getConfig(fileName string) config {
  Config := config{}
  // Getting the Binary Dir
  dir, errPath := filepath.Abs(filepath.Dir(os.Args[0]))
  LogError(errPath)
  fmt.Println("DIR =", dir)
  // Getting th Config File
  path := fmt.Sprintf("%s/%s", dir, fileName)
  file, fileErr := os.Open(path)
  LogError(fileErr)
  if fileErr != nil {
    log.Panic("File absent")
    os.Exit(1)
  }
  // Getting the Config File's content
  data, dataErr := ioutil.ReadAll(file)
  LogError(dataErr)
  if dataErr != nil {
    log.Panic("Can't read config's data")
    os.Exit(1)
  }
  // Turn its content into JSON
  err := json.Unmarshal(data, &Config)
  LogError(err)
  if err != nil || Config.Token == "" {
    log.Panic("Telegram API Token is required")
    os.Exit(1)
  }
  return Config
}
