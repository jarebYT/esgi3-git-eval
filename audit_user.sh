#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Erreur : Ce script doit être exécuté avec les privilèges root." >&2
    exit 1
fi

printf "%-15s | %-6s | %-25s | %-30s | %-20s\n" "UTILISATEUR" "UID" "DERNIÈRE CONNEXION" "EXPIRATION MOT DE PASSE" "SHELL"
printf "%s\n" "------------------------------------------------------------------------------------------------------------------------"

awk -F: '($3 >= 1000 && $3 < 65535) || $3 == 0 {print $1}' /etc/passwd | while read -r user; do
    uid=$(id -u "$user")
    shell=$(getent passwd "$user" | cut -d: -f7)
    
    last_conn=$(lastlog -u "$user" 2>/dev/null | tail -n 1)
    if echo "$last_conn" | grep -q "Never"; then
        last_login="Jamais"
    else
        last_login=$(echo "$last_conn" | awk '{print $2, $3, $4, $5}')
        [ -z "$last_login" ] && last_login="Inconnu"
    fi
    
    exp_date=$(chage -l "$user" 2>/dev/null | grep "Password expires" | cut -d: -f2 | xargs)
    [ -z "$exp_date" ] && exp_date="Indéfini"

    printf "%-15s | %-6s | %-25s | %-30s | %-20s\n" "$user" "$uid" "$last_login" "$exp_date" "$shell"
done
