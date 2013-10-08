#!/bin/bash
# $Id: weaponizen900.sh 11/10/2012
# email: zitstif[@]gmail.com
# website: http://zitstif.no-ip.org/
# name: Kyle Young
# Bash shell script for updating weaponized Nokia N900s

echo "||=====================================================||";
echo "||Program name:----update.sh-----------------\----------||";
echo "||Author website:--zitstif.no-ip.org---------|---------||";
echo "||__________________________________________/__________||";

if [ ${#} -lt 1 ]
 then
   echo 'Program for safely updating your weaponized Nokia n900!'
   echo "Usage:	"
   echo "update normal #This just does a normal update";
   echo "update normal scripts #This does a normal update along with updating scripts";
   echo "update modded #This will do a modded update but keep back the kernel, libaprutil1, libapr1 and nmap so that they work";
   echo "update modded scripts #This will do a modded update but keeps back the said packages and updates scripts";
   echo "########################################################################################################";
   echo "NOTE: The safest route to go is: update modded OR update modded scripts";
   echo 'NOTE: Use 'normal' and 'normal scripts' at your own risk!'
   exit 1;
fi

function UpdateScripts()
{
  BozoCrackUpdate;
  niktoUpdate;
  findmyhashUpdate;
  wapitiUpdate;
  wafw00fUpdate;
  sipviciousUpdate;
  metagoofilUpdate;
  sqlbruteUpdate;
  msfupdate;
  SETupdate;
}

function TestHold()
{
  HoldCount=0;

  if dpkg --list | grep kernel-power* | grep "^h" &> /dev/null;
   then
     (( HoldCount++ ))
  fi
  if dpkg --list | grep kernel-modules | grep "^h" &> /dev/null;
   then
     (( HoldCount++ ))
  fi
  if dpkg --list | fgrep libaprutil1 | grep "^h" &> /dev/null;
   then
     (( HoldCount++ ))
  fi
  if dpkg --list | fgrep libapr1 | grep "^h" &> /dev/null;
   then
     (( HoldCount++ ))
  fi
  if dpkg --list | grep nmap | grep "^h" &> /dev/null;
   then
     (( HoldCount++ ))
  fi 

  if [[ ${HoldCount} -gt 1 ]];
   then
     return 1;
  fi

  if [[ ${HoldCount} -eq 0 ]];
   then
     return 0;
  fi 
  
}
   
 
function SetOrRemoveHold()
{
  echo "kernel-modules $1" | dpkg --set-selections;
  echo "kernel-power $1" | dpkg --set-selections;
  echo "kernel-power-flasher $1" | dpkg --set-selections;
  echo "kernel-power-headers $1" | dpkg --set-selections;
  echo "kernel-power-modules $1" | dpkg --set-selections;
  echo "libaprutil1 $1" | dpkg --set-selections;
  echo "libapr1 $1" | dpkg --set-selections;
  echo "nmap $1" | dpkg --set-selections;
}

 
if echo ${1} | egrep "normal" &> /dev/null;
 then
   TestHold;
   if [ $? -eq 1 ];
    then
      SetOrRemoveHold install;
   fi 
   apt-get update;
   apt-get upgrade --force-yes -y;
   if echo ${@} | egrep "scripts" &> /dev/null;
    then
      UpdateScripts;
   fi
   apt-get clean && apt-get autoclean;
   exit 0;
elif echo ${1} | egrep "modded"  > /dev/null;
 then
   TestHold;
   if [ $? -eq 0 ]; 
    then
      SetOrRemoveHold hold 
   fi 
   apt-get update;
   apt-get upgrade --force-yes -y;
   apt-get clean && apt-get autoclean;
   if echo ${@} | egrep "scripts" &> /dev/null;
    then
      UpdateScripts;
   fi
   exit 0;
else
   echo "I don't know what you are trying to do.." #Thanks Arc
   exit 2;
fi