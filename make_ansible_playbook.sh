#!/bin/bash

function create_role() {
    read -rp "enter role name: " role
    if [ "$role" = "" ]; then
        echo "you have to specify role name"
        exit 1
    fi

    declare -a dirs=("defaults" "files" "handlers" "tasks" "templates" "vars" "meta")
    for dir in "${dirs[@]}"; do
        mkdir -p "$NAME"/roles/"$role"/$dir
    done
    cat >>"$NAME"/site.yml <<EOF
    - role: $role
      tags:
        - $role
EOF
    touch "$NAME"/roles/"$role"/README.md
    echo "[+] role created"
}

function create_playbook() {
    declare -a dirs=("group_vars" "host_vars" "roles")

    hosts_file="hosts"
    readme_file="README.md"

    for dir in "${dirs[@]}"; do
        mkdir -p "$NAME"/$dir
    done
    cat >"$NAME"/site.yml <<EOF
- name: "**INSERT PLAYBOOK NAME HERE"
  hosts: <host group name>
  become: true
  roles:
    - role1
    - role2

EOF
    #creating empty host file
    touch "$NAME"/"$hosts_file"

    #creating default README file:
    cat >"$NAME"/"$readme_file" <<EOF
\`\`\`bash
$ # run playbook
$ ansible-playbook -i hosts -K site.yml
\`\`\`
EOF
    echo "[+] playbook created"
}

function usage() {
    echo "./make_ansible_playbook.sh [playbook_name]"
}

NAME=$1
if [ "$NAME" = "" ] || [ -d "$NAME" ]; then
    echo "you didnt specify playbook name or $NAME playbook exists"
    usage
    exit 1
fi

create_playbook "$NAME"

if [ $? -ne 0 ]; then
    echo "something went wrong.. aborting"
    exit 1
fi

read -rp "Create roles? [y/N] " roles
while [ "${roles,,}" = "y" ]; do
    create_role
    read -rp "Create roles? [y/N] " roles
done

echo "[+] Playbook created"

tree="$(type -p tree)"
if [ ! "$tree" = "" ]; then
    tree "$NAME"
fi
