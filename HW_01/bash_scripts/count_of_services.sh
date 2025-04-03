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
# STARTED/STOPPED SERVICES ###################################
svc_started=0
svc_stopped=0

while IFS= read line; do
        if [[ $line == *"Finished Install"* ]]; then
                ((svc_started++))
        elif [[ $line == *"Finished Remove"* ]]; then
                ((svc_stopped++))
        fi
done < $main_file

lineFunc

echo "- Finished service(-s): $svc_stopped"
echo "- Started service(-s): $svc_started"
######################################################
