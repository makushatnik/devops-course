# Animals' sounds task.

Technologies I used:
* Ansible
* Python3
* Flask
* Nginx
* OpenSSL

***
After the service is created and started, it works on the port **80**.  
Just to get predictable answer you have to ensure that the header `Content-Type: application/json` is sent.  
If you're using **Postman**, you should go to the **Body** tab, press **Raw**, select **Json** in the drop-down list.  
Otherwise, if you're using **Curl** try something like this:
curl -XPOST -H 'Content-Type: application/json' -d'{"animal": "cow", "sound": "mooo", "count": 3}' http://myvm.localhost/

Every JSON should contain 3 parts:
1. Kind of animal,
2. Sound of that animal,
3. The number of times it sounded it
***

Before you run an Ansible playbook, you need to create:
1. **hosts.txt** file with servers available to you,
2. **.vault_pass** file to be able to run an Ansible script.


You need to run commands:
sudo apt install python3-venv

python3 -m venv venv
source venv/bin/activate

pip install Flask

export FLASK_APP=hello.py
flask run

deactivate

### Further development:
Check that Application works as a service.
Find out a standart to deploy.
