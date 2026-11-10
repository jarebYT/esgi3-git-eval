#!/bin/bash
# ==============================================================================
# Script : script_monitoring.sh
# Rôle   : Surveillance système (CPU, Mémoire RAM, Espace Disque)
# Usage  : ./script_monitoring.sh
# Auteur : Étudiant 1
# ==============================================================================

echo "=================================================="
echo "         RAPPORT DE SURVEILLANCE SYSTÈME          "
echo "=================================================="
echo "Date et heure : $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 1. Charge CPU / Processus
# LC_ALL=C : garantit le libellé "load average:" utilisé comme séparateur
echo "--- [1/3] UTILISATION DU PROCESSEUR (CPU) ---"
echo "Charge moyenne (1, 5, 15 min) :"
LC_ALL=C uptime | awk -F'load average:' '{ print $2 }'
echo ""

# 2. Utilisation de la mémoire RAM
echo "--- [2/3] UTILISATION DE LA MÉMOIRE RAM ---"
free -h
echo ""

# 3. Utilisation de l'espace disque
# On exclut les systèmes de fichiers virtuels (tmpfs) et on ne garde que
# l'en-tête et les vrais périphériques (lignes commençant par /)
echo "--- [3/3] UTILISATION DES DISQUES ---"
df -h --exclude-type=tmpfs --exclude-type=devtmpfs | awk 'NR==1 || /^\// {print}'
echo ""

echo "=================================================="
