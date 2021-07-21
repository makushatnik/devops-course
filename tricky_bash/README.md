# The Tricky Bash task

##Source shell command:
sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done

The ***solution.sh*** Bash script handles it.

### Usage:
`solution.sh [OPTIONS]`

### Options:
    -p PID       get information by process PID
    -n NAME      get information by process name
    -c NUMBER    limit output information
    -s STATE     show connections only in that state
    -r REQ_STR   get requested information from Whois

Possible values for **STATE**:  
* established  
* syn-sent  
* syn-recv  
* fin-wait-1  
* fin-wait-2  
* time-wait  
* closed  
* close-wait  
* last-ack  
* listening  
* closing  
* connected  
* synchronized  
* bucket  
* big

### Examples:
`sudo solution.sh -n firefox -r Organization -c 6 -s established`  
Returns name of organization connected by process with name **firefox** in established state and limit input to 6 lines  
`sudo solution.sh -p 6099 -r OrgAbuseEmail -c 4`  
Returns abuse email of organization connected by process with PID **6099** in any state and limit input to 4 lines  

You can't choose parameters **-p** and **-n** at the same time. You should choose one of them.  
Redundant sorting wasn't used in the script.

### Output example:
    ----------------------------------
    Running with following parameters:
    ----------------------------------
    Get the next info from whois by regexp: Organization
    Output lines limit is: 6
    State connection is: ESTAB
    Information for process name: firefox
    ----------------------------------
    1 : 44.238.3.246 : Amazon.com, Inc. (AMAZO-4) Amazon.com, Inc. (AMAZO-47)
In the end script writes information separated by ':' sign:
1. Count of connections to that IP address
2. IP address
3. Whatever information you wanted to get about organization. 

### Default settings:
* If **REQ_STR** parameter ain't given, will be chosen string **Organization** by default.
* If **NUMBER** of strings in the connections list ain't given, it will be **5** by default.