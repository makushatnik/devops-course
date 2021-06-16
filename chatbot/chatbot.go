// Telegram's ChatBot v1.0 created by Evgeny Ageev

package main

import (
  "github.com/go-telegram-bot-api/telegram-bot-api"
  "fmt"
  "time"
  "log"
  "strings"
  "reflect"
)

type Task struct {
  Name, Command, Url string
}

type config struct {
  Token string
  Repo  string
  Debug bool
}

// Global Variables
var (
  FmtTasks string
  Bot *tgbotapi.BotAPI
  Config config
  Tasks = []Task{
    {Name: "Animals Sounds", Command: "/task1", Url: "animals_sounds"},
    {Name: "Tricky Bash", Command: "/task2", Url: "tricky_bash"},
    {Name: "Telegrams Chatbot", Command: "/task3", Url: "chatbot"},
  }
)

// Messages
const (
  Greetings = "Hi,\nThis bot can share with you some info about cool DevOps guy. You may find useful commands: /git, /tasks, /task1, /task2, /task3, /contacts, /cv, /paypal."
  UseLinkMsg = "To follow the link press the command"
  SupportMsg  = "Support cool DevOps guy by any amount of money:\n"
  NoSettingsAvailableMsg = "There are no settings you can change"
)

// Errors
const (
  IllegalFormatErr = "Use only words for commands"
  IllegalCommandErr = "Illegal command. Please, try again."
)

//The Program's Main Loop. 
func main() {
  Config := getConfig("config.json")
  Bot, BotErr := tgbotapi.NewBotAPI(Config.Token)
  mainTree := concat(Config.Repo, "/tree/main/")
  LogError(BotErr)
  if BotErr != nil {
    log.Panic("Not worked!")
  }
  fmt.Println("Starting", time.Now().Unix(), time.Now(), time.Now().Weekday())

  debug := Config.Debug
  Bot.Debug = debug
  if debug {
    fmt.Println(Config.Token)
    log.Printf("Authorized on account %s", Bot.Self.UserName)
  }

  repo := Config.Repo
  for _, tt := range Tasks {
    FmtTasks = concat(FmtTasks, fmt.Sprintf("%s - %s %s %s", tt.Name, UseLinkMsg, tt.Command, "\n"))
  }
  if Bot.Debug {
    fmt.Println("FMT = ",FmtTasks)
    log.Println(repo)
  }

  //Set update time
  u := tgbotapi.NewUpdate(0)
  u.Timeout = 60

  //Get updates from bot
  updates, err := Bot.GetUpdatesChan(u)
  if err != nil {
    LogError(err)
    log.Panic(err)
  }

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
          sendMessage(cId, Greetings)
        case "/git":
          sendMessage(cId, repo)
        case "/tasks":
          sendMessage(cId, FmtTasks)
        case "/task1":
          sendMessage(cId, concat(mainTree,Tasks[0].Url))
        case "/task2":
          sendMessage(cId, concat(mainTree,Tasks[1].Url))
        case "/task3":
          sendMessage(cId, concat(mainTree,Tasks[2].Url))
        case "/contacts":
          sendMessage(cId, getContacts())
        case "/cv":
          sendMessage(cId, getCV())
        case "/paypal":
          sendMessage(cId, getPaypal())
        case "/settings":
          sendMessage(cId, NoSettingsAvailableMsg)
        default:
          log.Println(mt)
          sendMessage(cId, IllegalCommandErr)
      }
    } else {
      //Send a message about mistake
      sendMessage(cId, IllegalFormatErr)
    }
  }
}

func sendMessage(cId int64, m string) {
  Bot.Send(tgbotapi.NewMessage(cId, m))
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
