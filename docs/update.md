# Mise à jour des serveurs hébergés Passbolt

## Points importants
- l'emplacement de l'installation est dans /var/www/passbolt
- on utilise Apache HTTPD

## Préparation
Afin de mettre à jour les serveurs hébergés de Passbolt, il faut procéder sur tous les serveurs en même temps.


## Mise à jour vers la dernière version

### On arrête Apache HTTPD sur tous les serveurs
> systemctl stop httpd  

### Mise à jour à faire sur tous les serveurs
> chown -Rf apache:apache /var/www/passbolt/config/jwt/  
> chmod 750 /var/www/passbolt/config/jwt/  
> cd /var/www/passbolt  
> sudo su -s /bin/bash apache  
> cd /var/www/passbolt  
> git checkout HEAD .  
> git pull origin master  
> composer install --no-dev -n -o  
> exit  
> chown -Rf root:apache /var/www/passbolt/config/jwt/  
> chmod 750 /var/www/passbolt/config/jwt/  
> chmod 640 /var/www/passbolt/config/jwt/jwt.key  
> chmod 640 /var/www/passbolt/config/jwt/jwt.pem  
> sudo su -s /bin/bash -c "./bin/cake passbolt migrate --backup" apache  
> sudo su -s /bin/bash -c "./bin/cake cache clear_all" apache  

### Mise à jour  à faire sur tous les serveurs (optionnel - correction pour le dossier temporaire)
> chown -R apache:apache /var/www/passbolt/tmp/  
> chmod -R 775 $(find /var/www/passbolt/tmp/ -type d)  
> chmod -R 664 $(find /var/www/passbolt/tmp/ -type f)  

### On redémarre Apache HTTPD sur tous les serveurs
> systemctl start httpd  

### On vérifie l'état de passbolt sur chacun des serveurs
> sudo su -s /bin/bash -c "./bin/cake passbolt healthcheck" apache

## Fin
C'est terminé ! Vos serveurs Passbolt sont à jour.
