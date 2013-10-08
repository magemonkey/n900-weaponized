#!/bin/bash
# $Id: weaponizen900.sh 11/24/2012
# email: zitstif[@]gmail.com
# website: http://zitstif.no-ip.org/
# name: Kyle Young
# Bash shell script for weaponizing the Nokia N900


###Banner/Intro Seciton###

clear;
echo "||=====================================================||";
echo "||Program name:----weaponizen900.sh---------\----------||";
echo "||Author website:--zitstif.no-ip.org---------|---------||";
echo "||__________________________________________/__________||";
echo '[!]NOTE: USING THIS PROGRAM MAY REQUIRE YOU TO REFLASH[!]';
echo '[!]YOUR N900. THIS SOFTWARE IS PROVIDED "AS IS", WITH [!]';
echo '[!]OUT WARRANTY OF ANY KIND! I AM NOT RESPONSIBLE IF  [!]';
echo '[!]THIS PROGRAM DAMAGES YOUR PHONE! USE WITH CAUTION! [!]';
echo '||_____________________________________________________||';
echo "[?]Would you like to continue? (y|n)------------------[?]";
read -p "Response: " response;

if ! echo ${response} | grep -E "(Y|y).*" &> /dev/null;
 then
   echo "[!]exiting now..[!]";
   exit 1;
fi 

PresentDir="$(pwd)"

if [ -e /etc/weaponized ];
 then
   if cat /etc/weaponized | grep 75eea509c19cc66576a1bdea893834f8291c2d96 &> /dev/null;
    then
      echo '[!]It appears that this n900 has already been weaponized![!]';
      echo '[?]Are you sure you want to continue?[?]';
      read -p "Response: " response;
      if ! echo ${response} | grep -E "(Y|y).*" &> /dev/null;
       then
         echo "[!]exiting now..[1]";
         exit 1;
      fi
   fi
fi


###End of Banner/Intro Section###

#Initial tests#


if [ -e listweapons.sh ]
 then
   if [ ! $(sha1sum listweapons.sh | awk '{print $1}') == "42dc8b7e3cd62605328f2c1a24ef59bbb2a10788" ]
    then
      echo '[!]listweapons.sh sha1sum not correct![!]';
      echo '[!]File may have been tampered with![!]';
      exit 1;
   fi
 else
   echo '[!]listweapons.sh does not exist![!]';
   echo '[!]Exiting...[!]';
   exit 1;
fi

if [ -e update.sh ]
 then
   if [ ! $(sha1sum update.sh | awk '{print $1}') == "a6254b0b7b7097c2d79f15db6eb7a12f338ff406" ]
    then
      echo '[!]update.sh sha1sum not correct![!]';
      echo '[!]File may have been tampered with![!]';
      exit 1;
   fi
 else
   echo '[!]update.sh does not exist![!]';
   echo '[!]Exiting...[!]';
   exit 1;
fi

if [[ ${USER} != "root" ]] 
 then
   echo "[!]I need to be root..[!]";
   echo "[I]Make sure you have bash installed and rootsh installed.[I]";
   exit 2;
fi

if ! ls /bin/bash &> /dev/null;
 then
   echo "[!]Please make sure you have bash installed..[!]";
   echo "[!]/bin/bash does not appear to exist![!]";
   echo "[!]You may need to make a symlink!";
   exit 2;
fi


UseModem="false";

if ifconfig -a | grep gprs0 &> /dev/null;
 then
   if [ "$(ifconfig gprs0 | awk '/inet addr:/{print $2}' | cut -f2 -d:)" ]
    then
      if [ -n "$(ifconfig gprs0 | awk '/inet addr:/{print $2}' | cut -f2 -d:)" ]
       then
         echo "[!]It appears you're connected through your local mobile provider![!]";
         echo "[!]I strongly recommend you use a local secure wireless network![!]";
         echo "[!](With strong signal strength.)[!]"
         echo "[?]Would you like to continue?[?]"
         read -p "Response: " response;
         if ! echo ${response} | grep -E "(Y|y).*" &> /dev/null;
          then
            echo "[!]exiting now..[!]";
            exit 1;
          else
            UseModem="true";
         fi
      fi
   fi
fi



#kill cell phone modem?
if [ "${UseModem}" == "false" ]
 then
   echo "[?]Would you like to kill your cell phone modem temporarily for this install?(Y|n)[?]";
   read -p "Response: " response;
   if echo ${response} | grep -E "(Y|y).*" &> /dev/null;
    then
      echo "[I]Stopping modem...[I]";
      initctl stop sscd
   fi
fi
#initctl start sscd #later?


if [ "$(cat /usr/sbin/gainroot | fgrep ash_history | awk '{print $2}')" == "/bin/sh" ];
 then 
   echo "[I]Changing gainroot default login shell to bash[I]";
   cp /usr/sbin/gainroot /usr/sbin/gainroot.bk;
   cat /usr/sbin/gainroot.bk | sed 's/.ash_history \/bin\/sh/.ash_history \/bin\/bash/g' > /usr/sbin/gainroot;
   chmod a+x /usr/sbin/gainroot;  
fi


ping -c 1 www.google.com &> /dev/null;

if [ $? -ne 0 ]
 then
   echo "[!]It doesn't look like you're connected to the internet!![!]";
   echo "[!]For weaponizen900.sh to work, you need to be connected to the internet..[!]";
   exit 2;
 else
   var=$(ping www.google.com -c 1 | awk '/time=/{print $7}' | cut -f2 -d= | sed 's/\..*//g')
   if [ ${var} -gt 120 ]
    then
      echo "[!]The latency on this network doesn't appear to be good![!]"
      echo "[?]Would you like to continue?[?]"
      read -p "Response: " response;
      if ! echo ${response} | grep -E "(Y|y).*" &> /dev/null;
       then
         echo "[!]exiting now..[!]";
         exit 1;
      fi
    fi
fi

####End of initial tests########

#####Repo edit#####

echo "[I]Backing up hildon-application-manager.list..[I]";

cp /etc/apt/sources.list.d/hildon-application-manager.list /etc/apt/sources.list.d/hildon-application-manager.list.bk;

echo "[I]Adding additional repositories if needed...[I]";

if ! grep "repository.maemo.org" /etc/apt/sources.list.d/hildon-application-manager.list | grep extras-testing &> /dev/null;
 then
   echo "deb http://repository.maemo.org/extras-testing/ fremantle free non-free" >> /etc/apt/sources.list.d/hildon-application-manager.list;
fi

if ! grep "repository.maemo.org" /etc/apt/sources.list.d/hildon-application-manager.list | grep extras-devel &> /dev/null;
 then
   echo "deb http://repository.maemo.org/extras-devel/ fremantle free non-free" >> /etc/apt/sources.list.d/hildon-application-manager.list;
fi

if ! grep "my-maemo.com" /etc/apt/sources.list.d/hildon-application-manager.list | grep repository &> /dev/null;
 then
   echo "deb http://my-maemo.com/repository/ fremantle user" >> /etc/apt/sources.list.d/hildon-application-manager.list;
fi

if ! grep "downloads.maemo.nokia.com" /etc/apt/sources.list.d/hildon-application-manager.list &> /dev/null;
 then
   echo "deb https://downloads.maemo.nokia.com/fremantle/ovi/ ./" >> /etc/apt/sources.list.d/hildon-application-manager.list;
fi

if ! grep "repository.maemo.org" /etc/apt/sources.list.d/hildon-application-manager.list | grep tools &> /dev/null;
 then
   echo "deb http://repository.maemo.org fremantle/tools free non-free" >> /etc/apt/sources.list.d/hildon-application-manager.list;
fi

if ! grep "repository.maemo.org" /etc/apt/sources.list.d/hildon-application-manager.list | grep "deb-src" &> /dev/null;
 then
   echo "deb-src http://repository.maemo.org fremantle/tools free non-free" >> /etc/apt/sources.list.d/hildon-appliccation-manager.list;
fi

echo "[I]Running apt-get update...[I]";

apt-get update;

echo "[I]Running apt-get update again for safe measures..[I]";

apt-get update; 

if [ $? -ne 0 ]
 then
   echo "[!]There was a problem with apt-get update...[!]";
   echo "[?]Shall we move on anyways? (Y|N) [?]"
   read response;
   if ! echo ${response} | grep -E "(Y|y).*" &> /dev/null;
    then
      echo "[!]Exiting...[!]";
      exit 3;
   fi
fi

if dpkg --list | grep cherry &> /dev/null;
 then
   echo "[I]Let me do you a favor and remove cherry...[I]";
   apt-get remove cherry -y
fi

if ! dpkg --list | grep notmynokia &> /dev/null;
 then
   apt-get install notmynokia -y;
fi



#####End of RepoEdit##

####Create Directories and symlinks due to rootfs limited size..###

#http://wiki.maemo.org/Free_up_rootfs_space#

echo "[I]Attempting to free up rootfs space...[I]";

docpurge;

apt-get clean;

apt-get autoremove -y;

if [ ! -d /home/user/MyDocs/apt-archive-cache ]
 then
   echo "[I]Adjusting apt cache directory location...[I]";
   mkdir /home/user/MyDocs/apt-archive-cache;
   mkdir /home/user/MyDocs/apt-archive-cache/partial;
   if ! grep "Dir::Cache" /etc/apt/apt.conf.d/00maemo;
    then
      echo "[I]Backing up the 00maemo config file..[I]";
      cp /etc/apt/apt.conf.d/00maemo /etc/apt/apt.conf.d/00maemo.bk;
      echo 'Dir::Cache::archives "/home/user/MyDocs/apt-archive-cache";' >> /etc/apt/apt.conf.d/00maemo;
   fi
fi 

apt-get install pymaemo-optify -y;

if [ ! -d /home/opt/nokia-maps ]
 then
   echo "[I]moving nokia maps to /home/opt..[I]";
   mv /usr/share/nokia-maps /home/opt/;
   ln -s /home/opt/nokia-maps /usr/share/nokia-maps;
fi

if [ ! -d /home/opt/microb-engine ]
 then
   echo "[I]Moving microb-engine to /home/opt...[I]";
   mv /usr/share/microb-engine /home/opt;
   ln -s /home/opt/microb-engine /usr/share/microb-engine;
fi

#####End of rootfs related section####

#####Installing additional tools that are needed#####

echo "[I]Installing scripting languages and other useful tools needed..[I]";

apt-get install wine kbvpn-client cadaver zip gpscorrelate-gui exiv2 exif python-httplib2 python2.5-libxml2 \
 python-simplejson python-pycurl python2.5-dev gcc-4.6 file man git-core wget tar-gnu \
 grep-gnu perl ruby1.8 sed-gnu nano-opt openssl python2.5 vim subversion less bzip2 busybox-power libaprutil1=1.3.9-2 libapr1=1.4.2-1 --force-yes -y;


if [ $? -ne 0 ];
 then
   echo "[!]There was a problem installing the languages and other useful tools needed..[!]";
   echo "[!]Please read the error message from apt to try to troubleshoot the issue..[!]";
   exit 3;
fi 

apt-get clean;
apt-get autoclean -y;

if [ ! -e /usr/bin/gcc ];
 then
   ln -s /usr/bin/gcc-4.6 /usr/bin/gcc;
fi


echo "[I]Installing tools that can be found on sectools.org list..[I]"

apt-get install sshfs openssh-server fping lynx hexedit minicom privoxy qtwol tsocks proxytunnel \
 tor bluez-hcidump iodine cowpatty geoip-database stunnel4 cleven reaver maegios curl dsniff \
 gnupg truecrypt macchanger vncviewer hideuseragent recovery-tools socat nmap=5.50-2 rdesktop \
 wireshark aircrack-ng netcat tcpdump john kismet openssh-client python-scapy telnet dig tcptraceroute mtr-tiny whois miredo-server miredo easy-deb-chroot --force-yes -y;


if [ $? -ne 0 ]
 then
   echo "[!] There was a problem installing tools found on seclist.org...[!]";
   echo "[!]Please read the error message from apt to try to troubleshoot the issue..[!]";
   exit 3;
fi

if [ ! -e /usr/bin/fping ]
 then
   ln -s /usr/local/sbin/fping /usr/bin/fping;
fi

echo "[I]Creating /home/user/MyDocs/.weaponize for certain packages[I]";

if [ ! -d /home/user/MyDocs/.weaponize ];
 then
   mkdir /home/user/MyDocs/.weaponize;
 else
   echo "[I]/home/user/MyDocs/.weaponize exists already..[I]";
fi

echo "[I]Creating /home/user/MyDocs/.weaponize/scripts[I]";

if [ ! -d /home/user/MyDocs/.weaponize/scripts ];
 then
   mkdir /home/user/MyDocs/.weaponize/scripts/;
fi

#Download tools like nito... bozocrack(hash tool)

if [ ! -d /home/user/MyDocs/.weaponize/scripts/BozoCrack/ ];
 then
  echo "[I]Downloading bozocrack...[I]";
  mkdir /home/user/MyDocs/.weaponize/scripts/BozoCrack;
  git clone git://github.com/juuso/BozoCrack.git /home/user/MyDocs/.weaponize/scripts/BozoCrack;
  if [ ! -e /usr/bin/bozocrack ];
   then
     echo 'ruby /home/user/MyDocs/.weaponize/scripts/Bozocrack/bozocrack.rb $@' > /usr/bin/bozocrack;
     chmod a+x /usr/bin/bozocrack;
  fi
fi

if [ ! -e /usr/bin/BozoCrackUpdate ];
 then
  echo 'cd /home/user/MyDocs/.weaponize/scripts/Bozocrack/ && git pull && cd -' > /usr/bin/BozoCrackUpdate;
  chmod a+x /usr/bin/BozoCrackUpdate;
fi



if [ ! -d /home/user/MyDocs/.weaponize/scripts/nikto ];
 then
   echo "[I]Downloading nikto...[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/nikto/;
   git clone git://anonscm.debian.org/collab-maint/nikto.git /home/user/MyDocs/.weaponize/scripts/nikto/;
   if [ ! -e /usr/bin/nikto ];
    then
      echo 'perl /home/user/MyDocs/.weaponize/scripts/nikto/./nikto.pl -config /home/user/MyDocs/.weaponize/scripts/nikto/nikto.conf $@' > /usr/bin/nikto;
      chmod a+x /usr/bin/nikto;
   fi
fi

if [ ! -e /usr/bin/niktoUpdate ]
 then
   echo 'cd /home/user/MyDocs/.weaponize/scripts/nikto/ && git pull && cd -' > /usr/bin/niktoUpdate;
   chmod a+x /usr/bin/niktoUpdate;
fi

if [ ! -d /home/user/MyDocs/.weaponize/scripts/theHarvester ];
 then
   echo "[I]Downloading theHarvester...[I]";
   cd /home/user/MyDocs/.weaponize/scripts/ && wget http://theharvester.googlecode.com/files/theHarvester-2.2.tar;
   tar -xvf theHarvester*.tar;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading theHarvester...[!]";
      exit 4;
   fi
fi

if [ ! -e /usr/bin/theHarvester ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/theHarvester/theHarvester.py $@' > /usr/bin/theHarvester;
   chmod a+x /usr/bin/theHarvester; 
fi  


if [ ! -d /home/user/MyDocs/.weaponize/scripts/findmyhash ];
 then
   echo "[I]Downloading findmyhash..[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/findmyhash
   svn checkout http://findmyhash.googlecode.com/svn/trunk/ /home/user/MyDocs/.weaponize/scripts/findmyhash;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading findmyhash..[!]";
      exit 4;
   fi
fi

if [ ! -e /usr/bin/findmyhash ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/findmyhash/findmyhash.py $@' > /usr/bin/findmyhash;
   chmod a+x /usr/bin/findmyhash;
fi

if [ ! -e /usr/bin/findmyhashUpdate ];
 then
   echo 'cd /home/user/MyDocs/.weaponize/scripts/findmyhash/ && svn update && cd -' > /usr/bin/findmyhashUpdate;
   chmod a+x /usr/bin/findmyhashUpdate;
fi


if [ ! -d /home/user/MyDocs/.weaponize/scripts/wapiti ];
 then
   echo "[I]Downloading wapiti..[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/wapiti;
   svn co http://svn.code.sf.net/p/wapiti/code/trunk /home/user/MyDocs/.weaponize/scripts/wapiti;
   if [ $? -ne 0 ];
    then 
      echo "[!]There was a problem downloading wapiti..[!]";
      exit 4;
   fi
fi

if [ ! -e /usr/bin/wapiti ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/wapiti/trunk/src/wapiti.py $@' > /usr/bin/wapiti;
   chmod a+x /usr/bin/wapiti; 
fi

if [ ! -e /usr/bin/wapitiUpdate ];
 then
   echo 'cd /home/user/MyDocs/.weaponize/scripts/wapiti/ && svn update && cd -' > /usr/bin/wapitiUpdate;
   chmod a+x /usr/bin/wapitiUpdate;
fi

#svn checkout http://waffit.googlecode.com/svn/trunk/ waffit-read-only

if [ ! -d /home/user/MyDocs/.weaponize/scripts/waffit/ ]
 then
   echo "[I]Downloading waffit..[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/waffit/
   svn checkout http://waffit.googlecode.com/svn/trunk/ /home/user/MyDocs/.weaponize/scripts/waffit/;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading waffit (wafw00f)..[!]";
      exit 4;
   fi
fi

if [ ! -e /usr/bin/wafw00f ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/waffit/wafw00f.py $@' > /usr/bin/wafw00f;
   chmod a+x /usr/bin/wafw00f;
fi

if [ ! -e /usr/bin/wafw00fUpdate ];
 then
  echo 'cd /home/user/MyDocs/.weaponize/scripts/waffit/ && svn update && cd -' > /usr/bin/wafw00fUpdate;
  chmod a+x /usr/bin/wafw00fUpdate;
fi

if [ ! -d /home/user/MyDocs/.weaponize/scripts/exiftool ];
 then
   echo "[I]Downloading exiftool..[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/exiftool && cd /home/user/MyDocs/.weaponize/scripts/exiftool;
   wget http://owl.phy.queensu.ca/~phil/exiftool/Image-ExifTool-9.00.tar.gz;
   tar -xvzf *.tar.gz;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading exiftool..[!]";
      exit 4;
   fi
   rm /home/user/MyDocs/.weaponize/scripts/exiftool/Image-ExifTool-9.00.tar.gz;
fi

if [ ! -e /usr/bin/exiftool ];
 then
   echo 'perl /home/user/MyDocs/.weaponize/scripts/exiftool/Image-ExifTool-9.00/exiftool $@' > /usr/bin/exiftool;
   chmod a+x /usr/bin/exiftool;
fi

if [ ! -d /home/user/MyDocs/.weaponize/scripts/RVT ];
 then
   echo "[I]Downloading a few RVT tools..[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/RVT;
   cd /home/user/MyDocs/.weaponize/scripts/RVT
   wget http://revealertoolkit.googlecode.com/svn/tags/RVT_v0.2.1/tools/dumplnk.pl;
   wget http://revealertoolkit.googlecode.com/svn-history/r90/trunk/tools/evtparse.pl;
   wget http://revealertoolkit.googlecode.com/svn-history/r91/tags/RVT_v0.2.1/tools/evtrpt.pl;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading some RVT tools..[!]";
      exit 4;
   fi
fi

if [ ! -e /usr/bin/dumplnk ];
 then
   echo 'perl /home/user/MyDocs/.weaponize/scripts/RVT/dumplnk.pl $@' > /usr/bin/dumplnk;
   chmod a+x /usr/bin/dumplnk
fi

if [ ! -e /usr/bin/evtparse ];
 then
   echo 'perl /home/user/MyDocs/.weaponize/scripts/RVT/evtparse.pl $@' > /usr/bin/evtparse;
   chmod a+x /usr/bin/evtparse;
fi

if [ ! -e /usr/bin/evtrpt ];
 then
   echo 'perl /home/user/MyDocs/.weaponize/scripts/RVT/evtrpt.pl $@' > /usr/bin/evtrpt;
   chmod a+x /usr/bin/evtrpt;
fi


if [ ! -d /home/user/MyDocs/.weaponize/scripts/mork/ ];
 then
   echo "[I]Downloading mork.pl...[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/mork/ && cd /home/user/MyDocs/.weaponize/scripts/mork/;
   wget http://www.jwz.org/hacks/mork.pl --user-agent=Mozilla;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading mork.pl..[!]";
   fi
fi

if [ ! -e /usr/bin/mork ];
 then
   echo 'perl /home/user/MyDocs/.weaponize/scripts/mork/mork.pl $@' > /usr/bin/mork;
   chmod a+x /usr/bin/mork;
fi 


if [ ! -d /home/user/MyDocs/.weaponize/scripts/dnschef ];
 then
   echo "[I]Downloading dnschef...[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/dnschef;
   cd /home/user/MyDocs/.weaponize/scripts/dnschef && wget http://thesprawl.org/media/projects/dnschef-0.1.tar.gz;
   tar -xvzf dnschef*.tar.gz
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading dnschef.py[!]";
      exit 4;
   fi
fi

if [ ! -e /usr/bin/dnschef ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/dnschef/dnschef-0.1/dnschef.py $@' > /usr/bin/dnschef;
   chmod a+x /usr/bin/dnschef;
fi

if [ ! -d /home/user/MyDocs/.weaponize/scripts/sipvicious ];
 then
   echo "[I]Downloading sipvicious..[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/sipvicious;
   svn checkout http://sipvicious.googlecode.com/svn/trunk/ /home/user/MyDocs/.weaponize/scripts/sipvicious;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading sipvicious..[!]";
      exit 4;
   fi
fi

if [ ! -e /usr/bin/svcrack ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/sipvicious/svcrack.py $@' > /usr/bin/svcrack;
   chmod a+x /usr/bin/svcrack;
fi

if [ ! -e /usr/bin/svlearnfp ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/sipvicious/svlearnfp.py $@' > /usr/bin/svlearnfp;
   chmod a+x /usr/bin/svlearnfp
fi

if [ ! -e /usr/bin/svmap ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/sipvicious/svmap.py $@' > /usr/bin/svmap;
   chmod a+x /usr/bin/svmap;
fi

if [ ! -e /usr/bin/svreport ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/sipvicious/svreport.py $@' > /usr/bin/svreport;
   chmod a+x /usr/bin/svreport;
fi

if [ ! -e /usr/bin/svwar ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/sipvicious/svwar.py $@' > /usr/bin/svwar;
   chmod a+x /usr/bin/svwar;
fi

if [ ! -e /usr/bin/sipviciousUpdate ];
 then
   echo 'cd /home/user/MyDocs/.weaponize/scripts/sipvicious/ && svn update && cd -' > /usr/bin/sipviciousUpdate;
   chmod a+x /usr/bin/sipviciousUpdate;
fi


if [ ! -d /home/user/MyDocs/.weaponize/scripts/PACK ];
 then
   echo "[I]Downloading PACK (Password Analysis and Cracking Kit)..[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/PACK/;
   cd /home/user/MyDocs/.weaponize/scripts/PACK/ && wget http://thesprawl.org/media/projects/PACK-0.0.2.tar.bz2;
   tar -xvjf PACK-0.0.2.tar.bz2;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading PACK..[!]";
      exit 4;
   fi
fi

if [ ! -e /usr/bin/dictstat ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/PACK/PACK-0.0.2/dictstat.py $@' > /usr/bin/dictstat;
   chmod a+x /usr/bin/dictstat;
fi

if [ ! -e /usr/bin/maskgen ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/PACK/PACK-0.0.2/maskgen.py $@' > /usr/bin/maskgen;
   chmod a+x /usr/bin/maskgen;
fi

if [ ! -e /usr/bin/policygen ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/PACK/PACK-0.0.2/policygen.py $@' > /usr/bin/policygen;
   chmod a+x /usr/bin/policygen;
fi


if [ ! -d /home/user/MyDocs/.weaponize/scripts/metagoofil ];
 then
   echo "[I]Downloading metagoofil..[I]";
   git clone http://github.com/cohesioN241/Metagoofil.git /home/user/MyDocs/.weaponize/scripts/metagoofil;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading metagoofil..[!]";
      exit 4;
   fi
fi

if [ ! -e /usr/bin/metagoofil ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/metagoofil/metagoofil.py $@' > /usr/bin/metagoofil;
   chmod a+x /usr/bin/metagoofil;
fi

if [ ! -e /usr/bin/metagoofilUpdate ];
 then
   echo 'cd /home/user/MyDocs/.weaponize/scripts/metagoofil/ && git pull' > /usr/bin/metagoofilUpdate; 
   chmod a+x /usr/bin/metagoofilUpdate;
fi


if [ ! -d /home/user/MyDocs/.weaponize/scripts/cge ];
 then
   echo "[I]Downloading cisco-global-exploiter..[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/cge; 
   cd /home/user/MyDocs/.weaponize/scripts/cge;
   wget http://dl.packetstormsecurity.net/0405-exploits/cge-13.tar.gz;
   tar -xvzf cge-13.tar.gz;
   if [ $? -ne 0 ];
    then
      echo '[!]There was a problem downloading cisco-global-exploiter..[!]';
      exit 4;
   fi
fi

if [ ! -e /usr/bin/cge ];
 then
   echo 'perl /home/user/MyDocs/.weaponize/scripts/cge/cge-13/cge.pl $@' > /usr/bin/cge;
   chmod a+x /usr/bin/cge;
fi
 

if [ ! -d /home/user/MyDocs/.weaponize/wordlist ];
 then
   echo "[I]Downloading Cain and Abel Wordlist....[I]";
   mkdir /home/user/MyDocs/.weaponize/wordlist;
   cd /home/user/MyDocs/.weaponize/wordlist;
   wget http://downloads.skullsecurity.org/passwords/cain.txt.bz2;
   bunzip2 *.bz2;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading the Cain and Abel Wordlist[!]";
      exit 4;
   fi
fi

if [ ! -e /pentest/passwords ];
 then
   mkdir -p /pentest/passwords;
   ln -s /home/user/MyDocs/.weaponize/wordlist /pentest/passwords/wordlists;
fi


if [ ! -d /home/user/MyDocs/.weaponize/scripts/sqlbrute/ ];
 then
   echo "[I]Dowloading sqlbrute..[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/sqlbrute/;
   git clone http://github.com/GDSSecurity/SQLBrute.git /home/user/MyDocs/.weaponize/scripts/sqlbrute/;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading sqlbrute..[I]";
      exit 4;
   fi
fi

if [ ! -e /usr/bin/sqlbrute ];
 then
   echo 'python /home/user/MyDocs/.weaponize/scripts/sqlbrute/sqlbrute.py $@' > /usr/bin/sqlbrute;
   chmod a+x /usr/bin/sqlbrute;
fi

if [ ! -e /usr/bin/sqlbruteUpdate ];
 then
   echo 'cd /home/user/MyDocs/.weaponize/scripts/sqlbrute/ && git pull && cd -' > /usr/bin/sqlbruteUpdate;
   chmod a+x /usr/bin/sqlbruteUpdate;
fi


if [ ! -d /home/user/MyDocs/.weaponize/metasploit/ ];
 then
   echo "[I]Downloading Metasploit...[I]";
   mkdir /home/user/MyDocs/.weaponize/metasploit/;
   git clone git://github.com/rapid7/metasploit-framework.git /home/user/MyDocs/.weaponize/metasploit/ 
   if [ $? -ne 0 ]
    then
      echo "[!] There was a problem downloading metasploit via git!![!]";
      pkill git;
      exit 3;
   fi
 else
   echo "[I]It appears that metasploit may already be installed..[I]";
fi 

echo "[I]Installing required tools/libraries for metasploit..[I]";

apt-get install ruby1.8 irb1.8 rdoc1.8 libopenssl-ruby1.8 --force-yes -y;

if [ $? -ne 0 ]
 then
  echo "[!]There was a problem downloading ruby, irb1.8 and other required tools/libraries through apt-get![!]";
  exit 3;
fi

if [ ! -e /usr/bin/ruby ];
 then
   echo "[I]Creating /usr/bin/ruby symlink..[I]";
   ln -s /usr/bin/ruby1.8 /usr/bin/ruby
fi

if [ ! -d /usr/local/lib/site_ruby/*/rubygems/ ];
 then
   echo "[I]I need to install rubygems for Metasploit..[I]";
   RUBYGEMS="$(wget -q https://rubygems.org/pages/download --no-check-certificate && egrep "http://production.cf.rubygems.org" download | fgrep tgz | cut -f2 -d'"')";
   rm download;
   wget ${RUBYGEMS};
   if [ $? -ne 0 ]
    then
      echo "[!]There was a problem downloading rubygems.. please look at the error message above![!]";
      exit 3;
   fi
   tar -xvzf rubygems*.tgz;
   cd rubygems*;
   ruby1.8 setup.rb;
   cd -;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem setting up rubygems..[!]"
      exit 3;
   fi
   rm rubygems-*.tgz;
   rm -rf rubygems-*;
 else
   echo "[I]It appers that rubygems is already installed..[I]";
fi

if [ ! -e /usr/bin/gem ];
 then
   ln -s /usr/bin/gem1.8 /usr/bin/gem;
fi 

if [ ! -e /usr/bin/msfconsole ];
 then 
   echo 'ruby /home/user/MyDocs/.weaponize/metasploit/msfconsole -L $@' > /usr/bin/msfconsole;
   chmod a+x /usr/bin/msfconsole 
fi

if [ ! -e /usr/bin/msfbinscan ];
 then
   echo 'ruby /home/user/MyDocs/.weaponize/metasploit/msfbinscan $@' > /usr/bin/msfbinscan;
   chmod a+x /usr/bin/msfbinscan;
fi 

if [ ! -e /usr/bin/msfcli ];
 then
   echo 'ruby /home/user/MyDocs/.weaponize/metasploit/msfcli $@' > /usr/bin/msfcli;
   chmod a+x /usr/bin/msfcli;
fi

if [ ! -e /usr/bin/msfd ];
 then
   echo 'ruby /home/user/MyDocs/.weaponize/metasploit/msfd $@' > /usr/bin/msfd;
   chmod a+x /usr/bin/msfd;
fi

if [ ! -e /usr/bin/msfelfscan ];
 then
   echo 'ruby /home/user/MyDocs/.weaponize/metasploit/msfelfscan $@' > /usr/bin/msfelfscan;
   chmod a+x /usr/bin/msfelfscan;
fi

if [ ! -e /usr/bin/msfencode ];
 then
   echo 'ruby /home/user/MyDocs/.weaponize/metasploit/msfencode $@' > /usr/bin/msfencode;
   chmod a+x /usr/bin/msfencode;
fi

if [ ! -e /usr/bin/msfpayload ];
 then
   echo 'ruby /home/user/MyDocs/.weaponize/metasploit/msfpayload $@'  > /usr/bin/msfpayload;
   chmod a+x /usr/bin/msfpayload;
fi 

if [ ! -e /usr/bin/msfvenom ];
 then
   echo 'ruby /home/user/MyDocs/.weaponize/metasploit/msfvenom $@' > /usr/bin/msfvenom;
   chmod a+x /usr/bin/msfvenom;
fi

if [ ! -e /usr/bin/msfupdate ];
 then
   echo "cd /home/user/MyDocs/.weaponize/metasploit/ && git pull && cd -" > /usr/bin/msfupdate;
   chmod a+x /usr/bin/msfupdate;
fi


#Install SET next.. along with pre-reqs?#

#Requirements for SET: Install subversion, python-pexpect, python-beautifulsoup, python-crypto, python-openssl, python-pefile manually for all of SET dependancies.

if [ ! -d /home/user/MyDocs/.weaponize/SET/ ];
 then
   echo "[I]Downloading Social Engineering toolkit..";
   git clone https://github.com/trustedsec/social-engineer-toolkit/ /home/user/MyDocs/.weaponize/SET/;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading the SET toolkit![!]";
      exit 3;
   fi
   apt-get install python-beautifulsoup python-crypto python-openssl -y --force-yes;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading and installing some of the required python libraries for SET![!]"
      exit 3;
   fi
   echo "[!]SET should handle downloading and installing the rest of the required Python libraries[!]";
fi

apt-get install python-beautifulsoup python-crypto python-openssl -y --force-yes;


if [ "$(egrep "METASPLOIT_PATH" /home/user/MyDocs/.weaponize/SET/config/set_config )" != "METASPLOIT_PATH=/home/user/MyDocs/.weaponize/metasploit" ];
 then
   echo "[I]Making sure that SET can find metasploit..[I]";
   mv /home/user/MyDocs/.weaponize/SET/config/set_config /home/user/MyDocs/.weaponize/SET/config/set_config.bk;
   cat /home/user/MyDocs/.weaponize/SET/config/set_config.bk  | sed 's/\/opt\/metasploit\/msf3/\/home\/user\/MyDocs\/.weaponize\/metasploit/g' > /home/user/MyDocs/.weaponize/SET/config/set_config;
fi

echo "[I]To run the Social engineering toolkit, type in SET[I]";
echo "[I]To update the Social engineering toolkit, type in SETupdate[I]";

if [ ! -e /usr/bin/SET ];
 then 
   echo "cd /home/user/MyDocs/.weaponize/SET/ && python ./set" > /usr/bin/SET;
   chmod a+x /usr/bin/SET;
fi

if [ ! -e /usr/bin/SETupdate ]
 then
   echo "cd /home/user/MyDocs/.weaponize/SET/ && svn update" > /usr/bin/SETupdate;
   chmod a+x /usr/bin/SETupdate;
fi

if [ ! -d /home/user/MyDocs/.weaponize/sslstrip/ ];
 then
   echo "[I]Downloading sslstrip...[I]";
   mkdir /home/user/MyDocs/.weaponize/sslstrip/;
   git clone git://github.com/moxie0/sslstrip /home/user/MyDocs/.weaponize/sslstrip/;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading sslstrip![!]";
      exit 3;
   fi
   apt-get install python-twisted-web iptables python-twisted-conch -y --force-yes;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem installing the required libraries/packages for sslstrip![!]";
      exit 3;
   fi
   cd /home/user/MyDocs/.weaponize/sslstrip/;
   python ./setup.py install;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem installing sslstrip![!]";
      echo "[!]Please read the error message above![!]";
      exit 3;
   fi
   cd -;
fi
  
apt-get install python-twisted-web iptables python-twisted-conch -y --force-yes;
 

#New n900weapons.tar file needed... 8/20/2012#

#new file = 3d10927195fa6579e78f21219800f7a640a5a6cd n900weapons.tar

echo "[I]Downloading n900weapons.tar....[I]"

if [ ! -e /home/user/MyDocs/.weaponize/n900weapons.tar ];
 then
   cd /home/user/MyDocs/.weaponize/ && wget "http://ia600301.us.archive.org/24/items/n900weapons.tar/n900weapons.tar"
 else
   echo "[I]It appears that the file n900weapons.tar already exists[I]"
fi

if [ $? -ne 0 ];
 then 
   echo "[!]There was a problem downloading n900weapons.tar.. this program needs this file to continue[!]";
   exit 4;
 else
   echo "[I]Checking shasum of file...[I]"
      if [ "$(sha1sum /home/user/MyDocs/.weaponize/n900weapons.tar | awk '{print $1}')" == "3d10927195fa6579e78f21219800f7a640a5a6cd" ]
       then
         echo "[I] sha1sum = 3d10927195fa6579e78f21219800f7a640a5a6cd[I]";
         echo "[I] continuing to extraction process..[I]";
       else
         echo "[!]sha1sum doesn't match 0cbcb1e9ea87901d5045b3141f001e9f62e6a5f3!!! [!]";
         echo "[!]file may be corrupt..[!]";
         exit 4;
      fi
fi

###Extraction process..##

echo "[I]Extracting n900weapons.tar...[I]";
cd /home/user/MyDocs/.weaponize/;

if [ ! -e /home/user/MyDocs/.weaponize/n900weapons ]
 then
   tar -xvf /home/user/MyDocs/.weaponize/n900weapons.tar;
 else
   echo "[I]It appears that n900weapons.tar has already been extracted..[I]";
fi

if [ $? -ne 0 ]
 then
   echo "[!]There was a problem with extracting n900weapons.tar![!]";
   exit 4;
fi


if [ ! -e /pentest/windows-binaries ];
 then
   echo "[I]Setting up /pentest/windows-binaries directory..[I]"
   cd /home/user/MyDocs/.weaponize/n900weapons/
   tar xvf windows-binaries.tar
   ln -s /home/user/MyDocs/.weaponize/n900weapons/windows-binaries /pentest/windows-binaries;
 else
   echo "[I]/pentest/windows-binaries already exists..[I]";
fi

#Install ettercap from the tar file..##

echo "[I]Extracting and installing ettercap for n900..[I]"


if [ ! -d /opt/ettercap/ ];
 then
   cd /home/user/MyDocs/.weaponize/n900weapons/ec-n900/
   tar -xvf ec-n900.tar;
   mv ettercap/ /opt/
   ln -s /opt/ettercap/bin/ettercap /bin/ettercap;
   ln -s /opt/etteracp/bin/etterfilter /bin/etterfilter;
   ln -s /opt/ettercap/bin/etterlog /bin/etterlog;
   ln -s /opt/ettercap/lib/libnet.so.1.3.0 /usr/lib/libnet.so.1;
   ln -s /opt/ettercap/lib/libpcre.so.3 /usr/lib/libpcre.so.3;
   chmod a+x /bin/ettercap;
   chmod a+x /bin/etterfilter;
   chmod a+x /bin/etterlog;
   echo "[I]Ettercap installed..[I]";
 else
   echo "[I]It appears that ettercap is already installed..[I]";
fi


##Installing kernel...###


#Check if the kernel is already installed... use the dpkg --contents to find out a list of files that will be on the n900 if the
#kernel is installed already..

echo "[I]checking to see if custom kernel that supports packet injection is installed...[I]";

#File from kernel-power_2.6.28-10power51r1_armel.deb##

KernelInstall=0

if [ "$(dpkg --list | fgrep power | fgrep kernel)" ];
 then
   (( KernelInstall++ ))
fi


if [ -e /boot/zImage-2.6.28.10-power51.fiasco ]
 then
   (( KernelInstall++ ))
fi

######################################################


#Files from linux-kernel-power-headers_2.6.28-10power51r1_armel.deb###8/22/2012

if [ -e /usr/include/linux/gfs2_ondisk.h ]
 then
   (( KernelInstall++ ))
fi

if [ -e /usr/include/linux/netfilter_ipv4/ipt_comment.h ]
 then
   (( KernelInstall++ ))
fi
##################################################################


#Files from kernel-power-modules_2.6.28-10power51r1_armel.deb####8/22/2012

if [ -e /lib/modules/2.6.28.10-power51/usbserial.ko ]
 then
   (( KernelInstall++ ))
fi

if [ -e /lib/modules/2.6.28.10-power51/dm-crypt.ko ]
 then
   (( KernelInstall++ ))
fi

##################################################################

#Files from kernel-power-flasher_2.6.28-10power51r1_armel.deb####8/22/2012

if [ -e /usr/sbin/kernel-power-uninstall ]
 then
   (( KernelInstall++ ))
fi

if [ -e /etc/sudoers.d/kernel-power-flasher.sudoers ]
 then
   (( KernelInstall++ ))
fi

#################################################################


##Put this in your if loops in the file check sections..###

response="N"

if [ ${KernelInstall} -gt 0 ] 
 then
   echo "[!]Files from kernel 2.6.28-10power51r1_deb suite found or a power kernel is installed![!]";
   echo "[!]A custom kernel appears to be installed already![!]";
   echo "[?]Skip installing custom kernel?[?]"
   read -p "Response: (Y|N)" response;
   if ! echo ${response} | grep -E "(Y|y).*" &> /dev/null;
    then 
      KernelInstall=0;
    else
      echo "[!]Skipping install of custom kernel..[!]";
      SkipInstall="true";
   fi 
fi
######^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^###############


if [ ${KernelInstall} -eq 0 ]
 then
   echo "[!]This program will be removing the currently installed kernel![!]";
   echo "[?]Are you CERTAIN that you want to install the custom kernel?[?]";
   read -p "Response: (Y|N)" response;
   if echo ${response} | grep -E "(Y|y).*" &> /dev/null;
    then
      echo "[I]Removing current kernel...[I]";
      apt-get remove $(dpkg --list | fgrep kernel | sed 's/ii//g'  | egrep "Linux kernel" | fgrep -v tools | awk '{print $1}') -y;
      if [ $? -ne 0 ]
       then
         echo "[!]CRITICAL[!]"
         echo "[!]There was a problem removing your current kernel!![!]";
         echo '[!]LOOK OVER THESE ERROR MESSAGES CAREFULLY[!]';
         exit 5;
      fi
      echo "[I]Installing custom kernel that supports packet injection...[I]";
      #Start installing the custom kernel...#
      #http://talk.maemo.org/showthread.php?t=65232&page=107  Forensics and packetinjection?# 
      dpkg -i /home/user/MyDocs/.weaponize/n900weapons/kernel/kernel-power_2.6.28-10power51r1_armel.deb;
      if [ $? -ne 0 ]
       then
         echo "[!]CRITICAL[!]"
         echo "[!]There was a problem installing kernel-power_2.6.28-10power51r1_armel!![!]";
         echo '[!]LOOK OVER THESE ERROR MESSAGES CAREFULLY[!]';
         exit 5;
      fi
      dpkg -i /home/user/MyDocs/.weaponize/n900weapons/kernel/kernel-power-headers_2.6.28-10power51r1_armel.deb;
      if [ $? -ne 0 ]
       then
         echo "[!]CRITICAL[!]"
         echo "[!]There was a problem installing kernel-power-headers_2.6.28-10power51r1_armel!![!]";
         echo '[!]LOOK OVER THESE ERROR MESSAGES CAREFULLY[!]';
         exit 5;
      fi
      dpkg -i /home/user/MyDocs/.weaponize/n900weapons/kernel/kernel-power-modules_2.6.28-10power51r1_armel.deb;
      if [ $? -ne 0 ]
       then
         echo "[!]CRITICAL[!]"
         echo "[!]There was a problem installing kernel-power-modules_2.6.28-10power51r1_armel!![!]";
         echo '[!]LOOK OVER THESE ERROR MESSAGES CAREFULLY[!]';
         exit 5;
      fi
      dpkg -i /home/user/MyDocs/.weaponize/n900weapons/kernel/kernel-power-flasher_2.6.28-10power51r1_armel.deb;
      if [ $? -ne 0 ]
       then
         echo "[!]CRITICAL[!]"
         echo "[!]There was a problem installing kernel-power-flasher_2.6.28-10power51r1_armel.deb!![!]";
         echo '[!]LOOK OVER THESE ERROR MESSAGES CAREFULLY[!]';
         exit 5;
      fi
      echo "[I]Installing some more useful hostmode-gui, qtmobilehotspot and wlan driver selector app..[I]";
      apt-get install status-area-wlan-driver-selector-applet hostmode-gui qtmobilehotspot --force-yes -y;
      if [ $? -ne 0 ];
       then
         echo "[!]There was a problem installing these tools![!]";
         exit 4;
      fi
      echo "[I]Customizing status-area-wlan-driver-selector-applet per current config..[I]";
      gconftool-2 --set /apps/wlan_driver_selector/driver_folder --type string "/opt/packet-injection-modules/2.6.28.10-power51";
      if ! cat /usr/sbin/pcsuite-enable.sh | fgrep "\-o wlan0 \-j MASQUERADE" &> /dev/null;
       then
         echo "[I]Adjusting pcsuite-enable.sh...[I]";
         cat /usr/sbin/pcsuite-enable.sh | sed 's/exit 0//g' > /usr/sbin/pcsuite-enable.NEW;
         echo 'echo 1 > /proc/sys/net/ipv4/ip_forward' >> /usr/sbin/pcsuite-enable.NEW;
         echo 'iptables -t nat -F POSTROUTING' >> /usr/sbin/pcsuite-enable.NEW;
         echo 'iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE' >> /usr/sbin/pcsuite-enable.NEW;
         echo 'iptables -t nat -A POSTROUTING -o gprs0 -j MASQUERADE' >> /usr/sbin/pcsuite-enable.NEW;
         echo 'ifup usb0' >> /usr/sbin/pcsuite-enable.NEW;
         echo 'dnsmasq -I lo -z -a 192.168.2.15 -F 192.168.2.64,192.168.2.127' >> /usr/sbin/pcsuite-enable.NEW;
         echo 'exit 0' >> /usr/sbin/pcsuite-enable.NEW;
         mv /usr/sbin/pcsuite-enable.sh /usr/sbin/pcsuite-enable.bk;
         mv /usr/sbin/pcsuite-enable.NEW /usr/sbin/pcsuite-enable.sh;
         chmod a+x /usr/sbin/pcsuite-enable.sh;
       fi
    else 
      echo "[I]Skipping install of custom kernel..[I]";
   fi
fi


echo "[I]Installing some other useful tools..[I]";
apt-get install cell-modem-ui 3g2g-mode-selection-applet simple-brightness-applet ntorch pc-connectivity-manager --force-yes -y;
if [ $? -ne 0 ];
 then
   echo "[!]There was a problem installing these tools![!]";
   exit 4;
fi


if [ ! -e /usr/bin/tether ]
 then
   echo "[I]Installing useful tethering script.. (Thanks jschan :-) )[I]";
   mkdir /home/user/MyDocs/.weaponize/scripts/tether/; 
   cd /home/user/MyDocs/.weaponize/scripts/tether/;
   wget 'http://talk.maemo.org/attachment.php?attachmentid=21253&amp;d=1310189015' -O tether.tar;
   if [ $? -ne 0 ];
    then
      echo "[!]There was a problem downloading a useful tether.sh script..[!]";
      exit 4;
   fi
   /home/user/MyDocs/.weaponize/scripts/tether/;
   tar -xvf tether.tar;
   cd /home/user/MyDocs/.weaponize/scripts/tether/opt/tether;
   mkdir /opt/tether;
   cd /home/user/MyDocs/.weaponize/scripts/tether/opt/tether;
   cp tether-dbus-config /etc/dbus-scripts.d/;
   cp tether-dbus-controller.sh tether.sh /opt/tether
   cp tether.sh /usr/bin/tether
   chmod a+x /usr/bin/tether;
   cd /home/user/MyDocs/.weaponize/scripts/tether/;
   rm -rf opt;
   rm -rf teth*;
fi

if grep "DisablePlugins" /etc/bluetooth/main.conf | fgrep network &> /dev/null;
 then
   echo "[I]Editing bluetooth main.conf file..[I]";
   cp /etc/bluetooth/main.conf /etc/bluetooth/main.conf.bk
   sed 's/DisablePlugins = network,input,hal/DisablePlugins = hal/g' /etc/bluetooth/main.conf.bk > cp /etc/bluetooth/main.conf;
fi

if [ ! -e /usr/bin/update ]
 then
   cd ${PresentDir};
   cp update.sh /usr/bin/update;
   chmod a+x /usr/bin/update;
fi

if [ ! -e /usr/bin/listweapons ]
 then
  cd ${PresentDir};
  cp listweapons.sh /usr/bin/listweapons;
  chmod a+x /usr/bin/listweapons;
fi

apt-get clean;

apt-get autoremove -y;

if [ ! -e /etc/weaponized ];
 then
   echo "This phone has been weaponized on $(date)" >> /etc/weaponized;  
   echo 'Website: zitstif.no-ip.org' >> /etc/weaponized;
   echo '75eea509c19cc66576a1bdea893834f8291c2d96' >> /etc/weaponized;
fi

echo "[!]You should reboot your phone![!]";
exit 0;
