#!/bin/bash -i
#
# Need to install "dialog" before first execution
# sudo apt-get install dialog
#
#

while true
do
        rm -f findings.txt

	CHOICE=$(dialog --clear \
			--backtitle "Search Lastline Mail Logs" \
			--title "Search Mail Logs" \
                        --cancel-label "Exit" \
			--menu "Choose one of the following options:" \
			20 60 8 \
                        SearchSender "Search for sender address" \
                        SearchRecipient "Search for recipient address" \
                        SearchSubject "Search for subject" \
                        SearchFree "Search for free text" \
			2>&1 >/dev/tty)
        RETURNOPT=$?
        [[ "$RETURNOPT" -eq 1 ]] &&clear && exit

	VALIDMAILREGEX="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"

	clear
	case $CHOICE in
	    SearchSender)
	    MAILADDRESS=$(dialog --title "Search for sender address" \
		--backtitle "Search for sender address" \
		--inputbox "Enter email address " 8 60 --output-fd 1) 
            

	    if [[ $MAILADDRESS =~ $VALIDMAILREGEX ]] ; then 
	       OUTPUT=$(zgrep "from='$MAILADDRESS" /var/log/llmail/email/SmtpReceiver.0.email.log | cut -d' ' -f4)
	       for x in $OUTPUT; do 
		   echo >> findings.txt 
		   echo "###### Searching in mail addresses for '$MAILADDRESS' and message id $x" >> findings.txt
		   zgrep -h "$x" /var/log/llmail/email/* | sort >> findings.txt   
	       done;

	       if [ "$OUTPUT" == '' ]; then
		   dialog --backtitle "Search for sender address" \
			  --title "Search for sender address" \
			  --msgbox 'No results ...' 10 40
	        else
         		dialog --textbox findings.txt -1 -1
	       fi
	    else
	       if [ "$OUTPUT" == '' ]; then
		   dialog --backtitle "Search for sender address" \
			  --title "Search for sender address" \
			  --msgbox 'Invalid mail address ...' 10 40
	       fi
	    fi
	    ;;

	    SearchRecipient)
	    MAILADDRESS=$(dialog --title "Search for recipient address" \
		--backtitle "Search for recipient address" \
		--inputbox "Enter email address " 8 60 --output-fd 1)

	    if [[ $MAILADDRESS =~ $VALIDMAILREGEX ]] ; then
	       OUTPUT=$(zgrep "to='$MAILADDRESS" /var/log/llmail/email/SmtpReceiver.0.email.log | cut -d' ' -f4)
	       for x in $OUTPUT; do
		   echo >> findings.txt
		   echo "###### Searching in recipient addresses for '$MAILADDRESS' and message id $x" >> findings.txt
		   zgrep -h "$x" /var/log/llmail/email/* | sort >> findings.txt
	       done;

	       if [ "$OUTPUT" == '' ]; then
		   dialog --backtitle "Search for recipient address" \
			  --title "Search for recipient address" \
			  --msgbox 'No results ...' 10 40
                else
                        dialog --textbox findings.txt -1 -1
	       fi
	    else
	       if [ "$OUTPUT" == '' ]; then
		   dialog --backtitle "Search for recipient address" \
			  --title "Search for recipient address" \
			  --msgbox 'Invalid mail address ...' 10 40
	       fi
	    fi
	    ;;

	    SearchSubject)
	    SUBJECT=$(dialog --title "Search for mail subject" \
		--backtitle "Search for mail subject" \
		--inputbox "Enter mail subject " 8 60 --output-fd 1)

            
	    OUTPUT=$(grep "subject='$SUBJECT" /var/log/llmail/email/Analyzer.0.email.log | cut -d' ' -f4)
	    for x in $OUTPUT; do 
		echo >> findings.txt 
		echo "###### Searching in subject for '$SUBJECT' and message id $x" >> findings.txt 
		grep -h "$x" /var/log/llmail/email/* | sort >> findings.txt
	    done; 

	    if [ "$OUTPUT" == '' ]; then
		dialog --backtitle "Search for mail subject" \
		       --title "Search for mail subject" \
		       --msgbox 'No results ...' 10 40
            else
                dialog --textbox findings.txt -1 -1 
	    fi
	    ;;

	    SearchFree)
	    FREETEXT=$(dialog --title "Search for free text" \
		--backtitle "Search for free text" \
		--inputbox "Enter free text " 8 60 --output-fd 1)
            
            zgrep "$FREETEXT" /var/log/llmail/email/* >>findings.txt
            dialog --textbox findings.txt -1 -1
            
	    ;;
	esac
done
