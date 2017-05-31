output=$(grep "$1"  /var/log/llmail/email/Analyzer.0.email.log | cut -d' ' -f4)
for x in $output; do echo; echo "###### Searching in subject for '$1' and message id $x"; grep $x /var/log/llmail/email/* ;  done; 
