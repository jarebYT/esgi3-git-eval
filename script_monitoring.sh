#!/bin/bash
# ==============================================================================
# Script : surveillance.sh
# Rôle   : Surveillance système (CPU, Mémoire RAM, Espace Disque) - Fonctionnalité A[cite: 1]
# Auteur : Étudiant 1[cite: 1]
# ==============================================================================

echo "=================================================="
echo "          RAPPORT DE SURVEILLANCE SYSTÈME        "
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

# 3. Utilisation de l'espace disque (ANOMALIE VOLONTAIRE POUR L'ÉTAPE 8)
echo "--- [3/3] UTILISATION DES DISQUES ---"
# ERREUR : Affichage brut en octets sans unités (B1) et mauvaise colonne extraite
df -h -T --exclude-type=tmpfs --exclude-type=devtmpfs
echo ""

echo "=================================================="
