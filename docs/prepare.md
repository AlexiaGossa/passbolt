Déploiement de Passbolt
=======================

Préparation
-----------
Avant de démarrer vous devez choisir quel scénario de déploiement sera utilisé pour Passbolt.

# Scénario 1 : Master
Serveur "Master" sans serveur de secours.  

# Scénario 2 : Master+Rescue
Serveur "Master" avec un serveur de secours privé nommé "Rescue".  
Le serveur "Rescue" doit toujours être privé, il ne doit pas être accessible à partir d'un accès web public car il dispose d'une activation sans email.  

# Scénario 3 : Cluster+Rescue
Cluster "Master" avec un serveur de secours privé nommé "Rescue".  
Le serveur "Rescue" doit toujours être privé, il ne doit pas être accessible à partir d'un accès web public car il dispose d'une activation sans email.  


Prérequis
---------
L'installation proposée est sous AlmaLinux 9.7 avec Apache HTTPD, PHP ainsi que MariaDB





