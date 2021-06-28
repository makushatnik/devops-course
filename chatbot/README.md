# The Telegram's Chat Bot task

The Bot created on the **Go** language & **Telegram API**.  

Bot exists in Telegram under the ***[@MakushatnikBot](https://t.me/MakushatnikBot)*** nickname.  
It understands few commands:  
* /repo		- Returns the link to my Github repository.
* /tasks	- Returns a list of tasks.
* /task1	- Returns a link to the solution of the Animal's Sounds task.
* /task2	- Returns a link to the solution of the Tricky Bash task.
* /task3	- Returns a link to the solution of the Chatbot task.
* /task4    - Returns a link to the solution of the Docker task.
* /task5    - Returns a link to the solution of the Terraform task.
* /contacts	- Returns my actual contacts.
* /cv		- Returns an url-address to my CV.
* /paypal	- Returns my Paypal account.
* /settings	- Doesn't do anything.

It doesn't matter whether command was written in the lower or upper case.  
Bot won't be able to get anything but words.
***
## Steps to install the Application (suppose you have Linux Ubuntu)

### AWS (or CGP or Azure, etc.)
Go to you Cloud provider page, select and run an instance, get its **IP-address**.  
Create a security key (**SSH**) and download it.  
Move your security key to your `~/.ssh/` dir and run `chmod 400` on it.  

### Install Ansible
`sudo apt install ansible`  

### Getting Project
`cd ~ &&
git clone git@github.com:makushatnik/devops-course.git devops && cd ./devops/chatbot`  

### Running Deploy process
1. Create hosts.txt file:  
`nano hosts.txt`  
2. Add your Cloud instance's settings in the the hosts.txt file: **IP-address**, alias for that server, path to **SSH** key.  
3. Create file .vault-pass in a project directory with content:
`$6$/1OFlW9yH1KHHiOm$pn2SfNgbF`
4. Set appropriate rights:
`chmod 400 .vault-pass`
5. Type command:
`ansible-playbook playbook.yml --vault-password-file .vault-pass`

### Logs
Now it writes a log. You can see it in that very file:
`/var/log/chatbot.log`

### Further development:
Force Chatbot to run as a Service.