# Challenge Lab A: User Management

# Create three directories with mkdir, sudo is needed because we write in /
sudo mkdir /engineering /sales /is

# Create three groups for the department
sudo groupadd engineering
sudo groupadd sales
sudo groupadd is

# Add three admin users, and set primary groups accordingly
sudo useradd -g engineering en_admin
sudo useradd -g sales sa_admin
sudo useradd -g is is_admin

# Change user and group owner of department directories
sudo chown en_admin:engineering /engineering
sudo chown sa_admin:sales /sales
sudo chown is_admin:is /is

# Change file directory permissions, set sticky bit for the directories
sudo chmod 1770 /engineering /sales /is

# Add two users per department
sudo useradd -g engineering en_user1
sudo useradd -g engineering en_user2
sudo useradd -g sales sa_user1
sudo useradd -g sales sa_user2
sudo useradd -g is is_user1
sudo useradd -g is is_user2

# Create 'confidential information' files
sudo touch /engineering/file /sales/file /is/file

# Set owner on files
sudo chown en_admin:engineering /engineering/file
sudo chown sa_admin:sales /sales/file
sudo chown is_admin:is /is/file

# Write to file
echo 'This file contains confidential information for the department.' | sudo tee /engineering/file /sales/file /is/file
