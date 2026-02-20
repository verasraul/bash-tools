#!/bin/bash

while getopts "d:t:" flag; do
    case "${flag}" in
        d)
            dir_name=${OPTARG}
            ;;
        t)
            project_title=${OPTARG}
            ;;
    esac
done

make_dir="mkdir -p $dir_name"
cd_dir="cd $dir_name"
get_files(){
    curl -O https://raw.githubusercontent.com/verasraul/vanillaJS-boilerplate/refs/heads/main/index.html
    curl -O https://raw.githubusercontent.com/verasraul/vanillaJS-boilerplate/refs/heads/main/style.css 
    curl -O https://raw.githubusercontent.com/verasraul/vanillaJS-boilerplate/refs/heads/main/script.js
}
change_perms="chmod +x index.html script.js style.css"
change_title(){
    sed -i "" "s/Boilerplate Project Files/$project_title/g" index.html
}

if [[ ! $dir_name ]]; then
    echo "You did not provide a directory name, please provide a directory name in order to proceed."
    exit 2
elif [[ $dir_name ]] && [[ ! $project_title ]]; then
    $make_dir
    $cd_dir
    get_files
    $change_perms
    # exit 0
else
    $make_dir
    $cd_dir
    get_files
    $change_perms
    change_title
fi
