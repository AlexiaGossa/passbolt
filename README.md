# Objectif de ce projet GitHub ?

L'idée est de proposer une installation clef en main sous AlmaLinux du gestionnaire de mots de passe Passbolt.  

Voici les 3 possilités offertes par ce projet :  
> 1 - Une installation d'un serveur autonome ou *standalone*.
> 
> 2 - Installation d'un serveur "Master" accessible depuis internet et d'un serveur "Rescue" accessible en local si jamais le serveur "Master" tombe en panne.
> 
> 3 - Installation d'un cluster de 3 (ou plus) serveurs "Masters" accessibles depuis internet et d'un serveur "Rescue" accessible en local si jamais le serveur "Master" tombe en panne.
> 

**Attention :** Le mode cluster nécessite l'utilisation du HAproxy (ou équivalent).  

Les différentes documentations sont présentes dans le dossiers /docs  
Si vous avez besoin de créer vos certificats, il y a tous les éléments nécessaires dans /certificates  


