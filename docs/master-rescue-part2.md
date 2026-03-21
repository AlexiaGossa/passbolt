# Scénario 2 - Installation en mode Master-Rescue (2/2)

**Ce document traîte uniquement la partie 2 - Rescue.**


## Etape 0 - Rappel des définition des données


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

### 3.7 - Ajout de Git, Unzip et de Composer
>     dnf install git unzip composer -y



## Etape 4 - Configuration de MariaDB


### 4.1 - Activation de MariaDB
>     systemctl enable --now mariadb.service  
>     systemctl start mariadb

### 4.2 - Réglages sur MariaDB
>     mysql_secure_installation

4.2.1 - Initialement on ne dispose pas de mot de passe root pour mariadb, on saute => « ENTER »  
4.2.2 - Puis pas d’authentification unix-socket => « n »  
4.2.3 - On change le mot de passe root => « Y »  
4.2.4 - On saisit le mot de passe `rescue.db.root.password`  
4.2.5 - On supprime les utilisateurs anonymes => « Y »  
4.2.6 - On interdit le login distant en root => « Y »  
4.2.7 - On supprime la BDD de test => « Y »  
4.2.8 - On recharge les privilèges des tables => « Y »  

### 4.3 - Utilisateurs et base de données sur MariaDB

4.3.1 - On se connecte en tant que root sur MariaDB avec `rescue.db.root.password`  
>     mysql -u root -p

4.3.2 - On créer un utilisateur administrateur avec du pouvoir  
> CREATE USER '`rescue.db.admin.username`'@'%' IDENTIFIED BY '`rescue.db.admin.password`';  
> GRANT ALL PRIVILEGES ON \*.\* TO '`rescue.db.admin.username`'@'%';  
> GRANT USAGE ON \*.\* TO '`rescue.db.admin.username`'@'%' WITH GRANT OPTION;  
 
4.3.3 - Création de la base et de l’utilisateur passbolt  
> CREATE DATABASE passbolt CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;  
> CREATE USER 'passbolt'@'localhost' IDENTIFIED BY '`db.passbolt.password`';  
> GRANT ALL PRIVILEGES ON passbolt.* TO 'passbolt'@'localhost';  

4.3.4 - Création de l’utilisateur de rescue  
> CREATE USER 'passbolt-rescue'@'localhost' IDENTIFIED BY '`db.passbolt-rescue.password`';  
> GRANT ALL PRIVILEGES ON passbolt.* TO 'passbolt-rescue'@'localhost';  


4.3.5 - On termine  
>     FLUSH PRIVILEGES;  
>     EXIT  


## Etape 5 - Copie et modification de Passbolt

### 5.1 - On va maintenant synchroniser les différents dossiers de passbolt à partir du serveur Master (nous utilisons `master.ip` à titre d'exemple)  
>     rsync -aAXHv root@192.168.1.1:/var/www/passbolt/ /var/www/passbolt/  
>     rsync -aAXHv root@192.168.1.1:/etc/httpd/conf.d/passbolt.conf /etc/httpd/conf.d/passbolt.conf  
>     rsync -aAXHv root@192.168.1.1:/usr/share/httpd/.gnupg/ /usr/share/httpd/.gnupg/  

### 5.2 - On doit maintenant modifier la config de apache httpd  
> nano /etc/httpd/conf.d/passbolt.conf  

### 5.3 - On ne modifie que la ligne ServerName en `passbolt-rescue.url` (mais sans https://)
>    ServerName              pass-rescue.monentreprise.fr  

### 5.4 - On fait de même avec la config de passbolt  
>     sudo su -s /bin/bash apache  
>     cd /var/www/passbolt  
>     nano config/passbolt.php  

### 5.5 - On doit modifier une seule ligne  
> >     'fullBaseUrl' => env('APP_FULL_BASE_URL', 'https://pass.monentreprise.fr')  
> devient  
> >     'fullBaseUrl' => env('APP_FULL_BASE_URL', 'https://pass-rescue.monentreprise.fr')  

### 5.6 - On quitte l'utilisateur apache.  
>     exit  

### 5.7 - On redémarre apache httpd  
>     systemctl restart httpd  

### 5.8 - On récupère la partie rescue de ce GitHub  
>     cd /var/www
>     mkdir passbolt-rescue
>     cd passbolt-rescue
>     curl -L https://github.com/AlexiaGossa/passbolt/archive/refs/heads/main.zip -o passbolt.zip
>     unzip ./passbolt.zip 'passbolt-main/server-rescue/*'
>     cp -rf ./passbolt-main/server-rescue/* /var/www/passbolt/
>     cd /var/www
>     rm -rf ./passbolt-rescue
>     chown -R apache:apache /var/www/passbolt/webroot/rescue.php
>     chmod g+s /var/www/passbolt/webroot/rescue.php
>     chmod -R 775 /var/www/passbolt/webroot/rescue.php
>     chown -R apache:apache /var/www/passbolt/rescue
>     chmod g+s /var/www/passbolt/rescue
>     chmod -R 775 /var/www/passbolt/rescue
>     cd /var/www/passbolt
>     chmod +x /var/www/passbolt/rescue/master2rescue.sh

### 5.9 - Modification du script de copie
>     sudo su -s /bin/bash apache  
>     cd /var/www/passbolt  
>     nano rescue/master2rescue.sh  

On modifie les éléments suivants  
> DB_REMOTE_HOST="`master.ip`"  
> DB_REMOTE_PASSWORD="`db.passbolt-rescue.password`"  
> DB_LOCAL_PASSWORD="`db.passbolt-rescue.password`"  

On quitte l'utilisateur apache.  
>     exit

### 5.10 - Ajout de la copie automatique

Il ne reste qu’à activer le cron pour gérer la copie de la base de données Master  
>     touch /var/www/passbolt/rescue/rescue.log

On édite le cron pour l'utilisateur root avec nano (pour les allergiques à vim comme moi)  
>     export VISUAL=nano; crontab -e  

On ajoute cette ligne  
>     */30 * * * * /var/www/passbolt/rescue/master2rescue.sh > /var/www/passbolt/rescue/rescue.log

La copie se fera 2 fois par heure, toutes les 30 minutes, donc à XXh00 et à XXh30.  

## 6 - C'est fini !
Notre rescue est prêt mais il faut attendre au moins 30 minutes pour qu'il y ait une réplication.  
Sinon nous pouvons lancer manuellement le script :  
>     /var/www/passbolt/rescue/master2rescue.sh


### Pour le tester, il faut éteindre le master...  
> Il faut se connecter sur notre site de rescue à l'adresse `passbolt-rescue.url`  
> Il faut demander de à récupérer le compte mais cela ne fonctionnera pas car le serveur "Rescue" n'a pas le droit d'envoyer des emails.  
> Afin de palier à cela, nous avons une page de récupération.  
> `passbolt-rescue.url`/rescue.php  
> 
> Par exemple : https://pass-rescue.monentreprise.fr/rescue.php  

**Points importants**  
**1 - Cette page permet de récupérer un compte !**  
**De ce fait, elle ne doit pas accessible sur internet mais accessible uniquement en réseau local.**  
**2 - Il faut utiliser un autre navigateur pour vous connecter sur le serveur "Rescue" afin d'éviter de perdre votre session sur le serveur "Master". A noter que la navigation privée ne fonctionne pas avec les extensions.**  


