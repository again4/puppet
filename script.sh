#!/bin/bash

# Запитуємо доменне ім'я та IP-адресу
read -p "Введіть доменне ім'я (наприклад, node01): " DOMAIN
read -p "Введіть IP-адресу (наприклад, 192.168.1.1): " IP

# Генеруємо конфігураційний файл OpenSSL
cat > openssl-$DOMAIN.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $DOMAIN
IP.1 = $IP
EOF

echo "Конфігураційний файл openssl-$DOMAIN.cnf створено."

# Генеруємо приватний ключ
openssl genrsa -out $DOMAIN.key 2048
echo "Приватний ключ $DOMAIN.key створено."

# Створюємо запит на сертифікат
openssl req -new -key $DOMAIN.key -subj "/CN=system:node:$DOMAIN/O=system:nodes" -out $DOMAIN.csr -config openssl-$DOMAIN.cnf
echo "Запит на сертифікат $DOMAIN.csr створено."

# Підписуємо сертифікат
openssl x509 -req -in $DOMAIN.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out $DOMAIN.crt -extensions v3_req -extfile openssl-$DOMAIN.cnf -days 1000
echo "Сертифікат $DOMAIN.crt створено."

# Очищення
rm -f openssl-$DOMAIN.cnf $DOMAIN.csr
echo "Тимчасові файли видалено."

echo "Готово! Ваші файли:"
echo "- Приватний ключ: $DOMAIN.key"
echo "- Сертифікат: $DOMAIN.crt"
