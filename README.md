# Objectif de ce projet GitHub ?

L'idée est de proposer une installation clef en main sous AlmaLinux du gestionnaire de mots de passe Passbolt.  

Voici les 3 possilités offertes par ce projet :  

## Scénario 1 - Serveur Autonome
Une installation d'un serveur autonome ou *standalone*.  
https://github.com/AlexiaGossa/passbolt/blob/main/docs/master-standalone.md  

## Scénario 2 - Serveur Master et Serveur Rescue
Installation d'un serveur "Master" accessible depuis internet et d'un serveur "Rescue" accessible en local si jamais le serveur "Master" tombe en panne.  
https://github.com/AlexiaGossa/passbolt/blob/main/docs/master-rescue-part1.md  
https://github.com/AlexiaGossa/passbolt/blob/main/docs/master-rescue-part2.md  

### Attention
Le serveur Rescue, même s'il permet de modifier des mots passe ou d'en ajouter, il faut seulement l'utiliser en lecture seule et ne rien modifier dessus. Pourquoi ? Lorsque le Master va revenir en ligne, toutes les modifications du Rescue seront perdues !

**Le serveur Rescue n'est là qu'en secours ultime pour continuer à consulter ses mots de passe en cas de défaillance grave.**

## Scénario 3 - Cluster Master et Serveur Rescue
Installation d'un cluster de 3 (ou plus) serveurs "Masters" accessibles depuis internet et d'un serveur "Rescue" accessible en local si jamais le serveur "Master" tombe en panne.  
*En cours d'écriture*  

**Attention :** Le mode cluster nécessite l'utilisation du HAproxy (ou équivalent).  


## Important  

Les différentes documentations sont présentes dans le dossiers /docs  
Si vous avez besoin de créer vos certificats, il y a tous les éléments nécessaires dans /certificates  


