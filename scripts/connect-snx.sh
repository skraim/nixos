#!/usr/bin/env expect

set timeout 10
set states_output [exec sh -c "set -a; . ~/states; env"]

foreach line [split $states_output "\n"] {
    if {[regexp {^([^=]+)=(.*)$} $line -> key val]} {
        set ::env($key) $val
    }
}

set otp [exec pass otp $env(SNX_OTP_KEY)]

spawn snxctl connect

expect "Enter Your Microsoft verification code"
send "$otp\r"

expect {
    -re "Server name: (\[^\r\n\]*)\r\n.*?Tunnel type: (\[^\r\n\]*)" {
        set server [string trim $expect_out(1,string)]
        set tunnel [string trim $expect_out(2,string)]
        exec dunstify -t 2000 -a "SNX" "Connected" "Server: $server\nTunnel: $tunnel"
    }
    timeout {
        exec dunstify -t 2000 -u critical -a "SNX" "Failed to get connection details"
        exit 1
    }
}

interact
