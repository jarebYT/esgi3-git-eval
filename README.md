## 🔀 Gestion et Résolution de Conflit Git

Cette section documente la simulation d'un conflit de fusion (*merge conflict*) survenu lors du développement parallèle de fonctionnalités sur le script `audit_users.sh`.

### 1. Contexte du Conflit
Luca et Mathis ont travaillé simultanément sur des branches séparées issues de `develop` :
* **Branche `feature/launch_script_monitoring` (Mathis)** : Optimisation visuelle des en-têtes et du formatage de sortie de la console.
* **Branche `feature/launch-script-journaling` (Luca)** : Ajout d'une option de journalisation automatique des résultats dans `/var/log/audit_users.log` via le bloc de redirection `tee`.

Les modifications portant sur la même structure du fichier `audit_users.sh` (encapsulation du bloc d'affichage principal), Git n'a pas pu effectuer la fusion automatique.

### 2. Déclenchement de l'Erreur
Après la fusion de la branche d'affichage dans `develop`, la tentative de fusion de la branche de journalisation a généré l'erreur suivante :

Auto-merging audit_users.sh
CONFLICT (content): Merge conflict in audit_users.sh
Automatic merge failed; fix conflicts and then commit the result.

3. Procédure de Résolution

    Inspection des marqueurs de conflit dans audit_users.sh :
    Bash

    printf "========================================================================================================================\n"
    printf "%-15s | %-6s | %-25s | %-30s | %-20s\n" "COMPTE USER" "UID" "DERNIERE CONNEXION" "EXPIRATION MDP" "SHELL APPLICATIF"
    ...
    =======
    LOGFILE="/var/log/audit_users.log"
    {
    printf "%-15s | %-6s | %-25s | %-30s | %-20s\n" "UTILISATEUR" "UID" "DERNIÈRE CONNEXION" "EXPIRATION MOT DE PASSE" "SHELL"
    ...
    } | tee -a "$LOGFILE"
    

    Arbitrage et fusion manuelle :

        Conservation de la variable LOGFILE et de l'encapsulation { ... } | tee -a "$LOGFILE" issue de la branche feature/journalisation.

        Conservation des en-têtes nettoyés et du formatage de ligne [USER] issus de la branche feature/amelioration-affichage.

    Validation et finalisation :
    Bash

    git add audit_users.sh
    git commit -m "merge: resolve conflict between formatting and logging options"
