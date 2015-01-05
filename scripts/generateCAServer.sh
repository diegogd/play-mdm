#!/bin/bash

export PW=`cat password`

# Create a self signed key pair root CA certificate.
keytool -genkeypair -v \
  -alias myca \
  -dname "CN=myCA, OU=Example Org, O=Example Company, L=Madrid, ST=Madrid, C=ES" \
  -keystore myca.jks \
  -keypass:env PW \
  -storepass:env PW \
  -keyalg RSA \
  -keysize 4096 \
  -ext KeyUsage:critical="keyCertSign" \
  -ext BasicConstraints:critical="ca:true" \
  -validity 9999

# Export the exampleCA public certificate as myca.crt so that it can be used in trust stores.
keytool -export -v \
  -alias myca \
  -file myca.crt \
  -keypass:env PW \
  -storepass:env PW \
  -keystore myca.jks \
  -rfc