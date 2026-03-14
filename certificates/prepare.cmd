mkdir .\0_root\certs
mkdir .\0_root\crl
mkdir .\0_root\csr
mkdir .\0_root\newcerts
mkdir .\0_root\private

type nul > .\0_root\certs\ph.txt
type nul > .\0_root\crl\ph.txt
type nul > .\0_root\csr\ph.txt
type nul > .\0_root\newcerts\ph.txt
type nul > .\0_root\private\ph.txt

mkdir .\1_intermediate\certs
mkdir .\1_intermediate\crl
mkdir .\1_intermediate\csr
mkdir .\1_intermediate\newcerts
mkdir .\1_intermediate\private

type nul > .\1_intermediate\certs\ph.txt
type nul > .\1_intermediate\crl\ph.txt
type nul > .\1_intermediate\csr\ph.txt
type nul > .\1_intermediate\newcerts\ph.txt
type nul > .\1_intermediate\private\ph.txt


mkdir .\2_server

type nul > .\0_root\index.txt
echo 1000 > .\0_root\serial

type nul > .\1_intermediate\index.txt
echo 2000 > .\1_intermediate\serial
echo 3000 > .\1_intermediate\crlnumber

copy /Y .\conf-root.conf .\0_root\root.conf
copy /Y .\conf-intermediate.conf .\1_intermediate\intermediate.conf
copy /Y .\conf-wildcard.monentreprise.fr.conf .\2_server\wildcard.monentreprise.fr.conf

