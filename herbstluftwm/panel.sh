#!/bin/bash

# todo: fontello icons

# disable path name expansion or * will be expanded in the line
# cmd=( $line )
set -f

function uniq_linebuffered() { 
	awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}
#function uniq_linebuffered() {
#    awk -W interactive '$0 != l { print ; l=$0 ; fflush(); }' "$@"
#}
#function get_mpd_song() {
#    # use mpc to get currently playing song, uppercase it
#    song=$(mpc current -h $HOME/.mpdsock -f %title%)
#    # let's skip ft. parts, etc. to get some more space
#    echo -n $song | sed 's/\(.*\)/\U\1/' | sed 's/(.*//' | sed 's/ -.*//' | sed 's/ 
#$//'
#}

function get_ip () {
	IP=$(ip addr show dev $1 | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sed 's/inet //')
	if [[ "$IP" != "" ]] ; then
		echo "\\\f4$2:\\\fr${IP}"
	else
		echo ""
	fi
}

function get_volume () {
 	echo $(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget Master))
}

monitor=${1:-0}

separator="\f0 | \fr"
#song=$(get_mpd_song)

herbstclient pad $monitor 18
{
    # events:
    # mpc events
    #mpc -h $HOME/.mpdsock idleloop player &
    #mpc_pid=$!
	
	#load
    while true ; do
		echo "load $(cut -d ' ' -f1 /proc/loadavg)";
		sleep 5 || break
	done > >(uniq_linebuffered) &
	cpu_pid=$!

	#volume
    while true ; do
		echo "volume $(get_volume)";
		sleep 1 || break
	done > >(uniq_linebuffered) &
	vol_pid=$!
	
	#network
	while true ; do
		echo "network_wifi0 $(get_ip wifi0 W)"
		echo "network_net0 $(get_ip net0 E)"
        sleep 10 || break
    done > >(uniq_linebuffered) &
	net_pid=$!

	# battery
	while true ; do
		echo "battery $(cat /sys/class/power_supply/BAT0/capacity)%"
		echo "battery_left $(acpi | egrep -o '[0-9]{2}:[0-9]{2}' | sed '/00/s/$/ min/;s/00://')"
        sleep 60 || break
    done > >(uniq_linebuffered) &
    batt_pid=$!

    # date
    while true ; do
        date +'date_day %A %e.  '
        date +'date_min %H:%M  '
        sleep 1 || break
    done > >(uniq_linebuffered) &
    date_pid=$!

    # hlwm events
    herbstclient --idle

    # exiting; kill stray event-emitting processes
    kill $date_pid $batt_pid $net_pid $vol_pid #$mpd_pid
} 2> /dev/null | {
    TAGS=( $(herbstclient tag_status $monitor) )
    unset TAGS[${#TAGS[@]}-1]
	network=""
	load=""
    date_day=""
    date_min=""
	volume=""
	battery=""
	battery_left=""
    visible=true

    while true ; do
        echo -n "\c"
        for i in "${TAGS[@]}" ; do
            case ${i:0:1} in
                '#') # current tag
                    echo -n "\u0\fr"
                    ;;
                '+') # active on other monitor
                    echo -n "\u3\fr"
                    ;;
                ':')
                    echo -n "\ur\fr"
                    ;;
                '!') # urgent tag
                    echo -n "\u1\f1"
                    ;;
                *)
                    echo -n "\ur\f2"
                    ;;
            esac
            echo -n " ${i:1} " | tr '[:lower:]' '[:upper:]'
        done
        # align left
        echo -n "\l"
		echo -n "$network_wifi0"
		echo -n "$network_net0"
        echo -n "$separator"
        # display song and separator only if something's playing
        #if [[ $song ]]; then
        #    echo -n "\ur\fr  $song$separator"
        #fi

        # align right
        echo -n "\r\ur\fr\br"
		echo -n "$load"
		echo -n "$separator"
		echo -n "$volume"
        echo -n "$separator"
		echo -n "$battery\f4/\fr$battery_left"
        echo -n "$separator"
        echo -n "$date_day" | tr '[:lower:]' '[:upper:]'
        echo -n " \f2"
        echo -n "$date_min   " | tr '[:lower:]' '[:upper:]'
        echo
        # wait for next event
        read line || break
        cmd=( $line )
        # find out event origin
        case "${cmd[0]}" in
            tag*)
                TAGS=( $(herbstclient tag_status $monitor) )
                unset TAGS[${#TAGS[@]}-1]
                ;;
            date_day)
                date_day="${cmd[@]:1}"
                ;;
            date_min)
                date_min="${cmd[@]:1}"
                ;;
            battery)
                battery="${cmd[@]:1}"
                ;;
            battery_left)
                battery_left="${cmd[@]:1}"
                ;;
            #player)
            #    song=$(get_mpd_song)
            #    ;;
			network_wifi0)
				network_wifi0="${cmd[@]:1}"
				;;
			network_net0)
				network_net0="${cmd[@]:1}"
				;;
			volume)
				volume="${cmd[@]:1}"
				;;
			load)
				load="${cmd[@]:1}"
				;;	
            quit_panel)
                exit
                ;;
            reload)
                exit
                ;;
        esac
    done
} 2> /dev/null | bar $1
