Procédure écrite pour Windows
======

# Préparation des dossiers

## Option 1
Vous récupérer les dossiers `0_root`, `1_intermediate` et `2_server` pour les adapter à vos besoins

## Option 2
Vous récupérer le contenu du dossier `prepare`, vous modifier les 3 fichiers de configuration pour les adapter à vos besoins et vous exécuter `prepare.cmd` afin de générer automatiquement toute l'arborescence.


# Démarrage

Comment procéder pour le traitement des certificats root, intermediate et server ?

Vous placer votre ligne de commande à la racine des dossiers `0_root`, `1_intermediate` et `2_server`


## Si vous avez le binaire 64bits de OpenSSL, lancer les 3 lignes suivantes :
> set OPENSSL_CONF=C:\OpenSSL-Win64\bin\openssl.cfg
> 
> set RANDFILE=.rnd
> 
> set PATH=%PATH%;C:\OpenSSL-Win64\bin\
> 

## Si vous avez le binaire 32bits de OpenSSL, lancer les 3 lignes suivantes :
> set OPENSSL_CONF=C:\OpenSSL-Win32\bin\openssl.cfg
> 
> set RANDFILE=.rnd
> 
> set PATH=%PATH%;C:\OpenSSL-Win32\bin\
> 

## Si vous avez l'ancien install de OpenSSL, lancer les 3 lignes suivantes :
> set OPENSSL_CONF=C:\OpenSSL\bin\openssl.cfg
> 
> set RANDFILE=.rnd
> 
> set PATH=%PATH%;C:\OpenSSL\bin\
> 


# Etape 1 - On génère le CA-root pour 30 ans
La phrase PEM : **AvionFilPuisseCahierEcranPapierSolChoix**

> openssl genrsa -aes256 -out 0_root\private\root.key.pem 4096
> 
> openssl req -config 0_root\root.conf -key 0_root\private\root.key.pem -new -x509 -days 10950 -sha256 -out 0_root\certs\root.cert.pem
> 

On peut contrôler
> openssl x509 -in 0_root\certs\root.cert.pem -noout -text

On voit :
> 	CA:TRUE
> 
> 	pathlen:1
> 
> 	Key Usage: Certificate Sign, CRL Sign
> 



# Etape 2 - On génère la clef et le CSR de l'intermediate
La phrase de passe : **ClavierOnglesPhoneMarqueBleuRayuresTableau**

> openssl genrsa -aes256 -out 1_intermediate\private\intermediate.key.pem 4096
> 
> openssl req -config 1_intermediate\intermediate.conf -new -sha256 -key 1_intermediate\private\intermediate.key.pem -out 1_intermediate\csr\intermediate.csr.pem
> 


On signe l'intermediate par la root
> openssl ca -config 0_root\root.conf -extensions v3_intermediate_ca -notext -in 1_intermediate\csr\intermediate.csr.pem -out 1_intermediate\certs\intermediate.cert.pem
> 

On peut contrôler
> openssl x509 -in 1_intermediate\certs\intermediate.cert.pem -noout -text
> 

On voit :
> 	CA:TRUE
> 
> 	pathlen:0
> 

	
# Etape 3 - Création du bundle, de intermédiaire et du root pour l'OS
> type 1_intermediate\certs\intermediate.cert.pem > ca-bundle.crt
> 
> type 0_root\certs\root.cert.pem >> ca-bundle.crt
> 
> type 0_root\certs\root.cert.pem > ca-root.crt
> 
> type 1_intermediate\certs\intermediate.cert.pem > ca-intermediate.crt
> 



# Etape 4 - On signe le certificat de "mon entreprise"
Mais on peut aussi le voir, il est dans ".\2_server"

> openssl req -nodes -newkey rsa:2048 -batch -sha256 -keyout 2_server\wildcard.monentreprise.fr.key -out 2_server\wildcard.monentreprise.fr.csr -config 2_server\wildcard.monentreprise.fr.conf
> 
> openssl x509 -req -days 730 -CA 1_intermediate\certs\intermediate.cert.pem -CAkey 1_intermediate\private\intermediate.key.pem -in 2_server\wildcard.monentreprise.fr.csr -out 2_server\wildcard.monentreprise.fr.crt -extfile 2_server\wildcard.monentreprise.fr.conf -extensions v3_req
> 


On vérifie le certificat
> openssl x509 -in 2_server\wildcard.monentreprise.fr.crt -noout -text
> 

On voit
> 	CA:FALSE
> 
> 	Extended Key Usage: TLS Web Server Authentication
> 
> 	Subject Alternative Name: DNS:*.monentreprise.fr, DNS:monentreprise.fr
> 



# Etape 5 - Utilisation des certicats

Pour Apache HTTPD, vous devez utiliser les 3 fichiers `ca-bundle.crt`, `wildcard.monentreprise.fr.crt` et `wildcard.monentreprise.fr.key`.

Pour votre navigateur et surtout votre système, vous devez ajouter le fichier **ca-root.crt** dans l'ordinateur, dans "Autorités de certification racines de confiance"
