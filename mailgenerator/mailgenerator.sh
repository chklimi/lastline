#!/bin/bash
#
#
#==============================================================================
#title           :mailgenerator.sh
#description     :This script will make a header for a bash script.
#author		     :Dirk Beste, dbeste@lastline.com
#date            :2017-03-30
#version         :0.1    
#usage		     :bash mailgenerator.sh
#notes           :
#==============================================================================
#
#
# Tested on OSX, Remnux 6 and Windows 10 Ubuntu Subsystem
#

#
# Prerequisite:
# mailsend or swaks:
# mailsend for Windows, Linux and OSX downloads and installation descriptions can be found here:
# https://github.com/muquit/mailsend
# You need to commpile it yourself per instructions on the web page
# Use "which mailsend" and add it to the variable
mailsend=/usr/local/bin/mailsend

#
# Prerequisite:
# swaks or mailsend:
# Win10Ubunutu and Remnux:
# sudo apt-get install swaks
# OSX: Use homebrew
# brew install swaks
# Use "which swaks" and add it to the variable
swaks=/usr/bin/swaks
 
#
# Prerequisite:
# shuf:
# shuf can be found in in the GNU core utils and/or TextUtils 
# https://www.gnu.org/software/coreutils/manual/html_node/shuf-invocation.html
# Linux calls it "shuf", OSX calls it "gshuf"
# Use "which shuf" or "which gshuf" and add it to the variable
shuf=/usr/bin/shuf

#
# Prerequisite:
# python:
# Python 2.7 with full path needed for the vt_intelligence_downloader.py
python=/usr/bin/python

# SMTP Server address
smtpserver=192.168.107.132
#smtpserver=10.1.2.103

# File with 10000 randomized recipients. 1 line per recipient
# Use the following command in VIM to change domain f.e. to lastline.com:
# :%s/\(\<[A-Za-z0-9._%-]\+@\)[A-Za-z0-9.-]\+\.[A-Za-z]\{2,4}\>/\1lastline.com/g
recipientsfile=./recipients.txt

# File with 10000 randomized senders. 1 line per sender
sendersfile=./senders.txt

# File with 166 Lorem Ipsum subjects
subjectsfile=./subjects.txt

# File with 163 Lorem Ipsum bodies/paragraphs
bodiesfile=./bodies.txt

# I changed the 2 variables below in the vt_intelligence_downloader.py to the $malwaredir location
# LOCAL_STORE = 'virustotal'
# folder_name = "malware" 
malwaredir=./virustotal/malware

# VT Intelligence Downloader relative path
# ADD YOUR OWN API KEY IN THE vt_intelligence_downloader.py FILE. REGISTER WITH LASTLINE.COM ADDRESS
# or download your very own file: https://virustotal.com/intelligence/downloader/
vtdownload=./vt_intelligence_downloader.py

# Number of samples to download
numberofsamples=10

#
# Actual logic below
#
# Add downloads from Virustotal as needed
#
# Available parameter for vt_intelligence_downloader.py script
# https://virustotal.com/intelligence/help/
#
# or create your query here:
# https://virustotal.com/intelligence/
#
# But also keep in mind that Lastline has a limit
# https://virustotal.com/en/group/lastline_corporate/
#

# Download n documents from Virustotal
$python $vtdownload -n $numberofsamples size:5MB- tag:spam-email positives:5+


# Download n documents from Virustotal
#$python $vtdownload -n $numberofsamples size:5MB- type:document positives:5+

# Download n Executables from Virustotal
#$python $vtdownload -n $numberofsamples size:5MB- type:pdf positives:5+

# Download n Executables from Virustotal
#$python $vtdownload -n $numberofsamples size:5MB- type:executable positives:5+

echo `date "+%Y-%m-%d %H:%M:%S"`" INFO     Deleteing $malwaredir/intelligence-query.txt"
rm -f $malwaredir/intelligence-query.txt

for file in $malwaredir/*; do 

    sendervar=`$shuf -n 1 $sendersfile`;
    recipientvar=`$shuf -n 1 $recipientsfile`;
    subjectvar=`$shuf -n 1 $subjectsfile`;
    bodyvar=`$shuf -n 1 $bodiesfile`;

    # I prefer "mailsend" to deliver mails
    #$mailsend -q -f $sendervar -smtp $smtpserver -t $recipientvar -sub "$subjectvar" -M "$bodyvar" -attach "$file" ; 
    echo `date "+%Y-%m-%d %H:%M:%S"`" INFO     Mail sent:";
    echo `date "+%Y-%m-%d %H:%M:%S"`" INFO     From: $sendervar To: $recipientvar";
    echo `date "+%Y-%m-%d %H:%M:%S"`" INFO     Subject: $subjectvar";
    echo `date "+%Y-%m-%d %H:%M:%S"`" INFO     File: $file";

    # If you prefer "swaks" no issue
    $swaks -ha -f $sendervar -s $smtpserver -t $recipientvar --header "Subject: $subjectvar" --body "$bodyvar" --attach "$file" ; 

    # To look more realisical, I added a sleep command; sleep for at least 60s and max 300s 
    sleeptime=$[ ( $RANDOM % 10 )  + 5 ];
    echo `date "+%Y-%m-%d %H:%M:%S"`" INFO     Sleeping $sleeptime seconds... szzzz";
    sleep $sleeptime;
done

# Delete all malware samples downloaded from VT

echo `date "+%Y-%m-%d %H:%M:%S"`" INFO     Deleting files in directory $malwaredir"
rm -f $malwaredir/*
