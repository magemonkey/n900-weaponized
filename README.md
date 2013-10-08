n900-weaponized
===============

For those looking to hack their n900 for use in Penetration testing etc. This tool is an important first step.  Originally found here http://www.infosecisland.com/blogview/22700-Weaponizing-the-Nokia-N900--Part-40--A-Three-Year-Anniversary.html created by Kyle Young http://zitstif.no-ip.org/

Firstly, I am not responsible if this program bricks/damages your N900 (but I can assure you as long as you follow my instructions you SHOULD be safe). For best results make sure you have flashed your N900 firmware to version pr1.3 (also for best results my shell script works BEST on freshly flashed N900s). I was not able to get my shell script to work properly with the pr1.2 firmware.

Plug your wall charger into your N900. Make sure you also have strong signal strength to your wireless network.

Once you have your N900 flashed, please root your N900 and install bash4. Then pull up the terminal on your N900 and as root do this:

ln -s /bin/bash4 /bin/bash

Next download this following script to your N900:

http://zitstif.no-ip.org/weaponizen900.tar

(sha1sum: c3699aea31c8ac91684e89bfdda7901bcc7f042e  weaponzenizen900.tar)

Extract it via:

tar -xvf weaponizen900.tar

Then cd into the newly created folder called “n900project” and run as root:

bash weapoinzen900.sh
