#!/bin/sh

#   Copyright 2021 InfAI (CC SES)
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


# Environment variables:
#
# $DEP_INSTANCE
# $JOB_CALLBACK_URL
# $input_archive
# $archive_extension
# $named_outputs


extract_dir="$(cat /proc/sys/kernel/random/uuid | echo $(read s; echo ${s//-}))"
output_file="$(cat /proc/sys/kernel/random/uuid | echo $(read s; echo ${s//-}))"
data_cache="/data_cache"


function handle_files() {
    count=0
    if [ -z "${named_outputs+x}" ]; then
        output_files=""
        for item in "$extract_dir/"*; do
            if [ -f "$item" ]; then
                let count=count+1
                mv "$item" "${output_file}_${count}"
                echo "${item##*/} -> ${output_file}_${count}"
                head -5 "${output_file}_${count}"
                echo "total number of lines: "$(wc -l < "${output_file}_${count}")
                output_files="$output_files{\"output_file\":\"${output_file}_${count}\"},"
            else
                echo "${item##*/} not a file"
            fi
        done
        output_files="${output_files::-1}"
    else
        output_files="{"
        IFS=";"
        for item in $named_outputs; do
            file=$(ls "$extract_dir" | grep "$item")
            if [ -f "$extract_dir/$file" ]; then
                let count=count+1
                mv "$extract_dir/$file" "${output_file}_${count}"
                echo "$file -> ${output_file}_${count}"
                head -5 "${output_file}_${count}"
                echo "total number of lines: "$(wc -l < "${output_file}_${count}")
                output_files="$output_files\"${item}\":\"${output_file}_${count}\","
            else
                echo "'$item' no file"
            fi
        done
        output_files="${output_files::-1}}"
    fi
    if [ "$count" -gt 0 ]; then
        if ! curl -s -S --header 'Content-Type: application/json' --data "{\"${DEP_INSTANCE}\": [${output_files}]}" -X POST "$JOB_CALLBACK_URL"; then
            echo "callback failed"
            for i in `seq 1 $count`; do
                rm "${output_file}_${i}"
            done
        fi
    fi
}


echo "extracting files ..."
cd "$data_cache"
case "$archive_extension" in
    "."*)
        archive_file="$input_archive$archive_extension"
        mv "$input_archive" "$archive_file"
        ;;
    *)
        archive_file="$input_archive.$archive_extension"
        mv "$input_archive" "$archive_file"
esac
mkdir "$extract_dir"
case "$archive_extension" in
    *"tar"*)
        if tar -xf  "$archive_file" -C "$extract_dir"; then
            handle_files
        else
            echo "extracting files failed"
        fi
        ;;
    *"zip"*)
        if unzip -q "$archive_file" -d "$extract_dir"; then
            handle_files
        else
            echo "extracting files failed"
        fi
        ;;
    *)
        echo "archive '$archive_extension' not supported"
esac


if [ -f "$archive_file" ]; then
    rm "$archive_file"
fi
if [ -d "$extract_dir" ]; then
    rm -r "$extract_dir"
fi
