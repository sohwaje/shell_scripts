#!/bin/sh
# messages에 찍히는 systemd 관련 로깅을 중지한다.
echo 'if $programname == "systemd" and ($msg contains "Removed session" or $msg contains "Starting User Slice of" or $msg contains "Stopping User Slice of" or $msg contains "Created slice" or $msg contains "Removed slice" or $msg contains "Starting user-" or $msg contains "Stopping user-" or $msg contains "Started Session" or $msg contains "Starting Session") then stop' > /etc/rsyslog.d/ignore-systemd-session-slice.conf

systemctl restart rsyslog
