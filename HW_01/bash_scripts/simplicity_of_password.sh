#!/bin/bash
####################################################################
main_file="../file_for_analyze"
admin_file="admin_passwords.txt"
db_file="db_passwords.txt"

lineFunc() {
        echo "-----------------------------"
}
passInfo() {
        echo "- $1 passwords statistics"
	echo ""
}
# ADMIN PASSWORDS ##################################################
lineFunc
# Getting pass and delete everything useless
grep "name=\"admin_pass\"" $main_file | sed -E 's/.*value="([^"]+)".*/\1/' | sort -u > $admin_file

passInfo "Admin"

# Checking pass
while IFS= read -r line; do
        echo $line | cracklib-check
done < $admin_file

lineFunc
# DB PASSWORDS #####################################################
# Getting pass and delete everything useless
grep "softdbpass" $main_file | sed -E "s/.*'softdbpass' => '([^']+)'.*/\1/" | sort -u > $db_file

passInfo "DB"

# Checking pass
while IFS= read -r line; do
        echo $line | cracklib-check
done < $db_file

lineFunc
####################################################################
