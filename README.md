# prosody-setup

## Working but not properly! 
## Prosody version 0.12+ required for stable work.

Currently this chat server is working but a lot of modules are not supported because docker image created on base prosody server version 0.11. For stable work of all modules version 0.12 of prosody required. 

This project was abandoned because official prosody image wasn't updated for 4 years now. So I decide to look for stable and supported solution for Docker.

Anyway I will left here short instruction how to start your own prosody server on docker using docker-compose.

1) Create folder where all server configs will be located

       mkdir /prosody_server
   
       mkdir /prosody_server/config

       mkdir /prosody_server/logs
     
3) Copy there docker-compose.yml, prosody.cfg.lua ### for config your server only this two files required.

4) I got issued certificates by Let's encrypt using Caddy.

        chat.domain.com {
   
          encode zstd gzip

  
          @ws path /xmpp-websocket*
          reverse_proxy @ws http://prosody:5280


          @bosh path /http-bind*
          reverse_proxy @bosh http://prosody:5280


          @upload path /upload/*
          reverse_proxy @upload http://prosody:5280

  
          handle_path /en/* {
            @ws2 path /xmpp-websocket*
            reverse_proxy @ws2 http://prosody:5280

            @bosh2 path /http-bind*
            reverse_proxy @bosh2 http://prosody:5280

            @upload2 path /upload/*
            reverse_proxy @upload2 http://prosody:5280
            }
          }

5) Place generated certificates for Prosody separetly and give them chmod and chown

(/etc/prosody/certs/chat.domain.com)
chown -R 1000:1000 /path/to/certs
chmod 644 chat.domain.com.crt
chomd 640 chat.domain.com.key

6) Allow ports in ufw
5222                       ALLOW       Anywhere
5280                       ALLOW       Anywhere
5281                       ALLOW       Anywhere
5269                       ALLOW       Anywhere

7) Port Forwarding on your router.

8) In my case for DB was chosen PostgreSQL. DB was placed in another disk.

        sudo mkdir -p /mnt/data_storage/prosody_pgdata

Postgres image runs as uid 999 (postgres). Give it ownership:

        sudo chown -R 999:999 /mnt/data_storage/prosody_pgdata

9) Set DB password in docker-compose.yml and prosody.cfg.lua

10) Now you should be good to go so

        docker compose up -d

11) For errors and logs look into /prosody_server/logs.

### Good Luck!
        


Main errors that I catched:

1) Steam Management - XEP-0198

2) Push - XEP-0357

3) HTTP File Upload - XEP-0357

   All of them can be fixed by modules but in Prosody version 0.12
