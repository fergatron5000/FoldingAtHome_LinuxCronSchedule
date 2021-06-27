#bin/sh

if FAHClient --version; then

    # create initial pause / unpause scrips
    mkdir /usr/local/bin/FAHClientScripts/
    echo "#bin/sh" > /usr/local/bin/FAHClientScripts/pause.sh
    echo "#bin/sh" > /usr/local/bin/FAHClientScripts/unpause.sh

    # add the actuall pause / unpause commands (note, you are 'sending' the command, not directly executing it.)
    echo "FAHClient --send-pause" > /usr/local/bin/FAHClientScripts/pause.sh
    echo "FAHClient --send-unpause" > /usr/local/bin/FAHClientScripts/unpause.sh
    
    # make sure the scripts are executable
    chmod +x /usr/local/bin/FAHClientScripts/pause.sh
    chmod +x /usr/local/bin/FAHClientScripts/unpause.sh

    crontab -l > tmpcron

    # CRON Schedules (times are based on system clock's time zone)
    # PAUSE - every day at 8AM (0800)
    # RESUME - (weekdays) - Sunday - Thursday at 10PM (2200)
    # RESUME - (weekends) - Friday & Saturday at 11:59PM (2359)
    echo "0 8 * * * /usr/local/bin/FAHClientScripts/pause.sh" >> tmpcron
    echo "0 22 * * 0-4 /usr/local/bin/FAHClientScripts/unpause.sh" >> tmpcron
    echo "59 23 * * 5,6 /usr/local/bin/FAHClientScripts/unpause.sh" >> tmpcron

    crontab tmpcron
    rm tmpcron
else
    echo Could not detect FAHClient, no components installed or updated.
fi