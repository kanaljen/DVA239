# ^[^#] not beginning with a commant
# *$ whole line to end of string
# cut -f 1 cut first field
# sort -u sort and remove duplicates
# > ~/uniqueservices.txt write to file
grep -o ^[^#]*$ /etc/services | cut -f 1 | sort -u > ~/uniqueservices.txt
# count lines in file, aka number of unique services
wc -l < ~/uniqueservices.txt
