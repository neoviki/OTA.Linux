#!/bin/bash
APP_TO_RUN_ON_STARTUP="ota.monitor"

#Ensure rc.local exists and is executable
if [ ! -f /etc/rc.local ]; then
  echo "[ERROR] /etc/rc.local does not exist. This system may not use rc.local for startup."
  exit 1
fi

#Display the current content of rc.local
echo "CURRENT FILE CONTENT [/etc/rc.local]"
echo
cat /etc/rc.local
echo
echo

#Make sure ota.monitor is executable
chmod +x "$APP_TO_RUN_ON_STARTUP"

#Ensure rc.local is executable
sudo chmod +x /etc/rc.local

#Remove any existing instances of exit 0 (just to make sure we append correctly)
sudo sed -i '/exit 0/d' /etc/rc.local >/dev/null 2>&1

#Add the application to be executed at startup
echo "$APP_TO_RUN_ON_STARTUP &" | sudo tee -a /etc/rc.local >/dev/null 2>&1
echo "exit 0" | sudo tee -a /etc/rc.local >/dev/null 2>&1

#Display the updated content of rc.local
echo
echo
echo "UPDATED FILE CONTENT [/etc/rc.local]"
echo
cat /etc/rc.local
echo

