#!/bin/bash
#    mod_delimiter       : "*",
#    donator_delimiter   : "!",
#    idle_delimiter      : "#",
#    icon_delimiter      : "~",
#    cam?		 : "[c~]13hexUsername.e"

#work in progress
#able to join a room
#able to get messages in main chat
#able to send messages

APIKey="";
Room="";
BotName="";
sleepTime=5;

function joinRoom(){
curl -s "http://www.icanhazchat.com/api.ashx?v=1&u=$BotName&p=$APIKey&a=join&w=$Room" | head -n 2 | tr -s "\n" " " > key;
roomKey="";
grep "OK" key;
if [ $? -eq 0 ]
then
	roomKey=`cut -d " " -f2 key`;
else
	echo "Failed to join Room";
fi
}

function getMsg (){
data=`curl -s "http://www.icanhazchat.com/api.ashx?v=1&u=$BotName&k=$roomKey&a=recv"`;
if [ $? -ne 0 ]
then
	echo "Error occured ".$data > bot.log
fi
echo "$data";
#echo `date`."$data" >> output.log;
}

function sendMsg () {
#Reference: http://www.w3schools.com/tags/ref_urlencode.asp
value=`echo $1 | sed 's/ /%20/g;s/!/%21/g;s/"/%22/g;s/#/%23/g;s/\&/%26/g;s/'\''/%28/g;s/(/%28/g;s/)/%29/g;s/:/%3A/g;s/\//%2F/g'`;
echo "VALUE:"$value
str="http://www.icanhazchat.com/api.ashx?v=1&u=$BotName&k=$roomKey&a=send&w=$value";
echo "STR:"$str;
curl -s $str;
}

##### Main Method starts here#####
joinRoom;

while [ true ]
do
	getMsg;
	sleep $sleepTime;
done
fi
