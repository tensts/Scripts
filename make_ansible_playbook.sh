#!/bin/bash

function create_role() {
    read -p "enter role name: " role
    if [ "$role" = "" ]; then
        echo "you have to specify role name"
        exit 1
    fi

    declare -a dirs=("defaults" "handlers" "tasks" "templates" "vars" "meta")
    for dir in "${dirs[@]}"; do
        mkdir -p "$NAME"/roles/"$role"/$dir;
    done
    cat >> "$NAME"/site.yml <<EOF
    - $role
EOF
    touch "$NAME"/roles/"$role"/README.md
    echo "[+] role created"
}

function create_playbook(){
    declare -a dirs=("group_vars" "host_vars" "roles")
    declare -a files=("hosts" "README.md")

    for dir in "${dirs[@]}"; do
        mkdir -p "$NAME"/$dir;
    done
    cat > "$NAME"/site.yml <<EOF
---

- name: 
  hosts: app
  become: true
  roles:
EOF
    for f in "${files[@]}"; do
        touch "$NAME"/"$f"
    done
    echo "[+] playbook created"
}

function usage() {
    echo "./make_ansible_playbook.sh [playbook_name]"
}

function create_deploy_script(){
    cat > "$NAME"/deploy.sh <<EOF
#!/bin/bash

ansible-playbook -i hosts -K site.yml $*
EOF
    chmod u+x "$NAME"/deploy.sh
echo "[+] Deployment script created"
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

read -p "Create roles? [y/N] " roles
while [ "${roles,,}" = "y" ]; do
    create_role
    read -p "Create roles? [y/N] " roles
done

create_deploy_script
echo "[+] Playbook created"

tree="$(type -p tree)"
if [ ! $tree = "" ]; then
    tree "$NAME"
fi
