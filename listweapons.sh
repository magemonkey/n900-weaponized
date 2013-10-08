#!/bin/bash
# $Id: listweapons.sh 11/10/2012
# email: zitstif[@]gmail.com
# website: http://zitstif.no-ip.org/
# name: Kyle Young
# Bash shell script for listning installed tools (or 'weapons') on
# weaponized nokia n900s

if ! bash --version | fgrep "version 4" &> /dev/null;
 then
   echo '[!]This program needs bash4 installed![!]';
   exit 1;
fi


declare -A weapons;

weapons[3g2g-mode-selection-applet]="Switch between the three network modes (3G, 2G and Dual) from the status menu";
weapons[aircrack-ng]="Aircrack-ng is a set of tools for auditing wireless networks.";
weapons[bluez-hcidump]="Analyses Bluetooth HCI packets";
weapons[bozocrack]="BozoCrack is a depressingly effective MD5 password hash cracker with almost zero CPU/GPU load.";
weapons[busybox-power]="Tiny utilities for small and embedded systems - enhanced package";
weapons[bzip2]="high-quality block-sorting file compressor - utilities";
weapons[cadaver]="command-line WebDAV client";
weapons[cain-and-abel-Wordlist]="Word list from the Windows hacking tool program Cain And Abel";
weapons[cell-modem-ui]="Adds Tablet Mode/Phone Mode buttons to powerkey menu.";
weapons[cge]="Cisco Global Exploiter is a hacking tool used to find and exploit vulnerabilities in Cisco Network-systems.";
weapons[cleven]="Cleven is a user interface of aircrack-ng and reaver for the N900.";
weapons[cowpatty]="coWPAtty is designed to audit the pre-shared key (PSK) selection for WPA networks based on the TKIP protocol.";
weapons[curl]="command line tool for transferring data with URL syntax";
weapons[dig]="Query the DNS in various ways";
weapons[dnschef]="DNSChef is a highly configurable DNS proxy for Penetration Testers and Malware Analysts.";
weapons[dsniff]="dsniff is a collection of tools for network auditing and penetration testing";
weapons[easy-deb-chroot]="Scripts to run Debian applications easily in Maemo";
weapons[ettercap]="Multipurpose sniffer/interceptor/logger for switched LAN";
weapons[evtparse]="script to parse Windows 2000/XP/2003 Event Log files";
weapons[evtrpt]="script to parse Windows 2000/XP/2003 Event Log files";
weapons[exif]="command-line utility to show EXIF information in JPEG files";
weapons[exiv]="EXIF/IPTC metadata manipulation tool";
weapons[exiftool-kit]="ExifTool is a platform-independent Perl library plus a command-line application for reading, writing and editing meta information in a wide variety of files";
weapons[file]='Determines file type using "magic" numbers';
weapons[findmyhash]="try to crack different types of hashes using free online services";
weapons[fping]="fping is a ping-like program which uses the (ICMP) echo request to determine";
weapons[gcc-4.6]="GNU C compiler";
weapons[geoip-database]="IP lookup command line tools that use the GeoIP library (country database)";
weapons[git-core]="fast, scalable, distributed revision control system";
weapons[gnupg]="GNU privacy guard - a free PGP replacement";
weapons[gpscorrelate-gui]="Correlates digital photos with GPS data filling EXIF fields (GUI)";
weapons[grep-gnu]="GNU grep, egrep and fgrep";
weapons[hexedit]="view and edit files in hexadecimal or in ASCII";
weapons[hideuseragent]="Allows to hide Maemo Web browser User Agent";
weapons[iodine]="iodine lets you tunnel IPv4 data through a DNS server";
weapons[iptables]="administration tools for packet filtering and NAT";
weapons[john]="active password cracking tool";
weapons[kismet]="Wireless 802.11b monitoring tool";
weapons[less]="pager program similar to more";
weapons[lynx]="Text-mode WWW Browser";
weapons[macchanger]="A GNU/Linux utility for viewing/manipulating the MAC address of network interface";
weapons[maegios]="Receive Nagios alerts on your Maemo device. Monitor status of hosts and services in your Nagios instance. Desktop widget and vibration, sound, light, text alerts are included."
weapons[man]="Package containing man pages for man-db";
weapons[metagoofil]="Metagoofil is an information gathering tool designed for extracting metadata of public documents (pdf,doc,xls,ppt,docx,pptx,xlsx) belonging to a target company.";
weapons[metasploit]="The Metasploit Project is a computer security project which provides information about security vulnerabilities and aids in penetration testing and IDS signature development.";
weapons[minicom]="Minicom is a text-based modem control and terminal emulation program for Unix-like operating systems, originally written by Miquel van Smoorenburg, and modeled after the popular MS-DOS program Telix.";
weapons[miredo]="Teredo IPv6 tunneling through NATs";
weapons[mork]="This is a program that can read the Mozilla URL history file";
weapons[mtr-tiny]="Full screen ncurses traceroute tool";
weapons[nano-opt]="GNU nano - an enhanced clone of the Pico text editor.";
weapons[netcat]="TCP/IP swiss army knife";
weapons[nikto]="A web server scanner which performs tests against web servers for multiple items, including over 2200 potentially dangerous files/CGIs";
weapons[nmap]="Command line open-source network and security scanning tool";
weapons[notmynokia]="Prevent MyNokia registration";
weapons[ntorch]="Switches on/off camera's flash";
weapons[openssl]="Secure Socket Layer (SSL) binary and related cryptographic tools";
weapons[openssh-client]="Secure shell client, an rlogin/rsh/rcp replacement";
weapons[openssh-server]="Secure shell server, an rshd replacement";
weapons[kbvpn-client]="VPN client application";
weapons[PACK]='PACK was developed in order to aid in a password cracking competition "Crack Me If You Can" that occurred during Defcon 2010.';
weapons[pc-connectivity-manager]='Tablet PC-Connectivity Manager.';
weapons[perl]="Larry Wall's Practical Extraction and Report Language.";
weapons[privoxy]="Privacy enhancing HTTP Proxy"
weapons[proxytunnel]="Create tcp tunnels trough HTTPS proxies, for using with SSH";
weapons[python2.5]="An interactive high-level object-oriented language (version 2.5)";
weapons[python2.5-devs]="Header files and a static library for Python (v2.5)";
weapons[python2.5-libxml2]="Python bindings for the GNOME XML library";
weapons[python-httplib2]="A comprehensive HTTP client library written in python";
weapons[python-pycurl]="Python bindings to libcurl";
weapons[python-scapy]="Packet generator/sniffer and network scanner/discovery";
weapons[python-simplejson]="Simple, fast, extensible JSON encoder/decoder for Python";
weapons[python-twisted-conch]="The Twisted SSH Implementation";
weapons[python-twisted-web]="An HTTP protocol implementation together with clients and servers";
weapons[qtwol]="Simple Wake On Lan application";
weapons[rdesktop]="RDP client for Windows NT/2000 Terminal Server";
weapons[reaver]="brute force attack tool against Wifi Protected Setup PIN number";
weapons[recovery-tools]="TestDisk & PhotoRec recovery tools";
weapons[ruby1.8]="Interpreter of object-oriented scripting language Ruby 1.8"
weapons[sed-gnu]="The GNU sed stream editor";
weapons[simple-brightness-applet]="Simple brightness statusarea applet";
weapons[svmap]="this is a sip scanner. Lists SIP devices found on an IP range (sipvicious)";
weapons[svwar]="identifies active extensions on a PBX (sipvicious)";
weapons[svcrack]="an online password cracker for SIP PBX (sipvicious)";
weapons[svreport]="manages sessions and exports reports to various formats (sipvicious)";
weapons[svcrash]="attempts to stop unauthorized svwar and svcrack scans (sipvicious)"
weapons[socat]="multipurpose relay for bidirectional data transfer";
weapons[Social-engineering-Toolkit]="It is an open-source Python-driven tool aimed at penetration testing around Social-Engineering.";
weapons[sqlbrute]="A tool for brute forcing data out of databases using blind SQL injection";
weapons[sshfs]="filesystem client based on SSH File Transfer Protocol";
weapons[sslstrip]="It will transparently hijack HTTP traffic on a network, watch for HTTPS links and redirects, then map those links into either look-alike HTTP links or homograph-similar HTTPS links.";
weapons[stunnel4]="Universal SSL tunnel for network daemons";
weapons[tcpdump]="tcpdump is a command line utility for package sniffer."
weapons[tcptraceroute]="traceroute implementation using TCP packets";
weapons[tether]="A useful bluetooth to gprs0 binding tool";
weapons[telnet]="The telnet client";
weapons[theHarvester]="The objective of this program is to gather emails, subdomains, hosts, employee names, open ports and banners from different public sources like search engines, PGP key servers and SHODAN computer database.";
weapons[tor]="anonymizing overlay network for TCP";
weapons[truecrypt]="Cross-Platform Disk Encryption Tool";
weapons[tsocks]="transparent network access through a SOCKS 4 or 5 proxy";
weapons[update]="A tool to safely update your Nokia N900 without breaking it";
weapons[vncviewer]="A VNC viewer for maemo";
weapons[waffit(wafw00f)]="Web Application Firewall Detection Tool";
weapons[wapiti]="Acts like a fuzzer, injecting payloads to see if a script is vulnerable.";
weapons[wget]="retrieves files from the web";
weapons[wine]="Microsoft Windows Compatibility Layer (Binary Emulator and Library)";
weapons[windows-binaries]="Various windows pentesting binaries.";
weapons[wireshark]="network traffic analyzer - GTK+ version";
weapons[whois]="an intelligent whois client";
weapons[zip]="Command-line archiver for .zip files";




for i in "${!weapons[@]}"
 do
  echo "$i - ${weapons[$i]}";
done | sort -f;
