#!/bin/bash

function create_role() {
    read -rp "Enter role name: " role
    if [ -z "$role" ]; then
        echo "You have to specify role name"
        exit 1
    fi

    declare -a dirs=("defaults" "files" "handlers" "tasks" "templates" "vars" "meta")
    for dir in "${dirs[@]}"; do
        mkdir -p "$playbook_name/roles/$role/$dir" || {
            echo "Failed to create directory $dir"
            exit 1
        }
    done
    echo "- role: $role" >>"$playbook_name/site.yml"
    touch "$playbook_name/roles/$role/README.md" || {
        echo "Failed to create README.md"
        exit 1
    }
    echo "[+] Role '$role' created"
}

function create_playbook() {
    declare -a dirs=("group_vars" "host_vars" "roles")

    for dir in "${dirs[@]}"; do
        mkdir -p "$playbook_name/$dir" || {
            echo "Failed to create directory $dir"
            exit 1
        }
    done

    cat >"$playbook_name/site.yml" <<EOF
- name: "**INSERT PLAYBOOK NAME HERE"
  hosts: <host group name>
  become: true
  roles:
    - role1
    - role2
EOF

    touch "$playbook_name/hosts" || {
        echo "Failed to create hosts file"
        exit 1
    }

    cat >"$playbook_name/README.md" <<EOF
\`\`\`bash
$ # run playbook
$ ansible-playbook -i hosts -K site.yml
\`\`\`
EOF

    echo "[+] Playbook created"
}

function usage() {
    echo "./make_ansible_playbook.sh [playbook_name]"
}

playbook_name=$1
if [ -z "$playbook_name" ] || [ -d "$playbook_name" ]; then
    echo "You didn't specify playbook name or '$playbook_name' playbook already exists"
    usage
    exit 1
fi

create_playbook "$playbook_name"

read -rp "Create roles? [y/N] " roles
while [ "${roles,,}" == "y" ]; do
    create_role
    read -rp "Create roles? [y/N] " roles
done

echo "[+] Playbook created"

# Display tree if 'tree' command exists
if command -v tree &>/dev/null; then
    tree "$playbook_name"
fi
