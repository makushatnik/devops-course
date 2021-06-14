# The Tricky Bash task

Source shell command:
sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done

I created the Bash script to handle it.
You can try ***solution.sh*** script by typing just:
./solution.sh
in the directory where you downloaded it.

That script gets parameters:
