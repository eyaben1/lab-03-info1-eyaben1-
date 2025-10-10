# Lab 03- Docker
> [!IMPORTANT]
> Pour chaque exercice travailler dans le repertoire qui lui correspond.
> Mettre les commandes et les captures d'écran dans un fichier Word.
> A la fin, enregistrer le fichier Word sous format PDF.

# Exercice 1 : Déploiement de Base

1. Compléter le fichier Dockerfile afin de créer une image docker contenant l'API  app.py  
2. Construire l'image Docker  
3. Exécuter le conteneur  
4. Vérifier que l'API est accessible  
5. Consulter les logs du conteneur

**Livrable :** Capture d'écran d'une réponse API réussie

# Exercice 2 : Tests de l'API

Tester toutes les opérations CRUD :

1. Lister tous les livres  
2. Ajouter 2 nouveaux livres  
3. Mettre à jour les informations d'un livre  
4. Supprimer un livre  
5. Vérifier les modifications  
6. Compléter le fichier test\_api.py

**Livrable :** Documenter chaque requête et réponse

# Exercice 3 : Gestion des Conteneurs

1. Arrêter le conteneur  
2. Le redémarrer  
3. Consulter les logs  
4. Exécuter une commande dans le conteneur pour vérifier la version de Python

**Livrable :** Commandes utilisées et leurs sorties

# Exercice 4 : Amélioration de la sécurité

1. Pour des mesures de sécurité, il est déconseillé d'exécuter un serveur en mode root. Créez un Dockerfile ‘Dockerfile-apiuser’ qui permet de créer un utilisateur apiuser via lequel sera exécuté le serveur Flask  
2. Construire l'image Docker  
3. Exécuter le conteneur  
4. Vérifier que le serveur Flask est lancé par l’utilisateur apiuser

**Livrable :** Commandes utilisées et leurs sorties

# Exercice 5 : Gestion des logs

1. Créez un volume log-volume permettant de collecter les logs de l’api (serveur Flask).   
2. Arrêter le conteneur et vérifier que les logs du serveur Flask sont stockés dans le volume.

**Livrable :** Commandes utilisées et leurs sorties

