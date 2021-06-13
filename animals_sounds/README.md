# Here you can see the solution of the task about animals' sounds.

Technologies I used:
* Ansible
* Python3
* Flask

***
After the service is created and started, it works on the port **80**.  
Just to get predictable answer you have to ensure that the header `Content-Type: application/json` is sent.  
If you're using **Postman**, you should go to the **Body** tab, press **Raw**, select **Json** in the drop-down list.  
Otherwise, if you're using **Curl** try something like this:
curl -XPOST -H 'Content-Type: application/json' -d'{"animal": "cow", "sound": "mooo", "count": 3}' http://localhost:5000/

Every JSON should contain 3 parts:
1. Kind of animal,
2. Sound of that animal,
3. The number of times it sounded it
***
You need to run commands:
sudo apt install python3-venv

python3 -m venv venv
source venv/bin/activate

pip install Flask

export FLASK_APP=hello.py
flask run

deactivate
