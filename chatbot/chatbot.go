// Telegram's ChatBot v1.1 created by Evgeny Ageev

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
  Token  string
  Repo   string
  Cv     string
  Skype  string
  Email  string
  Debug  bool
}

// Global Variables
var (
  FmtTasks string
  Config = getConfig("config.json")
  Bot, BotErr = tgbotapi.NewBotAPI(Config.Token)
  Tasks = []Task{
    {Name: "Animals Sounds", Command: "/task1", Url: "animals_sounds"},
    {Name: "Tricky Bash", Command: "/task2", Url: "tricky_bash"},
    {Name: "Telegrams Chatbot", Command: "/task3", Url: "chatbot"},
    {Name: "Docker", Command: "/task4", Url: "docker"},
    {Name: "Terraform", Command: "/task5", Url: "terraform"},
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
  LogError(BotErr)
  if BotErr != nil {
    log.Panic("Telegram API aint worked!")
  }
  fmt.Println("Starting", time.Now().Unix(), time.Now(), time.Now().Weekday())

  debug := Config.Debug
  Bot.Debug = debug
  if debug {
    fmt.Println(Config.Token)
    log.Printf("Authorized on account %s", Bot.Self.UserName)
  }

  // Preparing variables, because it is expensive to get data in the loop
  repo   := Config.Repo
  cv     := Config.Cv
  paypal := Config.Email
  contacts := fmt.Sprintf("Skype: %s\nEmail: %s", Config.Skype, Config.Email)
  mainTree := concat(Config.Repo, "/tree/main/")
  for _, tt := range Tasks {
    FmtTasks = concat(FmtTasks, fmt.Sprintf("%s - %s %s \n", tt.Name, UseLinkMsg, tt.Command))
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
  LogError(err)
  if err != nil {
    log.Panic(err)
  }

  for update := range updates {
    if update.Message == nil || update.Message.Chat == nil {
      continue
    }

    mt  := update.Message.Text
    cId := update.Message.Chat.ID
    if debug {
      fmt.Println("CID = ", cId)
    }
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
        case "/task4":
          sendMessage(cId, concat(mainTree,Tasks[3].Url))
        case "/task5":
          sendMessage(cId, concat(mainTree,Tasks[4].Url))
        case "/contacts":
          sendMessage(cId, contacts)
        case "/cv":
          sendMessage(cId, cv)
        case "/paypal":
          sendMessage(cId, getPaypal(paypal))
        case "/settings":
          sendMessage(cId, NoSettingsAvailableMsg)
        default:
          log.Println(mt)
          sendMessage(cId, IllegalCommandErr)
      }
    } else {
      //Send a message about sending a photo or something other than a text message
      //Which is mistake
      sendMessage(cId, IllegalFormatErr)
    }
  }
}

func sendMessage(cId int64, m string) {
  Bot.Send(tgbotapi.NewMessage(cId, m))
}

func getPaypal(paypal string) string {
  return concat(SupportMsg, paypal)
}

