#!/bin/bash

#var_management
from_dir="./tests/pond/"
to_dir="./tests/redirect/"
del_flag=0
transfers_done=0
folders_made=0
s_chosen="ext"
#########################|

#flag manager
while getopts 'ds:' OPTION ;
do
    case "$OPTION" in
        d) del_flag=1 ;;
        s) s_chosen=$OPTARG;;
    esac
done
#########################|


#welcome Label
echo "-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^"
echo "|                    Heyyy! Welcome TO t0rvalds                      |"
echo "-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^"
#############################################################################|

#############################################################################|
#main_program
if [ $s_chosen = "ext" ]
then
    echo "t0rvalds : organizing by extension"
for i in `find $from_dir -type f | sed -n '/\..*[^\/]\..*$/p'  ` ;
do
    #echo $i
    name=`echo $i | awk 'BEGIN{FS="/"} {print $NF}'`
    ext=`echo $name | awk 'BEGIN{FS="."} {print $NF}'`
    if [ ! -d $to_dir ]
    then
        echo "t0rvalds : the destination folder doesn't exists, making"
        mkdir $to_dir
    fi

    if [ -d $to_dir/ext_$ext ] ;
    then
        if [ -f $to_dir/ext_$ext/$name ]
        then
            ddmmyyyy=`stat $i | sed -n '/Birth/p' | awk 'BEGIN{FS=" "}{print $2}' | awk 'BEGIN{FS="-"} {print $3$2$1}'`
            mv $to_dir/ext_$ext/$name $to_dir/ext_$ext/dummy
            cp $i $to_dir/ext_$ext
            new_name=`echo $name | sed 's/\.[^.].*$//'`
            mv $to_dir/ext_$ext/$name $to_dir/ext_$ext/$new_name"_"$ddmmyyyy"."$ext
            mv $to_dir/ext_$ext/dummy $to_dir/ext_$ext/$name
            if [ ! -f "$to_dir/ext_$ext/$new_name"_"$ddmmyyyy"."$ext" ]
            then
            echo "t0rvalds : the file $name already exists, copying as $new_name"_"$ddmmyyyy"."$ext"
            fi
        else
        echo "t0rvalds : copying $name to folder ext_$ext"
        cp $i $to_dir/ext_$ext
        fi
        let "transfers_made=transfers_made+1"
        echo $i >> .files_moved
    else
        echo "t0rvalds : making directory ext_$ext"
        mkdir $to_dir/ext_$ext
        let "folders_made=folders_made+1"
        echo "t0rvalds : copying $name to folder ext_$ext"
        cp $i $to_dir/ext_$ext
        let "transfers_made=transfers_made+1"
        echo $i >> .files_moved
    fi
    echo $to_dir/ext_$ext >> .folder_list
done
fi
#######################################################################################################################|

 #############################################################################|
 #main_program_date
 if [ $s_chosen = "date" ]
 then
     echo "t0rvalds : organizing by date created"
 for i in `find $from_dir -type f` ;
 do
     #echo $i
     name=`echo $i | awk 'BEGIN{FS="/"} {print $NF}'`
     ext=`echo $name | awk 'BEGIN{FS="."} {print $NF}'`
     if [ ! -d $to_dir ]
     then
         echo "t0rvalds : the destination folder doesn't exists, creating"
         mkdir $to_dir
     fi
     ddmmyyyy=`stat $i | sed -n '/Birth/p' | awk 'BEGIN{FS=" "}{print $2}' | awk 'BEGIN{FS="-"} {print $3$2$1}'`
     if [ -d $to_dir/$ddmmyyyy ] ;
     then
         if [ -f $to_dir/$ddmmyyyy/$name ]
         then
             mv $to_dir/$ddmmyyyy/$name $to_dir/$ddmmyyyy/dummy
             cp $i $to_dir/$ddmmyyyy
             new_name=`echo $name | sed 's/\.[^.].*$//'`
             mv $to_dir/$ddmmyyyy/$name $to_dir/$ddmmyyyy/$new_name"_"$ddmmyyyy"."$ext
             mv $to_dir/$ddmmyyyy/dummy $to_dir/$ddmmyyyy/$name
             if [ ! -f "$to_dir/$ddmmyyyy/$new_name"_"$ddmmyyyy"."$ext" ]
             then
                 echo "t0rvalds : the file $name already exists, copying as $new_name"_"$ddmmyyyy"."$ext"
             fi
         else
         echo "t0rvalds : copying $name to folder $ddmmyyyy"
         cp $i $to_dir/$ddmmyyyy
         fi
         let "transfers_made=transfers_made+1"
         echo $i >> .files_moved
     else
         echo "t0rvalds : making directory ext_$ext"
         mkdir $to_dir/$ddmmyyyy
         let "folders_made=folders_made+1"
         echo "t0rvalds : copying $name to folder $ddmmyyyy"
         cp $i $to_dir/$ddmmyyyy
         let "transfers_made=transfers_made+1"
         echo $i >> .files_moved
     fi
     echo $to_dir/$ddmmyyyy >> .folder_list
 done
 fi
 #######################################################################################################################|



#log generation
echo -e "-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^"
echo "|                              The Log                               |"
echo "-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^"
echo "Total New Folders Made : $folders_made"
echo "Total Moves : $transfers_made"
for i in `cat .folder_list 2>/dev/null | sort |uniq`;
do
    folder_name=`echo $i | awk 'BEGIN{FS="/"} {print $NF}'`
    echo "The folder $folder_name has `ls $i | wc -l` files."
done
##################################################################################|

 echo -e "\nhandling exit : "
if [ $del_flag = 1 ]
then
    echo '-d : deleting organized files'
fi
#-d option handler
if [ $del_flag = 1 ]
then
    for i in `cat .files_moved 2>/dev/null` ;
    do
        echo "removing file $i..."
        rm $i
    done
fi
##################################################################################|

#deletingTemporaries
echo "deleting temporary files..."
if [ -f .folder_list ] ;
then
    rm .folder_list
fi

if [ -f .files_moved ] ;
then
    rm .files_moved
fi
##################################################################################|


#bye
echo "-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^"
echo "|                                Bye!                                |"
echo "-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^-^"
##################################################################################|
