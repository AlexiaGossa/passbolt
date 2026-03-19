# Scénario 2 - Installation en mode Master-Rescue (1/2)

**Ce document traîte uniquement la partie 1 - Master.**


## Etape 0 - Définition des données


Vous devez en tout premier lieu définir certaines données.

| Définition | Nom de la donnée | Exemple |
| :--- | :---: | :---: |
| Adresse IP du serveur Master | `master.ip` | `192.168.1.1` |
| Adresse IP du serveur Rescue | `rescue.ip` | `192.168.1.2` |
| Mot de passe "root" du serveur Master | `master.root.password` | `gr5sVblbVmIuKJjknPVJ` |
| Mot de passe "root" du serveur Rescue | `rescue.root.password` | `gcU1mvfbBkwljCSZyZIW` |
| Mot de passe "root" MariaDB Master | `master.db.root.password` | `UuZ2CPALgqqX7lRR22L6` |
| Mot de passe "root" MariaDB Rescue | `rescue.db.root.password` | `xgPrOuHxq10noSdPoHd3` |
| Nom d'utilisateur "administrateur" MariaDB Master | `master.db.admin.username` | `alexiagossa` |
| Mot de passe "administrateur" MariaDB Master | `master.db.admin.password` | `6HNj5Tuilzo7rN5Oamcf` |
| Nom d'utilisateur "administrateur" MariaDB Rescue | `rescue.db.admin.username` | `alexiagossa` |
| Mot de passe "administrateur" MariaDB Rescue | `rescue.db.admin.password` | `6HNj5Tuilzo7rN5Oamcf` |
| Mot de passe "passbolt" MariaDB | `db.passbolt.password` | `PhMsnipuKpMLun07nBR1` |
| Mot de passe "passbolt-rescue" MariaDB | `db.passbolt-rescue.password` | `S742oH1FkTKFWd0GnKyF` |
| 1er utilisateur Passbolt - Prénom | `passbolt.user.firstname` | `Alexia` |
| 1er utilisateur Passbolt - Nom | `passbolt.user.lastname` | `Gossa` |
| 1er utilisateur Passbolt - Mot de passe | `passbolt.user.password` | `fDT94UkdxAqFvFKGfwbw` |
| 1er utilisateur Passbolt - Email | `passbolt.user.email` | `alexia.gossa@monentreprise.fr` |
| URL de Passbolt à utiliser | `passbolt.url` | `https://pass.monentreprise.fr` |
| URL rescue de Passbolt à utiliser | `passbolt-rescue.url` | `https://pass-rescue.monentreprise.fr` |
| Empreinte GPG | `gpg.footprint` | `4E2198BF7906461E5806ED90B3826EACF2AEE747` |
| OVH - Email Username | `ovh.email.account.username` | `contact@monentreprise.fr` |
| OVH - Email Password | `ovh.email.account.password` | `H5yAtmQWLmP2O9xrcF5y` |
| Email d'envoi de Passbolt | `passbolt.sendfrom` | `passbolt@monentreprise.fr` |
| Email défaut de l'entreprise | `enterprise.default.email` | `contact@monentreprise.fr` |
| Chaine de certificats | `cert.bundle-ca` | `/var/www/passbolt/ca/monentreprise-bundleca.crt` |
| Certificat du serveur | `cert.server.crt` | `/var/www/passbolt/ca/wildcard-monentreprise.crt` |
| Clef privée du certificat du serveur | `cert.server.key` | `/var/www/passbolt/ca/wildcard-monentreprise.key` |


Note 1 : Pour notre exemple, nous utilisons un compte OVH pour envoyer des emails.  
Note 2 : Il est nécessaire d'avoir les certificats avant de démarrer la procédure (voir la procédure des certificats jointe si nécessaire).  




## Etape 1 - Préparation

Il est recommandé de faire une première lecture intégrale de cette documentation avant de démarrer afin de bien comprendre ce qui va être fait.


## Etape 2 - Installation

On télécharge et on installe notre distribution AlmaLinux 9.7 dans une VM (dans cet exemple sous VMware ESXi).  
Il faut bien spécifier les paramètres réseau ainsi que la config de base pour l'utilisateur `root` tel que :
- [ ] Verrouillage du compte root
- [x] Autorisation d'accès en SSH

On peut utiliser d'autres paramètres si nécessaire, mais il faudra alors adapter cette documentation à vos besoin.


## Etape 3 - Configuration de base


### 3.1 - Mise à jour de la distribution
>     dnf update && dnf upgrade

### 3.2 - Ajout de quelques outils
>     dnf install cockpit nano dnf-utils -y  
>     systemctl enable --now cockpit.socket  
>     systemctl start cockpit

### 3.3 - Ajout de open-vm-tools (si vous utilisez VMware)  
>     dnf install open-vm-tools -y  
>     systemctl enable --now vmtoolsd.service  
>     systemctl start vmtoolsd.service

### 3.4 - Passage de SElinux en mode disabled
Modifier `enforcing` en `disabled`  
>     nano /etc/selinux/config  

### Uniquement en cas de besoin, on peut autoriser (temporairement) root dans cockpit
Modifier `root` en `#root`  
>     nano /etc/cockpit/disallowed-users  

### 3.5 - Redémarrage
>     reboot  

### 3.6 - Ajout de Apache HTTPD, PHP 8.4 et MariaDB (pour AlmaLinux 9.7)  
>     dnf install https://rpms.remirepo.net/enterprise/remi-release-9.7.rpm -y  
>     dnf module switch-to php:remi-8.4 -y  
>     dnf install httpd mod_ssl wget curl mariadb mariadb-server rsync -y
>     dnf install php php-fpm php-cli php-curl php-mysqlnd php-gd php-xml php-mbstring php-zip php-common php-json php-readline php-xml php-dom php-gnupg php-ldap -y
>     systemctl enable --now httpd  
>     systemctl start httpd  
>     firewall-cmd --permanent --add-service=http  
>     firewall-cmd --permanent --add-service=https  
>     firewall-cmd --permanent --add-service=mysql  
>     firewall-cmd --reload  

### 3.7 - Ajout de Git et de Composer
>     dnf install git composer -y



## Etape 4 - Configuration de MariaDB


### 4.1 - Activation de MariaDB
>     systemctl enable --now mariadb.service  
>     systemctl start mariadb

### 4.2 - Réglages sur MariaDB
>     mysql_secure_installation

4.2.1 - Initialement on ne dispose pas de mot de passe root pour mariadb, on saute => « ENTER »  
4.2.2 - Puis pas d’authentification unix-socket => « n »  
4.2.3 - On change le mot de passe root => « Y »  
4.2.4 - On saisit le mot de passe `master.db.root.password`  
4.2.5 - On supprime les utilisateurs anonymes => « Y »  
4.2.6 - On interdit le login distant en root => « Y »  
4.2.7 - On supprime la BDD de test => « Y »  
4.2.8 - On recharge les privilèges des tables => « Y »  

### 4.3 - Utilisateurs et base de données sur MariaDB

4.3.1 - On se connecte en tant que root sur MariaDB avec `master.db.root.password`  
>     mysql -u root -p

4.3.2 - On créer un utilisateur administrateur avec du pouvoir  
> CREATE USER '`master.db.admin.username`'@'%' IDENTIFIED BY '`master.db.admin.password`';  
> GRANT ALL PRIVILEGES ON *.* TO '`master.db.admin.username`'@'%';  
> GRANT USAGE ON *.* TO '`master.db.admin.username`'@'%' WITH GRANT OPTION;  
 
4.3.3 - Création de la base et de l’utilisateur passbolt  
> CREATE DATABASE passbolt CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;  
> CREATE USER 'passbolt'@'localhost' IDENTIFIED BY '`db.passbolt.password`';  
> GRANT ALL PRIVILEGES ON passbolt.* TO 'passbolt'@'localhost';  

4.3.4 - Création de l’utilisateur de rescue  
> CREATE USER 'passbolt-rescue'@'`rescue.ip`' IDENTIFIED BY 'db.passbolt-rescue.password';  
> GRANT SELECT, SHOW VIEW, TRIGGER, EVENT ON passbolt.* TO 'passbolt-rescue'@'`rescue.ip`';  


4.3.5 - On termine  
>     FLUSH PRIVILEGES;  
>     EXIT  


## Etape 5 - Déploiement de Passbolt

### 5.1 - Déploiment à partir des sources officielles de la version Community Edition
>     cd /var/www  
>     git clone https://github.com/passbolt/passbolt_api.git  
>     mv passbolt_api passbolt  
>     chown -R apache:apache /var/www/passbolt/  
>     chmod g+s /var/www/passbolt/  
>     chmod -R 775 /var/www/passbolt/  
>     sudo chown -R apache:apache /usr/share/httpd/  
>     sudo chmod -R 775 /usr/share/httpd/  

### 5.2 - Basculement dans l'utilisateur Apache
>     sudo su -s /bin/bash apache

### 5.3 - Création de notre clef *(utilisateur apache)*
>     gpg --batch --no-tty --gen-key <<EOF  
>       Key-Type: RSA  
>       Key-Length: 3072  
>       Key-Usage: sign,cert  
>       Subkey-Type: RSA  
>       Subkey-Usage: encrypt  
>       Subkey-Length: 3072  
>       Name-Real: `passbolt.user.firstname` `passbolt.user.lastname`  
>       Name-Email: `passbolt.user.email`  
>       Expire-Date: 0  
>       %no-protection  
>       %commit  
>     EOF

### 5.4 - Récupération de l'empreinte *(utilisateur apache)*
>     gpg --list-keys  
**Il faut noter l'empreinte GPG, c'est important.**  => `gpg.footprint`
Par exemple `4E2198BF7906461E5806ED90B3826EACF2AEE747`  

### 5.5 - Installation de Passbolt *(utilisateur apache)*
>     cd /var/www/passbolt  
>     composer install --no-dev  
A la question "Set folder permissions ?", on répond Y  

### 5.6 - Configuration de Passbolt *(utilisateur apache)*
>     cp config/passbolt.default.php config/passbolt.php  
>     nano config/passbolt.php  

#### 5.6.1 - Modification de certaines lignes

L'URL pour se connecter à Passbolt  
> > 'fullBaseUrl' => env('APP_FULL_BASE_URL', 'https://www.passbolt.test')  
> devient :  
> > 'fullBaseUrl' => env('APP_FULL_BASE_URL', '`passbolt.url`')  

Le nom d'utilisateur pour se connecter à la base de données Passbolt  
> > 'username' => env('DATASOURCES_DEFAULT_USERNAME', 'user'),  
> devient :  
> > 'username' => env('DATASOURCES_DEFAULT_USERNAME', 'passbolt'),  

Le mot de passe pour se connecter à la base de données Passbolt  
> > 'password' => env('DATASOURCES_DEFAULT_PASSWORD', 'secret'),  
> devient :  
> > 'password' => env('DATASOURCES_DEFAULT_PASSWORD', '`db.passbolt.password`'),  

Pour la partie email, c'est primordial, il faut que cela fonctionne à coup sûr ! (par exemple OVH)  
> 'host' => env('EMAIL_TRANSPORT_DEFAULT_HOST', 'ssl0.ovh.net'),  
> 'port' => env('EMAIL_TRANSPORT_DEFAULT_PORT', 587),  
> 'timeout' => env('EMAIL_TRANSPORT_DEFAULT_TIMEOUT', 30),  
> 'username' => env('EMAIL_TRANSPORT_DEFAULT_USERNAME', '`ovh.email.account.username`'),  
> 'password' => env('EMAIL_TRANSPORT_DEFAULT_PASSWORD', '`ovh.email.account.password`'),  
> 'tls' => env('EMAIL_TRANSPORT_DEFAULT_TLS', true),  

Le delivery d'email  
> env('EMAIL_DEFAULT_FROM', '`passbolt.sendfrom`')  
> env('EMAIL_DEFAULT_FROM_NAME', 'Passbolt')  

L'empreinte GPG  
>     'fingerprint' => env('PASSBOLT_GPG_SERVER_KEY_FINGERPRINT', '`gpg.footprint`'),

En option uniquement si vous avez besoin d'être moins restrictif pour la communication avec le serveur d'emails...  
Il faut chercher la ligne :  
>     'passbolt' => [  

Puis ajouter en dessous les éléments suivants :
>        'plugins' => [  
>            'smtpSettings' => [  
>                'security' => [  
>                    'sslVerifyPeer' => false,  
>                    'sslVerifyPeerName' => false,  
>                    'sslAllowSelfSigned' => true,  
>                ],  
>            ],  
>        ],  


#### 5.6.2 - Correction des droits *(utilisateur apache)* 
On quitte nano et toujours sous l’utilisateur `apache` on revient au root
>     exit  
>     cd /var/www/passbolt  
>     chown -Rf apache:apache /var/www/passbolt/config/jwt/  
>     chmod 750 /var/www/passbolt/config/jwt/  

#### 5.6.3 - Démarrage du script d'installation final de passbolt  
>     sudo su -s /bin/bash -c "./bin/cake passbolt install" apache

On a une erreur, on modifie les droits :  
>     chown -Rf root:apache /var/www/passbolt/config/jwt/  
>     chmod 750 /var/www/passbolt/config/jwt/  
>     chmod 640 /var/www/passbolt/config/jwt/jwt.key  
>     chmod 640 /var/www/passbolt/config/jwt/jwt.pem

On relance l'install  
>     sudo su -s /bin/bash -c "./bin/cake passbolt install" apache  

On saisit le nom du premier utilisateur admin de passbolt  
> Email => `passbolt.user.email`  
> First name => `passbolt.user.firstname`  
> Last name => `passbolt.user.lastname`  

On dispose d'une URL qu'il faut absolument conserver, c'est pour activer notre compte !  
Voici un exemple de ce que l'on peut obtenir  
> https://pass.monentreprise.fr/setup/start/ab9cb891-72bc-4ea2-bea8-347a07ce3bbe/943eef09-ee12-4571-83a0-b3414beb22ac


#### 5.6.4 - On vérifie l'état de passbolt
>     sudo su -s /bin/bash -c "./bin/cake passbolt healthcheck" apache  
On a 2 erreurs, c’est normal.


### 5.7 - Configuration de Apache HTTPD

La configuration proposée permet d'avoir un certificat directement dans Apache HTTPD pour démarrer rapidement.  
Ce n'est pas la meilleure méthode, un HAproxy est préférable pour centraliser les certificats et la gestion HTTPS des flux externes (mais en HTTP pour les flux internes).  

>     nano /etc/httpd/conf.d/passbolt.conf  

**Voici un exemple de configuration**  
On utilise ici les informations  
> ServerName = `passbolt.url` (sans https://)  
> SSLCertificateChainFile = `cert.bundle-ca`  
> SSLCertificateFile = `cert.server.crt`   
> SSLCertificateKeyFile = `cert.server.key`  
> ServerAdmin = `enterprise.default.email`  


>     Protocols               h2 h2c http/1.1
>     ProtocolsHonorOrder     On
>     LogFormat               "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" co>
>     LogFormat               "%a %h %l %u %t \"%r\" %>s %b" common
>
>     <VirtualHost *:443>
>         ServerName              pass.monentreprise.fr
>         SSLEngine               On
>         SSLProtocol             -ALL +TLSv1.3 +TLSv1.2
>         SSLCompression          Off
>         SSLHonorCipherOrder     On
>         SSLCertificateChainFile /var/www/passbolt/ca/monentreprise-bundleca.crt
>         SSLCertificateFile      /var/www/passbolt/ca/wildcard-monentreprise.crt
>         SSLCertificateKeyFile   /var/www/passbolt/ca/wildcard-monentreprise.key
>         DocumentRoot            /var/www/passbolt/webroot
>         ServerAdmin             contact@monentreprise.fr
>         DirectoryIndex          index.php
>         LogLevel                Warn
>         ErrorLog                "|/usr/sbin/rotatelogs /var/www/passbolt/logs/error.log 86400"
>         CustomLog               "|/usr/sbin/rotatelogs /var/www/passbolt/logs/access.log 86400" common
>         <Directory "/var/www/passbolt/webroot">
>             AllowOverride All
>             Options -Indexes -Includes -MultiViews +FollowSymLinks
>             Require all granted
>         </Directory>
>     </VirtualHost>

### 5.8 - Les certificats

On va placer les 3 fichiers des certificats  
>     mkdir /var/www/passbolt/ca

Il faut coller les 3 fichiers de certificats dans le chemin « /var/www/passbolt/ca »  
Puis on remet les droits correctement  
>     chown -Rf root:apache /var/www/passbolt/ca/  
>     chmod 740 /var/www/passbolt/ca/  

### 5.8 - Apache est prêt
On redémarre apache httpd  
>     systemctl restart httpd  

### 5.9 - Gestion automatique des emails
Il ne reste qu’à activer le cron pour l’envoie d’emails automatiques  
>     touch /var/log/passbolt.log && chown apache:apache /var/log/passbolt.log  

On édite le cron pour l'utilisateur apache avec nano (pour les allergiques à vim comme moi)  
>     export VISUAL=nano; crontab -u apache -e  

On ajoute cette ligne  
>     * * * * * /var/www/passbolt/bin/cron >> /var/log/passbolt.log  


## Etape 6 - Utilisation de Passbolt

Il peux être nécessaire de faire pointer le domaine `passbolt.url` vers la bonne IP `master.ip`.  
Il y a 2 options : modifier le DNS de notre organisation ou simplement ajouter une ligne dans notre fichiers hosts.  


Si vous choisissez de modifier le fichier hosts, n'oubliez pas de le faire aussi sur le serveur Master de Passbolt.  
Sous Windows, il se trouve ici « C:\Windows\System32\drivers\etc\hosts »  
Sous Linux, il se trouve là « /etc/hosts »  
Par exemple, il faut juste ajouter la ligne suivante  
>     192.168.1.1        pass.monentreprise.fr
>     192.168.1.2        pass-rescue.monentreprise.fr  


Dés lors que le DNS et/ou que les fichiers hosts sont à jour la suivante  
>     cd /var/www/passbolt  
>     sudo su -s /bin/bash -c "./bin/cake passbolt healthcheck" apache  
Ne rapporte plus qu’une seule erreur.  


**On peut maintenant tester notre gestionnaire Passbolt avec notre navigateur web préféré.**

## Informations additionnelles

Pour connaître l’état du serveur  
>     cd /var/www/passbolt  
>     sudo su -s /bin/bash -c "./bin/cake passbolt healthcheck" apache  

Pour connaître les emais en attente  
>     cd /var/www/passbolt  
>     sudo su -s /bin/bash -c "./bin/cake passbolt email_digest preview" apache

