# Github API task solution.

This script was created for being able to get information about Github's repository:  
1. If there is(are) open Pull Requests,
2. Nicknames of the most Active contributors (who have done 2 or more Pull Requests).


## Running.
Run a script by typing:  
`./github.sh https://github.com/<NICKNAME>/<REPO>`  
Where:  
NICKNAME - Github repository owner's nickname  
REPO     - Name of the repository

Script won't work without 1 and only parameter needed for it - **Github repo**.
***
1st part of the script just return a number of Pull Requests, after that if it greater than 0, it prints:  
`There are <number> of open Pull Requests`  
otherwise it prints:  
`There no open Pull Requests`
***
2nd part of the script return nicknames. You will get something like this:  
    "Hakya*****"  
    "adfost****"  
    "bwatte*****"  
    "gwillc*****"  
    "pingp******"
***
Entertain yourself by getting new information about Github repositories you're awared of.

### Further development
Maybe, Gitlab and Bitbucket will be added in the future.