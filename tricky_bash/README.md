# The Tricky Bash task

##Source shell command:
sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done

The ***solution.sh*** Bash script handles it.

### Usage:
`solution.sh [OPTIONS]`

### Options:
`-p PID       get information by process PID
-n NAME      get information by process name
-c NUMBER    limit output information
-s STATE     show connections only in that state
-r REQ_STR   get requested information from Whois`

### Example:
`sudo solution.sh -n firefox -r <Organization> -c 6 -s established`
Returns information about Organization with process with name firefox and limit onput to 6 line and state is established

### Output example:
`----------------------------------
Running with following parameters:
----------------------------------
Get the next info from whois by regexp: ^Organization|organisation|org-name|person|descr
Output lines limit is: 6
State connection is: ESTABLISHED
Information for process name: firefox
----------------------------------
1 : 44.238.3.246 : Amazon.com, Inc. (AMAZO-4) Amazon.com, Inc. (AMAZO-47)`

### Default settings:
* If ***STATE*** parameter ain't given, will be chosen **ESTABLISHED** by default.
* If **REQ_STR** parameter ain't given, will be chosen string **^Organization|organization|org-name|person|descr** by default.