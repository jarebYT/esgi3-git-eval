IDENTIFICATION OBLIGATOIRE : indiquez explicitement la correspondance entre le nom, le prénom et le
pseudonyme GitHub de chaque membre :

BERNARD Luca lxquaver Étudiant B
VANNEUVILLE Alexandre jarebYT Étudiant C
MONET--PRINGUER Mathis Mathismwat Étudiant A 

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




    ## Questions de synthèse :
   1/ (Luca) On sépare développement en cours et version stable pour isoler l'environnement de production des modifications en cours de construction, instables ou non validées et pour garantir la continuité de service pour les utilisateurs finaux pendant que de nouvelles fonctionnalités sont développées en parallèle.
   2/ (Alexandre) On impose une revue de code avant intégration pour détecter les bugs, failles de sécurité et erreurs de logiques ainsi que pour assurer le respect des normes de codage et favoriser le partage des compétences au sein de l'équipe.
   3/ (Mathis) Les situations provoquant un conflit sont principalement des modification simultanées des mêmes lignes d'un fichier sur deux branches fusionnées. Cela arrive car Git ne peut pas déterminer quelle modification doit primer.
   4/ (Luca) Les différences entre correction classique et urgente sont les suivantes : la correction classique est intégrée dans le cycle de développement standard, testée et planifiée pour la prochaine livraison tandis que la correction urgente (hotfix) est déployée immédiatement en production pour résoudre une panne critique, puis rétro-propagée.
   5/ (Alexandre) On rétro-propage la correction pour empêcher la réapparition du même bug dans les versions futures. Cela assure la synchronisation entre la base de code active et l'état actuel de la production.
   6/ (Mathis) La branche de release sert à isoler la version candidate à la livraison pour phase de stabilisation finale (tests de recette, correction des derniers bugs mineurs) et permet de poursuivre les nouveaux développements pour la version suivante sans bloquer le processus de publication.
   7/ (Luca) Github Project et les Issues facilitent organisation et tracabilité car les issues centralisent et documentent chaque tâche, bug ou évolution de manière traçable tandis que les tableaux Kanban (Projects) matérialisent visuellement l'avancement des flux de travail et l'état d'avancement des livrables.
   8/ (Alexandre) Pour retrouver l'origine d'une modification dans l'historique GitHub on utilise Git blame ou l'interface web pour identifier l'auteur de la modification et ce qu'il a modifié, on peut également utiliser Git Log pour retracer l'historique des commits et les liens croisés vers les Pull Requests
