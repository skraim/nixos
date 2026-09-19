#!/usr/bin/env expect

set timeout 60
set states_output [exec sh -c "set -a; . ~/states; env"]

foreach line [split $states_output "\n"] {
    if {[regexp {^([^=]+)=(.*)$} $line -> key val]} {
        set ::env($key) $val
    }
}

set home $env(HOME)

spawn snxctl connect

expect {
    "Enter Your Microsoft verification code" {
        set otp [exec pass otp $env(SNX_OTP_KEY)]
        send "$otp\r"
    }
    timeout {
        exec notify-send -t 3000 -u critical -a "SNX" "Timed out waiting for verification prompt"
        exit 1
    }
    eof {
        exec notify-send -t 3000 -u critical -a "SNX" "snxctl exited unexpectedly"
        exit 1
    }
}

expect {
    -re "Server name: (\[^\r\n\]*)\\r\\n.*?Tunnel type: (\[^\r\n\]*)" {
        set server [string trim $expect_out(1,string)]
        set tunnel [string trim $expect_out(2,string)]
        exec notify-send -t 3000 -a "SNX" -i "$home/.icons/custom/vpn-on.svg" "Connected" "Server: $server\nTunnel: $tunnel"
        puts {vpn_status {"name":"SNX","state":"connected"}}
    }
    timeout {
        exec notify-send -t 3000 -u critical -a "SNX" "Failed to get connection details"
        exit 1
    }
    eof {
        exec notify-send -t 3000 -u critical -a "SNX" "snxctl exited unexpectedly"
        exit 1
    }
}

interact
