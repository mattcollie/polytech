#!/bin/bash

declare DEFAULT_PASSWORD="123"
declare EXPIREY_DATE="2017-11-30"
declare -i INACTIVE_DAYS=3

# create shorthand username
function format_username {
    fullname=($@)
    echo "${fullname[0]}${fullname[1]:0:1}"
}

# deletes user
function delete_user {
    user="${@}"
    user_name="$(format_username ${user})"
    if id "${user_name}" >/dev/null 2>&1 ; then
        echo "[DELETING] user: ${user}"
        userdel "${user_name}"
    else
        echo "[ERROR] user: ${user}, does not exist"
    fi
}

# adds user
function add_user {
    user="${@}"
    user_name="$(format_username ${user})"
    if id "${user_name}" >/dev/null 2>&1 ; then
        echo "[EXISTS] user: ${user}"        
    else
        echo "[ADDING] user: ${user}"
        useradd "${user_name}"
    fi
}

# sets user password
function set_password {
    user="${@}"
    user_name="$(format_username ${user})"
    if id "${user_name}" >/dev/null 2>&1 ; then
        echo "[PASSWORD] user: ${user}"
        usermod "${user_name}" -p "${DEFAULT_PASSWORD}"
    else
        echo "[ERROR] user: ${user}, does not exist"
    fi
}

# unblocks user
function unblock_user {
    user="${@}"
    user_name="$(format_username ${user})"
    if id "${user_name}" >/dev/null 2>&1 ; then
        echo "[UNBLOCK] user: ${user}"
        passwd "${user_name}" -u
    else
        echo "[ERROR] user: ${user}, does not exist"
    fi
}

# sets expirey conditions of users
function set_expirey {
    user="${@}"
    user_name="$(format_username ${user})"
    if id "${user_name}" >/dev/null 2>&1 ; then
        echo "[EXPIRE] user: ${user}"
         usermod "${user_name}" -e "${EXPIREY_DATE}"
    else
        echo "[ERROR] user: ${user}, does not exist"
    fi
}

# sets inactive conditions of users
function set_inactive {
    user="${@}"
    user_name="$(format_username ${user})"
    if id "${user_name}" >/dev/null 2>&1 ; then
        echo "[INACTIVE] user: ${user}"
         usermod "${user_name}" -f "${INACTIVE_DAYS}"
    else
        echo "[ERROR] user: ${user}, does not exist"
    fi
}

function main {
    declare -a users_to_add=( "carol smith" "david clive" "fred blue" "frank bart" "helen bloggs" "betty cross" )
    declare -a users_to_unlock=( "helen bloggs" "fred blue" "betty cross" )
    declare -a users_to_expire=( "carol smith" "david clive" "fred blue" "frank bart" )
    
    # adds users and sets passwords
    for user in "${users_to_add[@]}"
    do
        # delete_user "${user}"
        add_user "${user}"
        set_password "${user}"
        if [[ ! " ${users_to_unlock[@]} " =~ " ${user} " ]]; then
            unblock_user "${user}"
        fi
        
        if [[ ! " ${users_to_expire[@]} " =~ " ${user} " ]]; then
            set_expirey "${user}"
            set_inactive "${user}"
        fi
    done
}
main