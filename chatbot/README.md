# The Telegram's Chat Bot task

Bot exists in Telegram under the ***[@MakushatnikBot](https://t.me/MakushatnikBot)*** nickname.  
It understands few commands:  
* /repo		- Returns the link to my Github repository.
* /tasks	- Returns a list of tasks.
* /task1	- Returns a link to the solution of the Animal's Sounds task.
* /task2	- Returns a link to the solution of the Tricky Bash task.
* /task3	- Returns a link to the solution of the Chatbot task.
* /contacts	- Returns my actual contacts.
* /cv		- Returns an url-address to my cv.
* /paypal	- Returns my Paypal account.
* /settings	- Don't do anything.

It doesn't matter whether command was written in the lower or upper case.  
Bot won't be able to get anything but words.
***
## Steps to install the Application (suppose you have Linux Ubuntu)

### AWS (or CGP or Azure, etc.)
Go to you Cloud provider page, select and run an instance, get its **IP-address**.  
Create a security key (**SSH**) and download it.  
Move your security key to your `~/.ssh/` dir and run `chmod 400` on it.  

### Ansible
`sudo apt install ansible`  

### Getting Project
`cd ~ &&
git clone git@github.com:makushatnik/devops-course.git devops && cd ./devops/chatbot`  

### Running
Create hosts.txt file:  
`nano hosts.txt`  
Add your Cloud instance's settings here: **IP-address**, alias for that server, path to **SSH** key.  
`ansible-playbook playbook.yml`