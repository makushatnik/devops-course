# The minimal Docker image task solution.

## 1st try.
In the 1st try I've got an image with 148Mb size.
It's based on the Debian Buster slim + Python image.

## 2nd try.
In the 2nd try I've got an image with 88Mb size.  
It's based on the Alpine Linux, getting installed Python, Pip dependecies.  
It can be runned by command:  
`sudo docker run -p 8080:5000 2nd_try`
