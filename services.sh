#!/bin/bash
set -euo pipefail

# Script de vérification des services réseau / système
# Auteur : Étudiant 3 (Services)

SERVICES=("ssh" "cron" "rsyslog")

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    echo "Usage: $0 [-h|--help]"
    echo "Vérifie l'état d'activation des services système récurrents."
    exit 0
fi

echo "=== RAPPORT D'ÉTAT DES SERVICES ==="
echo "Date : $(date '+%Y-%m-%d %H:%M:%S')"
echo "-----------------------------------"

for service in "${SERVICES[@]}"; do
    # systemctl is-active renvoie un code non nul (3) si le service est arrêté.
    # Avec 'set -e' cela stopperait le script : '|| true' neutralise ce code
    # tout en conservant l'état affiché (active, inactive, failed...).
    status=$(systemctl is-active "$service" || true)
    echo "Service [$service] : $status"
done

echo "-----------------------------------"
echo "Contrôle terminé."
