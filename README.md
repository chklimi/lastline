# Lastline Search Mail Log

Normally you don't know the message id when searching for mail, instead you know an email address or the subject. 
The scripts here will help you when searching for information.


Just put this in the home directory of the monitoring user. Before running it the first time, make sure you install the dialog command

    sudo apt-get install dialog

Then start the script with

    bash searchmail.sh

Everything else is menu driven and the output is sorted by date and time.

Early used test scripts:
Search for an email address (to or from) and report all entries based on the message ID:

output=$(grep "$1"  /var/log/llmail/email/SmtpReceiver.0.email.log | cut -d' ' -f4)
for x in $output; do echo; echo "###### Searching in mail addresses for '$1' and message id $x"; grep "$x" /var/log/llmail/email/* ;  done; 

Save file as searchaddress.sh in the monitoring users home directory.

Search for subject and report all entries based on the message ID:

output=$(grep "$1" /var/log/llmail/email/Analyzer.0.email.log | cut -d' ' -f4)
for x in $output; do echo; echo "###### Searching in subject for '$1' and message id $x"; grep $x /var/log/llmail/email/* ;  done; 

Save file as searchsubject.sh in the monitoring users home directory.

If you did a SSH key exchange before, you can call the script from your local CLI.
$ ssh monitoring@192.168.107.132 'bash searchaddress.sh denton@verizon.net'

###### Searching in mail addresses for 'denton@verizon.net' and message id 9619e998ca0f4c9f86f3139ad783f9f1:
/var/log/llmail/email/Analyzer.0.email.log:2017-05-23 06:35:07,996 Analyzer.0.email 9619e998ca0f4c9f86f3139ad783f9f1: analyzing email
/var/log/llmail/email/Analyzer.0.email.log:2017-05-23 06:35:07,997 Analyzer.0.email 9619e998ca0f4c9f86f3139ad783f9f1: email parsed: date='Tue, 23 May 2017 06:35:07 +0000' message_id=None subject='Et rhoncus eros auctor eu'
/var/log/llmail/email/Analyzer.0.email.log:2017-05-23 06:35:08,011 Analyzer.0.email 9619e998ca0f4c9f86f3139ad783f9f1: attachment: llfiletype='File' size=22 md5='22f2564c3e4e91c3a5b1b39110318b69' content_type='application/octet-stream' filename='unspecified-filename'
/var/log/llmail/email/Analyzer.0.email.log:2017-05-23 06:35:08,015 Analyzer.0.email 9619e998ca0f4c9f86f3139ad783f9f1: removing email
/var/log/llmail/email/SmtpReceiver.0.email.log:2017-05-23 06:35:07,987 SmtpReceiver.0.email 9619e998ca0f4c9f86f3139ad783f9f1: received email: peer='192.168.107.132' to='jusdisgi@lastline.de' size=928 from='denton@verizon.net' proto='SMTP'

or alternatively searching for the subject:
$ ssh monitoring@192.168.107.132 'bash searchsubject.sh "Et rhoncus"'

###### Searching in subject for 'Et rhoncus' and message id b52b2ef23543473bb1a235696f27b399:
/var/log/llmail/email/Analyzer.0.email.log:2017-05-12 07:26:28,992 Analyzer.0.email b52b2ef23543473bb1a235696f27b399: analyzing email
/var/log/llmail/email/Analyzer.0.email.log:2017-05-12 07:26:29,018 Analyzer.0.email b52b2ef23543473bb1a235696f27b399: email parsed: date='Fri, 12 May 2017 07:26:28 +0000' message_id=None subject='Et rhoncus eros auctor eu'
/var/log/llmail/email/Analyzer.0.email.log:2017-05-12 07:26:29,023 Analyzer.0.email b52b2ef23543473bb1a235696f27b399: attachment: llfiletype='PdfDocFile' size=254458 md5='cd01a1ee17acbbd57795fb9f6027b4af' content_type='application/octet-stream' filename='8b0caa0c4459010a05f049847984a9f67a3e888682bd518f3fd2c691b65c8f57'
/var/log/llmail/email/Analyzer.0.email.log:2017-05-12 07:26:29,041 Analyzer.0.email b52b2ef23543473bb1a235696f27b399: removing email
/var/log/llmail/email/SmtpReceiver.0.email.log:2017-05-12 07:26:28,980 SmtpReceiver.0.email b52b2ef23543473bb1a235696f27b399: received email: peer='192.168.107.132' to='bjoern@lastline.de' size=344868 from='hmbrand@yahoo.ca' proto='SMTP'
