//Created by stevenwoo
//Licensed under GPLv3
//rotate background script


// -->add your mods here, these people will be allowed to control various things
var room_permamods = ["stevenwoo"];

// -->add your images here
var bkground_images = ["http://i.imgur.com/XNF1X.jpg", "http://i.imgur.com/vAXVa.jpg", "http://i.imgur.com/FT9SG.jpg"]; 

var bkground_slideshow = 0; // not implemented yet
var bkground_images_enabled = true;
var bkground_rotate_time = 3600; // time it takes to set another image, in seconds
var bkground_clock = new Date().getTime();
var bkground_min_rotate_time = 900; // minimum rotate time for images

var bot_name = "imgbot";
var bot_active = true;

function botStart(){
	if (room_permamods.length == 0){
		botSend("there's no one in your mod list, add some people");
	}
}

function botEnd(){
	bot_active=false;
}

function botProcessLine(who, line){
	if (room_permamods.indexOf(who) != -1 && line.search(/^\![a-zA-Z0-9 \.\/]/) != -1){
		modExec(who, line);
	}
	checkToRotateBackgroundImage();
}

function addBackgroundImage(who, cmds){
	if (room_permamods.indexOf(who) != -1 && cmds[1].search(/^http\:\/\/i\.imgur\.com\/.*/) != -1 && bkground_images.indexOf(cmds[1]) == -1){
		bkground_images.push(cmds[1]);
		botSend("/tellmods "+who+" added the image "+cmds[1]);
	}
	else{
		botSend("/msg "+who+" you either have no permission or this isn't an imgur direct link");
	}
}
function removeBackgroundImage(who, cmds){
	if (room_permamods.indexOf(who) != -1){
		for (var i = 1; i < cmds.length; i++){
			var index = bkground_images.indexOf(cmds[i]);
			if (index != -1){
				botSend("/tellmods "+who+" has removed the image "+bkground_images[index]); //saves a variable if I do it this way
				bkground_images.splice(index,1);
			}
		}
	}
}

function findBackgroundImage(who, cmds){
	if (room_permamods.indexOf(who) != -1){
		if (bkground_images.indexOf(cmds[1]) != -1){
			botSend("/msg "+ who+" that image is in the backgrounds list");
		}
		else{
			botSend("/msg "+ who+" that image is **not** in the backgrounds list");
		}
	}
}

function forceBackgroundRotate(who, cmds){
	if (room_permamods.indexOf(who) != -1 && bkground_images_enabled == true){
		var rand=Math.floor(Math.random()*bkground_images.length);
		botSend("/back "+bkground_images[rand]);
	}
}
function toggleBackgroundImagesStatus(who, cmds){ // background rotate on?
	if (room_permamods.indexOf(who) != -1){
		if (bkground_images_enabled == true){ //can't think of a better way to do this at 3 AM, fail.
			bkground_images_enabled = false;	
			botSend("/tellmods background image rotation has been **disabled**");
		}
		else{
			bkground_images_enabled = true;
			botSend("/tellmods background image rotation has been **enabled**");	
		}
	}
}

function setBackgroundImageRotateTime(who, cmds){
	if (room_permamods.indexOf(who) != -1){
		if (!isNaN(cmds[1]) && cmds[1] > bkground_min_rotate_time){
			setBackgroundImageRotateTime = cmds[1];
			botSend("/tellmods "+who+" has set the background image rotate time to "+cmds[1]);
		}
		else{
			botSend("/msg "+who+" this is not a number or the time you set is < "+bkground_min_rotate_time+ " seconds");
		}
	}
}

function checkToRotateBackgroundImage(){ //specific cron job
	var currentTime = new Date().getTime();
	difference = (currentTime - bkground_clock)/1000;
	if (difference >= bkground_rotate_time && bkground_images_enabled == true){ // y u no && bkground_images_enabled instead?
		var rand=Math.floor(Math.random()*bkground_images.length);
		botSend("/back "+bkground_images[rand]);
		bkground_clock = currentTime;
	}
}

function modExec(who, cmdStr){
	var cmds = cmdStr.split(" ");
	switch (cmds[0]){
		case "!addbkground" :
			addBackgroundImage(who, cmds);
		break;
		case "!rmbkground" : 
			removeBackgroundImage(who, cmds);
		break;
		case "!findbkground" :
			findBackgroundImage(who, cmds);
		break;
		case "!rotatebkground" :
			forceBackgroundRotate(who, cmds);
		break;
		case "!togglebkgroundstatus" :
			toggleBackgroundImagesStatus(who, cmds);
		break;
		case "!setbkgroundtime" :
			setBackgroundImageRotateTime(who, cmds);
		break;
		// mod helper functions 
		case "!whoami" :
			botSend("/msg "+ who+ " You are a mod user");
		break;
		case "!help":
			botSend("/msg "+who+" !addbkground imgurURL, !rmbkground imgurURL, !findbkground imgurURL, !rotatebkground, !togglebkgroundstatus, !setbkgroundtime seconds, !whoami");
		break;
		default : 
			botSend("/msg "+who +" I'm sorry "+who+", I'm afraid I can't do that.");
		break;
	}
}