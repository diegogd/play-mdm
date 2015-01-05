#!/bin/sh
export PW=`cat password`

# Export server's public certificate for use with nginx.
keytool -export -v \
  -alias server \
  -file server.crt \
  -keypass:env PW \
  -storepass:env PW \
  -keystore server.jks \
  -rfc

# Create a PKCS#12 keystore containing the public and private keys.
keytool -importkeystore -v \
  -srcalias server \
  -srckeystore server.jks \
  -srcstoretype jks \
  -srcstorepass:env PW \
  -destkeystore server.p12 \
  -destkeypass:env PW \
  -deststorepass:env PW \
  -deststoretype PKCS12

# Export the example.com private key for use in nginx.  Note this requires the use of OpenSSL.
openssl pkcs12 \
  -nocerts \
  -nodes \
  -passout env:PW \
  -passin env:PW \
  -in server.p12 \
  -out server.key

# Clean up.
rm server.p12