# Giblog Net - Portable GitHub system into your own server

Giblog Net is **portable Github system**. You can install portable GitHub system into **your own Unix/Linux server**.</span>

<img src="giblognet_01.png" width="870" border="1">


## Giblog Net example

At first, Let's try **[Giblog Net example](https://perlcodesample.sakura.ne.jp/giblognet/giblognet.cgi/kimoto/giblognet)**.
You will find Giblog Net is real portable GitHub system.

You can use all of repository, pull request, issue, wiki.

## Features

* Github clone: Giblog Net has the same interface as GitHub.
* Support issue system
* Portable: You can install Giblog Net on your own Unix/Linux server.
* Only needs Perl 5.10.1+.
* Smart HTTP support: you can pull and push repository via HTTP.
* Built-in web server, and reverse proxy support.
* CGI support.
* SSL support.
* Public key authentication support

**Installation** is very **easy**. You run only two commands.
Difficult settings is unnecessary.

Even if you have troubles by your mistake, for example "git push -f origin master",
you can access all of your git repositories **directory** and fix them.

All reporitories are yours. All repositories exists on **your own server**.

Open source. **All free**.

Let's try Giblog Net. If you like Giblog Net, please share and talk about Giblog Net in your community or your company.

## A. Install and run Giblog Net by embdded web server

Giblog Net has its own web server. You can start Giblog Net easily.

### Create giblognet user

Create a **giblognet** user. This is not necessary, but recommended:

    useradd giblognet
    su - giblognet
    cd ~

### Check if git is installed

    git --version

## Check Perl Version

Check Perl version. You can use Giblog Net if the Perl version is 5.10.1+;

    perl -v

If you don't have Perl 5.10.1+, you need to install a newer perl version with perlbrew.

    curl -L http://install.perlbrew.pl | bash
    echo "source ~/perl5/perlbrew/etc/bashrc" >> ~/.bash_profile
    source ~/.bash_profile
    
    perlbrew install perl-5.16.3
    perlbrew switch perl-5.16.3
    perl -v
    
Download Giblog Net .tar.gz archive, expand it and change directory:

    curl -kL https://github.com/yuki-kimoto/giblognet/archive/latest.tar.gz > giblognet-latest.tar.gz
    tar xf giblognet-latest.tar.gz
    mv giblognet-latest giblognet
    cd giblognet

Setup. Needed modules are installed.

    ./setup_module

If this fails and extlib directory already exists, try to remove "extlib" and run "./setup_module" again.

    rm -rf extlib
    ./setup_module

Check if module setup successes. Run the following command.

    prove t

If "syntax OK" is displayed, setup was successful. 

Setup database.

    ./setup_database

If you used Giblognet version 1 and upgrade it to version 2, you need to upgrade database
with the following command

    # Backup giblognet directory for safety
    cd ..
    cp -rp giblognet giblognet.bak
    
    # Upgrade database
    cd giblognet
    mv data/giblognet.db data/giblognet_v1bak.db
    ./setup_database
    old/copy_database_v1_to_v2 data/giblognet_v1bak.db data/giblognet.db

If you install git in your local directory,
you have to add the correct git command path to the **giblognet.conf** config file.

    [basic]
    ;;; Git command path
    git_bin=/home/yourname/local/bin/git

And do some settings

    git config --global core.quotepath false

### Start giblognet server

You can start the application by running the provided giblognet script.
The application is run in the background and the port is **10020** by default.

    ./giblognet

(If you run this command again, giblognet server restarts.)

Then access the following URL.

    http://localhost:10020

If you want to change the port, edit giblognet.conf.
If you cannot access this port, you might change the firewall settings.

### Stop giblognet server

You can stop the application by adding the **--stop** option.

    ./giblognet --stop

## B. Run Giblog Net as CGI script

You can run Giblog Net as CGI script as the following site.

[Giblog Net example site](https://perlcodesample.sakura.ne.jp/giblognet/giblognet.cgi/kimoto/giblognet)

This is shared server. I assume you can connect the server via SSH and login with your own user.

Installation process is same as above except for create user.

If you finish installation, you can access the following URL.

    http://yourhost/somepath/giblognet/giblognet.cgi

### If you see Internal Server Error

If you see an internal server error, look at the log file (giblognet/log/production.log)
to see what problem has occurred.

## FAQ

## I can't install Giblognet on CentOS

After CentOS 6, some perl core modules are not installed by default.
You can install Perl core modules by the following command.

    yum -y install perl-core

## Can't find git command from Giblog Net

If you install git into your local directory,
you must add the correct git command path to the config file **giblognet.conf** .

    [basic]
    ;;; Git command path
    git_bin=/home/yourname/local/bin/git

### blame doesn't work

In Giblognet, blame page uses "git blame --line-porcelain". In old git, there is no --line-porcelain option.
We don't know when --line-porcelain was added to git.
At least, blame page work well in git 1.8.2.1.

### How to upgrade Giblog Net

It is very easy. you only overwrite all files except for "giblognet.conf".

If you want to upgrade by "git pull", you can do it.
you create "giblognet.my.conf" copied from "giblognet.conf",
and do "git pull"

If you get a rainbow unicorn t-rex error after upgrading, you might be missing
a new CPAN dependency. Run again "setup.sh".

### I can't push large repository by http protocol

There are some reasons.

**1. Git version is old**

If you see "error: RPC failed; result=56, HTTP code = 200" , your git maybe old.
Please upgrade to latest git. I checked git version 1.8.5.5.

**2. Giblog Net restriction**

Giblog Net restrict max post message size 10MB(This is default of Mojolicious)

You maybe see the following error

    Delta compression using up to 4 threads.
    Compressing objects: 100% (17830/17830), done.
    Writing objects: 100% (18281/18281), 687.05 MiB | 129.92 MiB/s, done.
    Total 18281 (delta 295), reused 18281 (delta 295)
    error: RPC failed; result=22, HTTP code = 413
    fatal: The remote end hung up unexpectedly
    fatal: The remote end hung up unexpectedly

Please increase increase the value of MOJO_MAX_MESSAGE_SIZE
    
    # 1GB
    export MOJO_MAX_MESSAGE_SIZE=1024000000

**3. git restriction**

git restrict post max size via http protocol.
http.postBuffer value of git config is maybe small.

You maybe see the following error message.

    error: RPC failed; result=56, HTTP code = 200
    fatal: The remote end hung up unexpectedly
    Counting objects: 18281, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (17830/17830), done.
    Writing objects: 100% (18281/18281), 687.05 MiB | 133.23 MiB/s, done.
    Total 18281 (delta 295), reused 18281 (delta 295)
    fatal: The remote end hung up unexpectedly
    Everything up-to-date

Please increase the value of http.postBuffer.
    
    # 1GB
    git config http.postBuffer 1024000000

### How to use reverse proxy?

You can use Giblog Net via reverse proxy access

         ----------------------------     ------------
    ---->| Web Server(Reverse proxy)|---->|Giblog Net   |
    <----| (Apache, etc)            |<----|          |
         ----------------------------     ------------

I show apache config example.
You can use Name virtual host.
    
    # HTTP
    <VirtualHost *:80>

      ServerName myhost.com
      <Proxy *>
        Order deny,allow
        Allow from all
      </Proxy>
      
      ProxyRequests Off
      ProxyPreserveHost On
      ProxyPass / http://localhost:10020/ keepalive=On
      ProxyPassReverse / http://localhost:10020/
      RequestHeader set X-Forwarded-Proto "https"
        
    </VirtualHost>

If you use Giblog Net via https, you should set X-Forwarded-HTTPS Request Header.

    # HTTPS
    <VirtualHost *:443>

      ServerName myhost.com
      <Proxy *>
        Order deny,allow
        Allow from all
      </Proxy>
      
      ProxyRequests Off
      ProxyPreserveHost On
      ProxyPass / http://localhost:10020/ keepalive=On
      ProxyPassReverse / http://localhost:10020/
      RequestHeader set X-Forwarded-Proto "https"
    </VirtualHost>

### How to use reverse proxy with sub directory?

Giblog Net support reverse proxy with sub directory.

At first, set [reverse_proxy]path_depth option.

    [reverse_proxy]

    ;;; Reverse proxy path depth (default: none)
    ;;; If proxy path is http://somehost.com/foo, you set path_depth to 1.
    ;;; If proxy path is http://somehost.com/foo/bar, you set path_depth to 2.
    path_depth=1

Next you set http server config file. The following is apache example.

    <VirtualHost *:80>
      ServerName perlcodesample.com
      <Proxy *>
        Order deny,allow
        Allow from all
      </Proxy>
      ProxyRequests Off
      ProxyPreserveHost On

      ProxyPass /app1 http://localhost:10020/app1 keepalive=On
      ProxyPassReverse /app1 http://localhost:3000/app1

      ProxyPass /app2 http://localhost:10021/app2 keepalive=On
      ProxyPassReverse /app2 http://localhost:3001/app2
      
      RequestHeader set X-Forwarded-Proto "https"
    </VirtualHost>

### How to import already existing repositories?

You can import already existing repositories by **script/import_rep** script.

    cd script
    ./import_rep -u kimoto rep_dir

**-u** is user name. rep_dir must contains git respoitories like the following.

    rep_dir/project1.git
           /project2.git
           /project3.git
           /project3.git

If **description** file exists in git repository, it is copied.

### I can't add more than one collaborator

This is a Giblog Net bug before version 1.5.1.
Please use after version 1.5.2.

If you continue to use Giblog Net before version 1.5.1,
collaboration table is broken.
Please fix it the following way.

    # Run SQLite client
    sqlite3 data/giblognet.db
    
    # drop collaboration table
    drop table collaboration;
    
    # Restart
    ./giblognet

### I want to set time zone.

OK. Giblog Net supports time zones. You can set time_zone option in conig file.

    [basic]
    ;;; Time Zone
    ;;; Giblog Net time zone is GMT by default
    ;;; You can set your local time zone.
    time_zone=+9:00

### How to hide user home directory in ssh repository URL?

**1. Use symbolic link and ssh_rep_url_base option**

At first, set [basic]ssh_rep_url_base option to /~/git

    ;;; SSH repository url base
    ; For exampke, If you set this value to /~/git, SSH repository url become
    ; ssh://giblognet@59.106.185.196/~/git/kimoto/giblognet.git
    ; ~ is exapned to user home directory automatically
    ssh_rep_url_base=/~/git

Next, you create symbolic link to /home/giblognet/giblognet/data/rep
    
    cd ~
    ln -s ~/giblognet/data/rep ~/git

**2. Use only public key authentication and set [basic]ssh_rep_url_base to empty**

If you use only public key authentication, you can access ssh repository
using the following url.

    ssh://kimoto@59.106.185.196/kimoto/giblognet.git

If you set [basic]ssh_rep_url_base to empty string, this URL is shown on Browser.

    ;;; SSH repository url base
    ; For exampke, If you set this value to /git, SSH repository url become
    ; ssh://kimoto@59.106.185.196/git/kimoto/giblognet.git
    ssh_rep_url_base=

### How to get atom feed of commits page

You can get atom feed of commits page by the following URL

    http://somehost.com/kimoto/giblognet/commits/master.atom

### How to run Giblog Net from root user

You can manage the application from the root user.

Start the application

    sudo -u giblognet /home/giblognet/giblognet/giblognet

Stop the application

    sudo -u giblognet /home/giblognet/giblognet/giblognet --stop

If you want to start the application when the OS starts,
add the start application command to **rc.local**(Linux).

If you want to make it easy to manage giblognet,
then create a run script.

    mkdir -p /webapp
    echo '#!/bin/sh' > /webapp/giblognet
    echo 'su - giblognet -c "/home/giblognet/giblognet/giblognet $*"' >> /webapp/giblognet
    chmod 755 /webapp/giblognet

You can start and stop the application with the following command.

    # Start or Restart
    /webapp/giblognet

    # Stop
    /webapp/giblognet --stop

### I want to use Giblog Net on Perl 5.8.7 system

Giblog Net 2.0 dropped support for Perl 5.8.7 because latest Mojolicious doesn't support Perl 5.8.

You can choose between those options:

**1. use Giblog Net 1.xx**

Giblog Net 1.xx support Perl 5.8.7+. You can use Giblog Net v1.12.

https://github.com/yuki-kimoto/giblognet/archive/v1.12.tar.gz

You can see version 1.12 document.

[Giblog Net version 1 Document](old/README_v1.md)

**2. You can install your local perl by perlbrew.**

http://perlbrew.pl/

perlbrew is a very useful perl installation tool without breaking your system perl.

If you install perl 5.10.1+ with perlbrew, you can install latest Giblog Net.

### I know information about Giblog Net 2.0 upgrading.

If you use Giblog Net on Perl 5.8 and install newer perl with perlbrew,
you must remove extlib directory before running the "./setup_module" command.

  rm -rf extlib

You should know the following small changes.

**1. X-Forwarded-HTTPS header is deprecated. use  X-Forwarded-Proto header.**
    
    # This is deprecated in Giblog Net 2.0
    RequestHeader set X-Forwarded-HTTPS "1"
    
    # Use X-Forwarded-Proto instead
    RequestHeader set X-Forwarded-Proto "https"

**2. remove [basic]show_ignore_space_change_link option**

remove [basic]show_ignore_space_change_link option.
and move this feature to project settings page.

    # Go to settings page in your project
    /kimoto/giblognet/settings

**3. remove [basic]show_ignore_space_change_link option**

remove [basic]show_ignore_space_change_link option.
but enable this feature on in project settings page.

    # Go to settings page in your project
    /kimoto/giblognet/settings

**4. remove [basic]encoding_suspects option**

remove [basic]encoding_suspects option
and move this feature to project settings page.

    # Go to settings page in your project
    /kimoto/giblognet/settings

**5. mail is required for user registration.

mail address is require for user registration.

### Pull requests is removed when Giblog Net upgrade

Sorry, I found critical database specification mistake in Giblog Net from v2.0 to v2.2,
and fix it in v2.3.
All your pull requests is removed when upgrading from v2.0-v2.2 to v2.3+.
Please create Pull request again by the following command.
    
    old/fix_v2_pull_request data/giblognet.db

### Are there other ways to install Giblog Net?

**Sparrowdo**

You can use Sparrowdo to install Giblog Net on remote server ( by ssh ) or on running Docker container:

Here is example for Docker minimal Debian image:

    $ zef install Sparrowdo

    $ docker pull bitnami/minideb-extras 
    $ docker run --name instance0 -d bitnami/minideb-extras -expose=10020:10020  bash

    $ sparrowdo \
      --bootstrap
      --docker=instance1 \
      --no_sudo --sparrowfile=deploy/sparrowfile.install.pl6 \
      --format=production

    $ firefox 127.0.0.1:10020

And for remote server:

    $ sparrowdo \
      --bootstrap
      --host=$ipaddress \
      --no_sudo --sparrowfile=deploy/sparrowfile.install.pl6 \
      --format=production

    $ firefox $ipaddress:10020

Caveat - this installation method is only supported for Linux OS.

Follow [Sparrowdo](https://github.com/melezhik/sparrowdo) for the details.

**Dockerfile and docker-compose**

You can use Docker to build your own container based on Alpine Linux. This image configures SSHD to be run by user root and Giblog Net to be run by user giblognet.

    docker build ./deploy -t jndeverteuil/giblognet:latest

With that build, you can start a service with docker-compose:

    version: "3"

    services:
    giblognet:
        image: jndeverteuil/giblognet:latest
        container_name: giblognet
        hostname: giblognet
        restart: always
        ports:
        - "10020:10020"
        - "0.0.0.0:2222:22"
        volumes:
        - giblognet:/home/giblognet
        - sshd:/etc/ssh

    volumes:
    giblognet:
    sshd:

## For Developers

### Run Giblog Net in development mode

If you are a developer, you can start the application in development mode.

    ./morbo

Then access the following URL.

    http://localhost:3000

If you have git, it is easy to install from git.

    git clone git://github.com/yuki-kimoto/giblognet.git

It is useful to write configuration in ***giblognet.my.conf***, not giblognet.conf.

## The way to create installable Mojolicious application

Giblog Net is the best example for developers who want to create installabel Mojolicious application.

Even if shared hosting server, you can install Mojolicious application as CGI.

###1. cpanm and cpanfile, module installation and version control###

[Tatsuhiko Miyagawa](http://weblog.bulknews.net/)'s cpanm and cpanfile is the tool which install CPAN module easily.

**cpanm** is a command. It is **one file**. you can download cpanm easily and put it in your directory.

**cpanfile** is **a definition** of module name and version. you create the following file which name is "cpanfile".

    requires 'Time::HiRes', '== 1.9732';
    requires 'DBD::SQLite', '== 1.50';
    requires 'DBI', '== 1.634';
    requires 'DBIx::Connector', '== 0.53';
    requires 'Object::Simple', '== 3.14';
    requires 'DBIx::Custom', '== 0.36';
    requires 'Validator::Custom', '== 1.01';
    requires 'Config::Tiny', '== 2.23';
    requires 'Data::Page', '== 2.02';
    requires 'Data::Page::Navigation', '== 0.06';
    requires 'Mojolicious', '== 6.57';
    requires 'Mojolicious::Plugin::BasicAuth', '== 0.08';
    requires 'Mojolicious::Plugin::AutoRoute', '== 0.19';
    requires 'Mojolicious::Plugin::INIConfig', '== 0.03';
    requires 'Mojolicious::Plugin::DBViewer', '== 0.28';
    requires 'Text::Markdown::Hoedown', '== 1.01';
    requires 'Time::Moment', '== 0.38';

If you want to install all defined modules, you only run the following command.

    perl -Iextlib/lib/perl5 cpanm -L extlib --installdeps .

It's ok. but in some environment Module::CoreList is not installed, and latest ExtUtils::MakeMaker is needed for module installation.

I write the following way in "setup_module"

    perl cpanm -n -l extlib Module::CoreList
    perl -Iextlib/lib/perl5 cpanm -f -L extlib ExtUtils::MakeMaker
    perl -Iextlib/lib/perl5 cpanm -L extlib --installdeps .

###2. CGI is supported in Mojolicious

It is good luck for us that Mojolicious author [Sebastian Riedel](https://twitter.com/kraih) decided to **support CGI** in Mojolicious.

We can create web application which support CGI with a little effort.

All you do is always using **url_for** method or **url_with** method in your templates when you write URL.

    <a href="<%= url_for('/foo') %>">Bar</a>
    
    <a href="<%= url_with('/foo') %>">Bar</a>

Mojolicious automatically resolve URL for both embded server and CGI.

After that, you only prepare CGI script to call Mojolicious application in **production** mode.

    #!/usr/bin/env perl
    use FindBin;
    use lib "$FindBin::Bin/extlib/lib/perl5";

    $ENV{MOJO_MODE} = 'production';
    require "$FindBin::Bin/script/giblognet";

## Web Site

[Giblog Net Web Site](http://giblognet.yukikimoto.com/)

## Internally Using Modules

Giblog Net depends on the following modules, especially Mojolicious is the base of Giblog Net.
Thanks to Mojolicious author,[Sebastian riedel](https://twitter.com/kraih).

* [Mojolicious](http://search.cpan.org/~sri/Mojolicious/lib/Mojolicious.pm)
* [Mojolicious::Plugin::INIConfig](http://search.cpan.org/dist/Mojolicious-Plugin-INIConfig/lib/Mojolicious/Plugin/INIConfig.pm)
* [Mojolicious::Plugin::AutoRoute](http://search.cpan.org/dist/Mojolicious-Plugin-AutoRoute/lib/Mojolicious/Plugin/AutoRoute.pm)
* [Mojolicious::Plugin::BasicAuth](http://search.cpan.org/dist/Mojolicious-Plugin-BasicAuth/README.pod)
* [Mojolicious::Plugin::DBViewer](http://search.cpan.org/dist/Mojolicious-Plugin-DBViewer/lib/Mojolicious/Plugin/DBViewer.pm)
* [Object::Simple](http://search.cpan.org/dist/Object-Simple/lib/Object/Simple.pm)
* [Text::Markdown::Hoedown](http://search.cpan.org/~tokuhirom/Text-Markdown-Hoedown-1.01/lib/Text/Markdown/Hoedown.pm)
* [Validator::Custom](http://search.cpan.org/dist/Validator-Custom/lib/Validator/Custom.pm)
* [Time::Moment](http://search.cpan.org/dist/Time-Moment/lib/Time/Moment.pod)
* [Config::Tiny](http://search.cpan.org/dist/Config-Tiny/lib/Config/Tiny.pm)
* [DBD::SQLite](http://search.cpan.org/dist/DBD-SQLite/lib/DBD/SQLite.pm)
* [DBI](http://search.cpan.org/dist/DBI/DBI.pm)
* [DBIx::Connector](http://search.cpan.org/dist/DBIx-Connector/lib/DBIx/Connector.pm)
* [DBIx::Custom](http://search.cpan.org/dist/DBIx-Custom/lib/DBIx/Custom.pm)

## Sister project

These are my Perl web application projects.

* [WebDBViewer](https://github.com/yuki-kimoto/webdbviewer) - Database viewer to see database information on web browser.

## Bug

If you find bug, plese tell me on GitHub issue. Small bugs is OK! I'm pleasure if you report anything bugs.

Please post only bug information.

* [Github Issue](https://github.com/yuki-kimoto/giblognet/issues?state=open)

## Mailing list (Asking questions and feature requests)

* [Google Giblog Net Group](https://groups.google.com/forum/#!forum/giblognet)

You can ask questions about usage of Giblog Net in this mailing list.

If you want new features, please post the request to this mailing list.

## Author

Yuki Kimoto

[Yuki Kimoto Perl Blog](http://blogs.perl.org/users/yuki_kimoto/)

[Yuki Kimoto Twitter](https://twitter.com/yukikimoto2)

If you are interested in my project and activity, Please follow me on Twitter.

## Contributers

Thanks for helping my Giblog Net project.

* [maspalio](https://github.com/maspalio)
* [djzort](https://github.com/djzort)
* [SvenDowideit](https://github.com/SvenDowideit)
* [melezhik](https://github.com/melezhik)
* [spatil47](https://github.com/spatil47)
* [reneeb](https://github.com/reneeb)
* [tetsuh](https://github.com/tetsuh)
* [flixh](https://github.com/flixh)
* [kopytov](https://github.com/kopytov)
* [kberov](https://github.com/kberov)
* [deavmi](https://github.com/deavmi)
* [jackivan88](https://github.com/jackivan88)
* [mrmuskrat](https://github.com/mrmuskrat)
* [knittl](https://github.com/knittl)
* [programmerMOT](https://github.com/programmerMOT)
* [sn0](https://github.com/sn0)
* [socialmedialabs](https://github.com/socialmedialabs)
* [troneill](https://github.com/troneill)


## Copyright & license

Copyright 2012-2016 Yuki Kimoto. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
