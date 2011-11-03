#!/bin/bash
#Licensed under GPLv3
#stevenwoo
insertBreak () {
	echo "" >> $filename;
	echo "----------------------------------------" >> $filename;
	echo "" >> $filename;
}

if [ $# -eq 1 ]
then 
	filename=$1".parsed";

	echo "#####PERMA MODS#####" >> $filename;
	begin=`cat $1 | grep "txtSelfMods" -n | cut -d ":" -f1`;
	end=`cat $1 | grep "<\/textarea>" -n | sed '1,3d' | head -n 1 | cut -d: -f1`;
	sed -n "$begin,$end p" $1 | tr -s " " >> $filename;
	insertBreak;
	echo "wrote lines $begin to $end";
	
	echo "#####ON MOD TEXT#####" >> $filename; 
	begin=`cat $1 | grep "txtOnMod" -n | cut -d ":" -f1`;
	end=`cat $1 | grep "<\/textarea>" -n | sed '1,4d' | head -n 1 | cut -d: -f1`;
	sed -n "$begin,$end p" $1 | tr -s " " >> $filename;
	insertBreak;
	echo "wrote lines $begin to $end";

	echo "#####MOD TO MOD NOTES#####" >> $filename; 
	begin=`cat $1 | grep "txtModToModNotes" -n | cut -d ":" -f1`;
	end=`cat $1 | grep "<\/textarea>" -n | sed '1,5d' | head -n 1 | cut -d: -f1`;
	sed -n "$begin,$end p" $1 | tr -s " " >> $filename;
	insertBreak;
	echo "wrote lines $begin to $end";

        echo "#####txt Triggers Exact#####" >> $filename;
        begin=`cat $1 | grep "txtTriggersExact" -n | cut -d ":" -f1`;
        end=`cat $1 | grep "<\/textarea>" -n | sed '1,7d' | head -n 1 | cut -d: -f1`;
        sed -n "$begin,$end p" $1 | tr -s " " >> $filename;
        insertBreak;
	echo "wrote lines $begin to $end";

        echo "#####txt Triggers Contain#####" >> $filename;
        begin=`cat $1 | grep "txtTriggersContain" -n | cut -d ":" -f1`;
        end=`cat $1 | grep "<\/textarea>" -n | sed '1,8d' | head -n 1 | cut -d: -f1`;
        sed -n "$begin,$end p" $1 | tr -s " " >> $filename;
        insertBreak;
	echo "wrote lines $begin to $end";

        echo "#####DO NOT MOD LIST#####" >> $filename;
        begin=`cat $1 | grep "txtDoNotMod" -n | cut -d ":" -f1`;
        end=`cat $1 | grep "<\/textarea>" -n | sed '1,9d' | head -n 1 | cut -d: -f1`;
        sed -n "$begin,$end p" $1 | tr -s " " >> $filename;
        insertBreak;
	echo "wrote lines $begin to $end";

        echo "#####PERMA BAN LIST#####" >> $filename;
        begin=`cat $1 | grep "txtPermaBanned" -n | cut -d ":" -f1`;
        end=`cat $1 | grep "<\/textarea>" -n | sed '1,10d' | head -n 1 | cut -d: -f1`;
        sed -n "$begin,$end p" $1 | tr -s " " >> $filename;
        insertBreak;
	echo "wrote lines $begin to $end";
	
	##clean up
	cat $filename | sed -e "s/^ <.*\">//" -e "s/<\/.*>//" | tee $filename 1>/dev/null;
	rm $1;
	exit 0;

else
	echo "execute: $0 filename";
	exit 1;
fi

