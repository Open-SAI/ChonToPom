#!/bin/bash

print_help (){
	echo USAGE FROM TERMINAL: 
	echo ./chontoBash.sh NumMinutesToWork \"My Task to work in double quotes...\"
	echo If not exist, chonto will create the log file log.chonto, csv file to make data analytics:
	echo TimeStamp, TotalMinutes, Task worked...
	echo TimeStamp, TotalMinutes, Task worked...
	echo TimeStamp, TotalMinutes, Task worked...
	echo .
	echo .
	echo .
}

log_chonto_break (){
	
	end_time=$( date '+%s' )
	echo $(date +"%F %H:%M:%S"), $((($end_time - $1) / 60)) Mins, "$2", BREAK >> log.chonto
	mplayer glass.ogg > /dev/null 2>&1
	tput clear
	echo "Unfinished task logged :("
	tput cnorm
	exit 1
}

log_chonto (){
	end_time=$( date '+%s' )
	echo $(date +"%F %H:%M:%S"), $((($end_time - $1) / 60)) Mins, "$2", FULL >> log.chonto
	mplayer glass.ogg > /dev/null 2>&1
	tput clear
	echo "Task finished logged :)"
	tput cnorm
}

print_timer (){
	#center the timer text, centering the cursor in Y/2:X/2-((text length)/2) 
	tput cup $(($3/2)) $((($4/2)-($(expr length "$1 $2")/2)))
	tput bold; tput setaf $((1 + RANDOM % 10)); tput rev; echo "$1$2"; tput sgr0;
}

if [[ $# != 2 ]]; then
	tput bold; echo Error in arguments...; tput sgr0;
	echo
	print_help
	exit 1
fi

if ! [[ $1 =~ ^[0-9]+$ ]]; then
	tput bold; echo ...how many minutes do you like to work?; tput sgr0;
	echo
	print_help
	exit 1
fi

MINS=$1
start_time=$( date '+%s' )

tput civis

trap 'log_chonto_break "$start_time" "$2"' SIGINT

for (( MINSCount=1; MINSCount<=$MINS; MINSCount++))
do
	for (( SECSCount=1; SECSCount<=60; SECSCount++))
	do
		#clear
		tput clear
		print_timer " $(($MINS-$MINSCount)) Minutes " "$((60-$SECSCount)) Seconds to rest... " "$(tput lines)" "$(tput cols)"
		sleep 1
	done
done

log_chonto "$start_time" "$2"

