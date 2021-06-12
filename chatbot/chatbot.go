// Telegram's ChatBot v1.0 created by Evgeny Ageev

package main

import (
  "github.com/Syfaro/telegram-bot-api"
  "log"
  "fmt"
  "os"
  "strings"
  "reflect"
  "encoding/json"
)

type Task struct {
  Name, Command, Url string
}

type Config struct {
  token string
  repo  string
  debug bool
}

// Global Variables
var (
  tasks []Task
  fmtTasks string
  config Config
  //bot *tgbotapi.BotAPI
)

// Messages
const (
  Greetings = "Hi,\nThis bot can share with you some info about cool DevOps guy. You may find useful commands: /git, /tasks, /task1, /task2, /task3, /contacts, /cv, /paypal."
  UseLinkMsg = "To follow the link press the command"
  SupportMsg  = "Support cool DevOps guy by any amount of money:\n"
)

// Errors
const (
  IllegalFormatErr = "Use the words for commands"
  IllegalCommandErr = "What I can do for you?"
)

// Don't work correctly
func init() {
  //Loading config file
  //dir, _ := os.Getwd()
  //fmt.Println(dir)
  file, _ := os.Open("config.json")
  decoder := json.NewDecoder(file)
  config := Config{
    token: "1871694809:AAExK_AsnvfzkEb1nG5Im2ZDGUIqwz1kxPw",
    repo: "https://github.com/makushatnik/devops-course",
    debug: true,
  }
  //config := new(Config)
  err := decoder.Decode(&config)
  //err := json.Unmarshall(file, &config)
  fmt.Println("JSON = ", config)
  if err != nil || config.token == "" {
    log.Println("Telegram API Token is required")
    os.Exit(1)
  }
  if config.repo == "" {
    log.Println("Git Repository is required")
    os.Exit(1)
  }

  //Creating tasks
  tasks := []Task{
    {Name: "Animals Sounds", Command: "/task1", Url: "animals_sounds"},
    {Name: "Tricky Bash", Command: "/task2", Url: "tricky_bash"},
    {Name: "Telegrams Chatbot", Command: "/task3", Url: "chatbot"},
  }
  _ = tasks
}

//The Program's Main Loop. 
func main() {
  //TODO: Remove settings in the init function.
  config := Config{
    token: "1871694809:AAExK_AsnvfzkEb1nG5Im2ZDGUIqwz1kxPw",
    repo: "https://github.com/makushatnik/devops-course",
    debug: true,
  }

  tasks := []Task{
    {Name: "Animals Sounds", Command: "/task1", Url: "animals_sounds"},
    {Name: "Tricky Bash", Command: "/task2", Url: "tricky_bash"},
    {Name: "Telegrams Chatbot", Command: "/task3", Url: "chatbot"},
  }

  //Connect to the Telegram
  bot, err := tgbotapi.NewBotAPI(config.token)
  if err != nil {
    log.Panic(err)
  }

  debug := config.debug
  bot.Debug = debug
  if debug {
    fmt.Println(config.token)
    log.Printf("Authorized on account %s", bot.Self.UserName)
  }

  repo := config.repo
  //for _, tt := range tasks {
    //fmtTasks := concat(fmtTasks, concat(concat(tt.Name," - "), concat(concat(UseLinkMsg," - "),tt.Command)))
    //_ = fmtTasks
  //}
  fmtTasks := "Animal sounds. To follow the link press the command: /task1\nTricky Bash.To follow the link press the command: /task2\nChatbot. To follow the link press the command: /task3\n"
  //if bot.Debug {
    fmt.Println("FMT = ",fmtTasks)
    log.Println(repo)
  //}

  //Set update time
  u := tgbotapi.NewUpdate(0)
  u.Timeout = 60

  //Get updates from bot
  updates, err := bot.GetUpdatesChan(u)
  if err != nil {
    log.Panic(err)
  }

  mainTree := concat(repo, "/tree/main/")
  for update := range updates {
    if update.Message == nil || update.Message.Chat == nil {
      continue
    }

    mt := update.Message.Text
    cId := update.Message.Chat.ID
    if reflect.TypeOf(mt).Kind() == reflect.String && mt != "" {
      mt := strings.ToLower(mt)
      //Run an appropriate command
      switch mt {
        case "/start":
          sendMessage(bot, cId, Greetings)
        case "/git":
          sendMessage(bot, cId, repo)
        case "/tasks":
          sendMessage(bot, cId, fmtTasks)
        case "/task1":
          sendMessage(bot, cId, concat(mainTree,tasks[0].Url))
        case "/task2":
          sendMessage(bot, cId, concat(mainTree,tasks[1].Url))
        case "/task3":
          sendMessage(bot, cId, concat(mainTree,tasks[2].Url))
        case "/contacts":
          sendMessage(bot, cId, getContacts())
        case "/cv":
          sendMessage(bot, cId, getCV())
        case "/paypal":
          sendMessage(bot, cId, getPaypal())
        default:
          log.Println(mt)
          sendMessage(bot, cId, IllegalCommandErr)
      }
    } else {
      //Send a message about mistake
      sendMessage(bot, cId, IllegalFormatErr)
    }
  }
}

func sendMessage(bot *tgbotapi.BotAPI, cId int64, m string) {
  bot.Send(tgbotapi.NewMessage(cId, m))
}

func getContacts() string {
  return "Skype: eageev.javaee\nmakushatnik@gmail.com"
}

func getPaypal() string {
  return concat(SupportMsg, "makushatnik@gmail.com")
}

func getCV() string {
  return "https://hh.ru/resume/5b218a75ff08efcf9b0039ed1f544e75534a6c"
}
