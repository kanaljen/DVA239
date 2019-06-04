#!/bin/bash
printItem() {
	for ((i = 0 ; i < $2-1 ; i++)); do
  		echo -n "$1"
	done
	echo "$1"
}

printCentered(){
	WHITESPACE=`expr $2 - ${#1}`
	WHITESPACE=`expr $WHITESPACE / 2`
	for ((i = 0 ; i < $WHITESPACE ; i++)); do
  		echo -n " "
	done
	printf "\033[1m\033[33m%s" $1
	printf "\033[0m \n"
}

printTitle(){
	printItem '*' $WIDTH
	printCentered 'SYSTEM MODIFIER (version 1.0.0)' $WIDTH
	printItem '-' $WIDTH
}

printMenu() {
	clear
	WIDTH=$1
	printTitle
	# GROUPS
	printf "\033[31m%-20s \033[0m%s\n" "group:add" "Create a new group"
	printf "\033[31m%-20s \033[0m%s\n" "group:list" "List system groups"
	printf "\033[31m%-20s \033[0m%s\n" "group:view" "List user associations for your group"
	printf "\033[31m%-20s \033[0m%s\n" "group:modify" "Modify user associations for group"
	# USERS
	printf "\033[31m%-20s \033[0m%s\n" "user:add" "Create a new user"
	printf "\033[31m%-20s \033[0m%s\n" "user:list" "List system users"
	printf "\033[31m%-20s \033[0m%s\n" "user:view" "View user properties"
	printf "\033[31m%-20s \033[0m%s\n" "user:modify" "Modify user properties"
	# FOLDERS
	printf "\033[31m%-20s \033[0m%s\n" "folder:add" "Create a new folder"
	printf "\033[31m%-20s \033[0m%s\n" "folder:list" "List folder contents"
	printf "\033[31m%-20s \033[0m%s\n" "folder:view" "View folder properties"
	printf "\033[31m%-20s \033[0m%s\n" "folder:modify" "Modify folder properties"
	# REMOTE
	printf "\033[31m%-20s \033[0m%s\n" "remote:install" "Install the package openssh-server"
	printf "\033[31m%-20s \033[0m%s\n" "remote:uninstall" "Uninstall the package openssh-server"
	printf "\033[31m%-20s \033[0m%s\n" "remote:enable" "Enable remote access with SSH"
	printf "\033[31m%-20s \033[0m%s\n" "remote:disable" "Disable remote access with SSH"
	printItem '-' $WIDTH
}

modifyFolder() {
	clear
	printTitle
	echo "What to modify in $NAME?"
	options=("Change owner" "Change permissions" "Set sticky bit" "setgid" "Change last modified")
	select opt in "${options[@]}"
	do
    	case $opt in
        	"Change owner")
				echo -n 'new owner > '
				read USER
				sudo chown -R $USER $NAME
				break
            	;;
        	"Change permissions")
				echo -n 'new permissions > '
				read PERMIS
				sudo chmod -R $PERMIS $NAME
				break
            	;;
        	"Set sticky bit")
				sudo chmod +t $NAME
				break
            	;;
        	"setgid")
				sudo chmod g+s $NAME
				break
            	;; 
        	"Change last modified")
				echo -n 'new permissions (ex. YYYYMMHHmm.ss) > '
				read TIME
				touch -t $TIME $NAME
				break
            	;;
        	*)
				echo "invalid option"
            	break
            	;;
    	esac
	done
	printItem '-' $WIDTH
}

viewFolder() {
	clear
	printTitle
	echo -e "folder:view for $NAME\n"
	printf "\033[31m%-15s \033[0m%s\n" "Name" $(ls -lad */ | grep $NAME | awk '{print $9}')
	printf "\033[31m%-15s \033[0m%s\n" "Owner" $(ls -lad */ | grep $NAME | awk '{print $3}')
	printf "\033[31m%-15s \033[0m%s\n" "Group" $(ls -lad */ | grep $NAME | awk '{print $4}')
	printf "\033[31m%-15s \033[0m%s\n" "Permisions" $(ls -lad */ | grep $NAME | awk '{print $1}')
	printItem '-' $WIDTH
}

modifyUser() {
	clear
	printTitle
	echo "What to modify for $NAME?"
	options=("Change name" "Change password" "Change primary group" "Change home folder" "Change shell")
	select opt in "${options[@]}"
	do
    	case $opt in
        	"Change name")
				echo -n 'new name > '
				read NEWNAME
				sudo usermod -l $NEWNAME $NAME
				break
            	;;
        	"Change password")
				sudo passwd $NAME
				break
            	;;
        	"Change primary group")
				echo -n 'new primary group > '
				read NEWGROUP
				sudo usermod -g $NEWGROUP $NAME
				break
            	;;
        	"Change home folder")
				echo -n 'new home directory (full path) > '
				read NEWHOME
				sudo usermod -d $NEWHOME $NAME
				break
            	;;
        	"Change shell")
				echo -n 'new shell (full path) > '
				read SHELL
				sudo usermod --shell $SHELL $NAME
				break
            	;;
        	*)
				echo "invalid option"
            	break
            	;;
    	esac
	done
	printItem '-' $WIDTH
}

viewUser() {
	clear
	printTitle
	echo -e "user:view for $NAME\n"
	printf "\033[31m%-15s \033[0m%s\n" "Username" $(grep $NAME /etc/passwd | awk -F':' '{print $1}')
	printf "\033[31m%-15s \033[0m%s\n" "Password" $(grep $NAME /etc/passwd | awk -F':' '{print $2}')
	printf "\033[31m%-15s \033[0m%s\n" "User ID" $(grep $NAME /etc/passwd | awk -F':' '{print $3}')
	printf "\033[31m%-15s \033[0m%s\n" "Group ID" $(grep $NAME /etc/passwd | awk -F':' '{print $4}')
	printf "\033[31m%-15s \033[0m%s\n" "Directory" $(grep $NAME /etc/passwd | awk -F':' '{print $6}')
	printf "\033[31m%-15s \033[0m%s\n" "Shell" $(grep $NAME /etc/passwd | awk -F':' '{print $7}')
	printItem '-' $WIDTH
}

groupTools() {
	clear
	printTitle
	if [[ $INPUT == *"add"* ]]; then
		echo -e 'group:add\n' # recognize backslash
		echo -n 'name of new group > ' # no new line
		read NAME
		sudo groupadd "$NAME"
	elif [[ $INPUT == *"list"* ]]; then
		echo -e 'group:list\n'
		echo -e 'All groups in the system:\n'
		cat /etc/group | awk -F':' '{print $1}' | sort | tr '\n' ','
	elif [[ $INPUT == *"view"* ]]; then
		echo -e 'group:view\n'
		echo -n 'group to view > '
		read NAME
		echo -e "\nusers associated with $NAME:"
		grep "$NAME" /etc/group | cut -d: -f4 | tr '\n' ','
	elif [[ $INPUT == *"modify"* ]]; then
		echo -e 'group:modify\n'
		echo -n 'group to modify > '
		read GROUP
		options=("Add user" "Remove user")
		select opt in "${options[@]}"
		do
    		case $opt in
        		"Add user")
					echo -n 'user to add > '
					read USER
            		sudo gpasswd -a "$USER" "$GROUP"
					break
            		;;
        		"Remove user")
					echo -n 'user to remove > '
					read USER
            		sudo gpasswd -d "$USER" "$GROUP"
					break
            		;;
        		*)
					echo "invalid option"
            		break
            		;;
    		esac
		done
	else
		echo 'group command not recoginized' 
	fi
}

userTools() {
	clear
	printTitle
	if [[ $INPUT == *"add"* ]]; then
		echo -e 'user:add\n' # recognize backslash
		echo -n 'new username > '
		read NAME
		sudo useradd $NAME
	elif [[ $INPUT == *"list"* ]]; then
		echo -e 'user:list\n'
		echo -e 'All users in the system:\n'
		cut -d: -f1 /etc/group | sort | tr '\n' ','
	elif [[ $INPUT == *"view"* ]]; then
		echo -e 'user:view\n'
		echo -n 'user to view > '
		read NAME
		viewUser
	elif [[ $INPUT == *"modify"* ]]; then
		echo -e 'user:modify\n'
		echo -n 'user to modify > ' 
		read NAME
		modifyUser
	else
		echo 'user command not recoginized' 
	fi
}

folderTools() {
	clear
	printTitle
	if [[ $INPUT == *"add"* ]]; then
		echo -e 'folder:add\n'
		echo -n 'name of new folder > '
		read NAME
		sudo mkdir "$NAME"
	elif [[ $INPUT == *"list"* ]]; then
		echo -e 'folder:list\n'
		printf 'contnent of %s:\n\n' $(pwd)
		ls ./
	elif [[ $INPUT == *"view"* ]]; then
		echo -e 'folder:view\n'
		echo -n 'folder to view > ' 
		read NAME
		viewFolder
	elif [[ $INPUT == *"modify"* ]]; then
		echo -e 'folder:modify\n'
		echo -n 'folder to modify > ' 
		read NAME
		modifyFolder
	else
		echo 'folder command not recoginized' 
	fi
}

remoteAccess() {
	clear
	printTitle
	if [[ $INPUT == *"uninstall"* ]]; then
		echo -e 'remote:uninstall\n'
		sudo apt remove openssh-client
	elif [[ $INPUT == *"install"* ]]; then
		echo -e 'remote:install\n'
		sudo apt update
		sudo apt install openssh-client
	elif [[ $INPUT == *"enable"* ]]; then
		echo -e 'remote:enable\n'
		sudo apt update
		sudo apt install openssh-server
	elif [[ $INPUT == *"disable"* ]]; then
		echo -e 'remote:disable\n'
		sudo apt remove openssh-server
	else
		echo 'folder command not recoginized' 
	fi
}

# MAIN FOREVER LOOP
while true; do
	clear
	printMenu 60
	echo -n 'Select choice > '
	read INPUT
	if [[ $INPUT == *"group"* ]]; then
		groupTools $INPUT
	elif [[ $INPUT == *"user"* ]]; then
		userTools $INPUT
	elif [[ $INPUT == *"folder"* ]]; then
		folderTools $INPUT
	elif [[ $INPUT == *"remote"* ]]; then
		remoteAccess $INPUT
	else
		echo 'command not recoginized'
	fi
	printf '\n\npress RETURN to continue'
	read GETCHAR
done
