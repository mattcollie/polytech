#!/bin/bash

declare DEFAULT_PASSWORD="123"
declare EXPIREY_DATE="2017-11-30"
declare -i INACTIVE_DAYS=3

# create shorthand username
function _format_username {
    fullname=($@)
    echo "${fullname[0]}${fullname[1]:0:1}"
}

# deletes user
function _delete_user {
    user="${@}"
    user_name="$(_format_username ${user})"
    if id "${user_name}" >/dev/null 2>&1 ; then
        echo "[DELETING] user: ${user}"
        userdel "${user_name}"
    else
        echo "[ERROR] user: ${user}, does not exist"
    fi
}

# adds user
function _add_user {
    user="${@}"
    user_name="$(_format_username ${user})"
    if id "${user_name}" >/dev/null 2>&1 ; then
        echo "[EXISTS] user: ${user}"        
    else
        echo "[ADDING] user: ${user}"
        useradd "${user_name}"
    fi
}

# sets user password
function _set_password {
    user="${@}"
    user_name="$(_format_username ${user})"
    if id "${user_name}" >/dev/null 2>&1 ; then
        echo "[PASSWORD] user: ${user}"
        usermod "${user_name}" -p "${DEFAULT_PASSWORD}"
    else
        echo "[ERROR] user: ${user}, does not exist"
    fi
}

# unblocks user
function _unblock_user {
    user="${@}"
    user_name="$(_format_username ${user})"
    if id "${user_name}" >/dev/null 2>&1 ; then
        echo "[UNBLOCK] user: ${user}"
        passwd "${user_name}" -u
    else
        echo "[ERROR] user: ${user}, does not exist"
    fi
}

# sets expirey conditions of users
function _set_expirey {
    user="${@}"
    user_name="$(_format_username ${user})"
    if id "${user_name}" >/dev/null 2>&1 ; then
        echo "[EXPIRE] user: ${user}"
         usermod "${user_name}" -e "${EXPIREY_DATE}"
    else
        echo "[ERROR] user: ${user}, does not exist"
    fi
}

# sets inactive conditions of users
function _set_inactive {
    user="${@}"
    user_name="$(_format_username ${user})"
    if id "${user_name}" >/dev/null 2>&1 ; then
        echo "[INACTIVE] user: ${user}"
         usermod "${user_name}" -f "${INACTIVE_DAYS}"
    else
        echo "[ERROR] user: ${user}, does not exist"
    fi
}

# main function
function main {
    declare -a users_to_add=( "carol smith" "david clive" "fred blue" "frank bart" "helen bloggs" "betty cross" )
    declare -a users_to_unlock=( "helen bloggs" "fred blue" "betty cross" )
    declare -a users_to_expire=( "carol smith" "david clive" "fred blue" "frank bart" )
    
    for user in "${users_to_add[@]}"
    do
        # _delete_user "${user}"
        _add_user "${user}"
        _set_password "${user}"
        if [[ ! " ${users_to_unlock[@]} " =~ " ${user} " ]]; then
            _unblock_user "${user}"
        fi
        
        if [[ ! " ${users_to_expire[@]} " =~ " ${user} " ]]; then
            _set_expirey "${user}"
            _set_inactive "${user}"
        fi
    done
}
main