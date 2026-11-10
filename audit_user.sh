#!/bin/bash
# ==============================================================================
# Script : audit_user.sh
# Rôle   : Audit des comptes utilisateurs (UID, dernière connexion,
#          expiration du mot de passe, shell). Le rapport est affiché et
#          ajouté au journal $LOGFILE.
# Usage  : sudo ./audit_user.sh
# ==============================================================================

# lastlog et chage lisent des fichiers réservés à root
if [ "$EUID" -ne 0 ]; then
    echo "Erreur : Ce script doit être exécuté avec les privilèges root." >&2
    exit 1
fi

# Fichier de journalisation (sortie ajoutée à la suite à chaque exécution)
LOGFILE="/var/log/audit_users.log"

# Force la langue anglaise pour que les motifs "Never" / "Password expires"
# soient trouvés quelle que soit la langue du système
export LC_ALL=C

{
printf "========================================================================================================================\n"
printf "%-15s | %-6s | %-25s | %-30s | %-20s\n" "COMPTE USER" "UID" "DERNIERE CONNEXION" "EXPIRATION MDP" "SHELL APPLICATIF"
printf "========================================================================================================================\n"

# Comptes humains (UID 1000 à 65534) + root (UID 0)
awk -F: '($3 >= 1000 && $3 < 65535) || $3 == 0 {print $1}' /etc/passwd | while read -r user; do
    uid=$(id -u "$user")
    shell=$(getent passwd "$user" | cut -d: -f7)

    last_conn=$(lastlog -u "$user" 2>/dev/null | tail -n 1)
    if echo "$last_conn" | grep -q "Never"; then
        last_login="Jamais"
    else
        # La date occupe les 6 derniers champs (ex : Mon Nov 10 18:00:00 +0100 2026).
        # On les lit depuis la fin car les colonnes Port/From peuvent être vides.
        last_login=$(echo "$last_conn" | awk 'NF >= 6 {print $(NF-4), $(NF-3), $(NF-2), $NF}')
        [ -z "$last_login" ] && last_login="Inconnu"
    fi

    exp_date=$(chage -l "$user" 2>/dev/null | grep "Password expires" | cut -d: -f2 | xargs)
    [ -z "$exp_date" ] && exp_date="Indéfini"

    printf "[USER] %-8s | %-6s | %-25s | %-30s | %-20s\n" "$user" "$uid" "$last_login" "$exp_date" "$shell"
done
} | tee -a "$LOGFILE"
