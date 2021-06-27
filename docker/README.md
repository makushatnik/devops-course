# The minimal Docker image task solution.

## 1st try.
In the 1st try I've got an image with 148Mb size.
It's based on the Debian Buster slim + Python image.

## 2nd try.
In the 2nd try I've got an image with 88Mb size.  
It's based on the Alpine Linux, getting installed Python, Pip dependecies.  
It can be runned by command:  
`sudo docker run -p 80:5000 2nd_try`

## 3rd try.
In the 3rd try I've got an image with 8Mb size.  
It has only binary file with my sources.  
It can be runned by command:  
`sudo docker run -p 80:5000 3nd_try`
Before running that command make sure you don't have **Apache**, **Jenkins**, **Nginx** or something running on the **80th** port.
Otherwise, you need to disable them.

You can get that image by typing:
`docker pull makushatnik/python_exec`