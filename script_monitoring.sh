#!/bin/bash
# ==============================================================================
# Script : surveillance.sh
# Rôle   : Surveillance système (CPU, Mémoire RAM, Espace Disque)
# Auteur : Étudiant 1
# ==============================================================================

echo "=================================================="
echo "         RAPPORT DE SURVEILLANCE SYSTÈME          "
echo "=================================================="
echo "Date et heure : $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 1. Charge CPU / Processus
echo "--- [1/3] UTILISATION DU PROCESSEUR (CPU) ---"
echo "Charge moyenne (1, 5, 15 min) :"
uptime | awk -F'load average:' '{ print $2 }'
echo ""

# 2. Utilisation de la mémoire RAM
echo "--- [2/3] UTILISATION DE LA MÉMOIRE RAM ---"
free -h
echo ""

# 3. Utilisation de l'espace disque (Correction du bug d'extraction)
echo "--- [3/3] UTILISATION DES DISQUES ---"
df -h --exclude-type=tmpfs --exclude-type=devtmpfs | awk 'NR==1 || /^\// {print}'
echo ""

echo "=================================================="