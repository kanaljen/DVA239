# Read name of new group
read -p "Enter name of new group: " GROUP

# If name exist ask again
while [ $(getent group $GROUP) ]; do
	read -p "Group already exist, enter new name: " GROUP
done

# Create the new group
sudo groupadd $GROUP

# Read name of new user
read -p "Enter name of new user: " USER

# If name exist ask again
while [ $(getent passwd $USER) ]; do
	read -p "User already exist, enter new name: " USER
done

# Create user and add to group
sudo useradd -g $GROUP $USER

# Set a password for the user
sudo passwd $USER

# Create the user dir
sudo mkdir /$USER

# Set user and group ass owner
sudo chown $USER:$GROUP /$USER

# Set permissions, including stickybit
sudo chmod 1770 /$USER
