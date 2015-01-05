#!/bin/bash

export PW=`cat password`

# Create a server certificate, tied to server
keytool -genkeypair -v \
  -alias server \
  -dname "CN=server, OU=Example Org, O=Example Company, L=San Francisco, ST=California, C=US" \
  -keystore server.jks \
  -keypass:env PW \
  -storepass:env PW \
  -keyalg RSA \
  -keysize 2048 \
  -validity 385

# Create a certificate signing request for server
keytool -certreq -v \
  -alias server \
  -keypass:env PW \
  -storepass:env PW \
  -keystore server.jks \
  -file server.csr

# Tell exampleCA to sign the server certificate. Note the extension is on the request, not the
# original certificate.
# Technically, keyUsage should be digitalSignature for DHE or ECDHE, keyEncipherment for RSA.
keytool -gencert -v \
  -alias myca \
  -keypass:env PW \
  -storepass:env PW \
  -keystore myca.jks \
  -infile server.csr \
  -outfile server.crt \
  -ext KeyUsage:critical="digitalSignature,keyEncipherment" \
  -ext EKU="serverAuth" \
  -ext SAN="DNS:server" \
  -rfc

# Tell server.jks it can trust exampleca as a signer.
keytool -import -v \
  -alias myca \
  -file myca.crt \
  -keystore server.jks \
  -storetype JKS \
  -storepass:env PW << EOF
yes
EOF

# Import the signed certificate back into server.jks
keytool -import -v \
  -alias server \
  -file server.crt \
  -keystore server.jks \
  -storetype JKS \
  -storepass:env PW

# List out the contents of example.com.jks just to confirm it.
# If you are using Play as a TLS termination point, this is the key store you should present as the server.
keytool -list -v \
  -keystore server.jks \
  -storepass:env PW