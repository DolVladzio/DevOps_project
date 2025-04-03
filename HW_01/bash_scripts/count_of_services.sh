#!/bin/bash
######################################################
main_file="../file_for_analyze"
svc_file="services_file.txt"
svc_count=0

lineFunc() {
        echo "-----------------------------"
}
# Getting all services
grep "'name' =>" $main_file | sed -E "s/.*'name' => '([^']+)'.*/\1/" | sort -u > $svc_file
# Counting all svc
while IFS= read line; do
        ((svc_count++))
done < $svc_file

echo "- Was found: $svc_count service(-s)"

lineFunc

cat $svc_file

lineFunc
# STARTED SERVICES ###################################

# STOPPED SERVICES ###################################
echo "- Stopped service(-s)"

grep -iE "false" $main_file

lineFunc
######################################################
