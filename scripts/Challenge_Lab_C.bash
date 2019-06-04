# Archive files from ~/files
echo "Archived files from ~/files to ~/archive/log.tar :"
tar -cvf ~/archive/log.tar -C ~/files .

# Show content of tar, pip it to grep and -o for only matching pattern. ignoring / ending with wildcard
echo "log.tar content:"
tar -tf ~/archive/log.tar | grep -o [^/]*$

# Extract file
tar -xf ~/archive/log.tar -C ~/backup
echo "Files in ~/backup: "
ls ~/backup
