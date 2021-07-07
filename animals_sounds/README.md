# Animals' sounds task.

Technologies I used:
* Ansible
* Python3
* Flask
* Nginx
* OpenSSL

***
After the service is created and started, it works on the port **80** with redirection to the **443** port.  
Just to get predictable answer you have to ensure that the header `Content-Type: application/json` is sent.  
If you're using **Postman**, you should go to the **Body** tab, press **Raw**, select **Json** in the drop-down list.  
Otherwise, if you're using **Curl** try something like this:  
`curl -XPOST -H 'Content-Type: application/json' -d'{"animal": "cow", "sound": "mooo", "count": 3}' http://myvm.localhost/`

Every JSON should contain 3 parts:
1. Kind of animal,
2. Sound of that animal,
3. The number of times it sounded it.
***

## Preparing
Before you run an Ansible playbook, you need to create:
1. **hosts.txt** file with servers available to you,
2. **.vault_pass** file to be able to run an Ansible script.

That very file must contain:  
6a79f43c43815a718c69a4fad17af0891cbdd9a4

## Ansible
After that you can run Ansible script:
`ansible-playbook playbook.yml --vault-password-file=.vault_pass`

When Ansible has finished its work correctly, you've got an `animals.service` which starts only after `nginx.service`. Every command for services will work then:
    systemctl status animals.service
	sudo systemctl stop animal.service       **To stop**
	sudo systemctl start animals.service     **To start**
	sudo systemctl restart animals.service   **To restart**

Also, you could see the logs of the Service like this:  
`sudo journalctl -eu animals.service`

### Further development:
Check that POST requests redirected to HTTPS correctly.  
Animal object serialization.
