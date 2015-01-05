`This project does not work yet`

Mobile device management with Play Framework
============================================

This project starts as an exercise of creating a MDM Server as is described on [Apple Documentation](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/iPhoneOTAConfiguration/iPhoneOTAConfiguration.pdf)

## Preparing certificates

This application requires a server CA, lets created with the follow commands

    cd certificates
    export PW=`pwgen -Bs 32 1`
    echo $PW > password
    ../scripts/generateCAServer.sh
    ../scripts/generateServerCert.sh
    
If you want to configure the certificates in nginx you can export the keys with following script:

    ../scripts/exportCertificatesForNginx.sh
    
Then add the configuration to `nginx.conf`:

    ssl_certificate      /etc/nginx/certs/server.crt;
    ssl_certificate_key  /etc/nginx/certs/server.key;
    
## Instruction to run the application

Once the certificates have been generated you can run the application with the following command and configure nginx to run it:

    ./activator run

## Configure Nginx

An example configuration would be like follows:

    http {

      proxy_buffering    off;
      proxy_set_header   X-Real-IP $remote_addr;
      proxy_set_header   X-Scheme $scheme;
      proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header   Host $http_host;

      upstream my-backend {
        server 127.0.0.1:9000;
      }

      server {
        server_name www.mysite.com mysite.com;
        rewrite ^(.*) https://www.mysite.com$1 permanent;
      }

      server {
        listen               443;
        ssl                  on;
        ssl_certificate      /etc/ssl/certs/my_ssl.crt;
        ssl_certificate_key  /etc/ssl/private/my_ssl.key;
        keepalive_timeout    70;
        server_name www.mysite.com;
        location / {
          proxy_pass  http://my-backend;
        }
      }
    }

## Steps

1. Configure your infrastructure. This is described in Configuring the Infrastructure (page 14).
2. Obtain an SSL Certificate for your server. This is described in Obtaining an SSL Certificate (page 15).
3. Create a template configuration profile. This is described in Creating A Template Configuration Profile (page
15).
4. Create the server code. The pieces of a server are described in Starting the Server (page 16) and Profile
Service Handlers (page 17).
5. Add appropriate authentication specific to your environment.
6. Test the service.