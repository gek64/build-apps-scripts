#!/bin/bash

tag=""

function get_tag(){
    tag=$(git describe --tags)
}

function del_tag(){
    if [[ $tag != *"fatal"* ]]; then
        git push --delete origin $tag
    else
        echo -e "\033[31m无tag信息\033[0m"
    fi
}

get_tag
del_tag