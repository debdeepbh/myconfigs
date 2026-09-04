# Very light http server: lightpd
 
 https://wiki.archlinux.org/index.php/lighttpd
 pacman -S lighttpd
 
 Config: /etc/lighttpd/lighttpd.conf
 Check if config file's syntax is correct: lighttpd -t -f /etc/lighttpd/lighttpd.conf
 Default location of index.html file: /srv/http
 
 To create the index.html file:
 echo 'TestMe!' >> /srv/http/index.html
 chmod 755 /srv/http/index.html
 
 Starting and reloading:
 systemctl start lighttpd
 systemctl reload lighttpd
 
 Enabling over boot: systemctl enable lighttpd

 To enable php, install php, php-cgi and then add the following to /etc/lighttpd/lighttpd.conf (Note: not inside conf.d/fastcgi.conf etc, unlike what the arch wiki for lighttpd says):
  Make sure to install php and php-cgi. See:                                                             
  https://wiki.archlinux.org/index.php/Fastcgi_and_lighttpd#PHP
  
```
  server.modules += ("mod_fastcgi")
  

  # FCGI server
  # ===========
  #
  # Configure a FastCGI server which handles PHP requests.
  #
  index-file.names += ("index.php")
  fastcgi.server = ( 
      # Load-balance requests for this path...
      ".php" => (
          # ... among the following FastCGI servers. The string naming each
          # server is just a label used in the logs to identify the server.
          "localhost" => ( 
              "bin-path" => "/usr/bin/php-cgi",
              "socket" => "/tmp/php-fastcgi.sock",
              # breaks SCRIPT_FILENAME in a way that PHP can extract PATH_INFO
              # from it 
              "broken-scriptfilename" => "enable",
              # Launch (max-procs + (max-procs * PHP_FCGI_CHILDREN)) procs, where
              # max-procs are "watchers" and the rest are "workers". See:
              # https://redmine.lighttpd.net/projects/1/wiki/frequentlyaskedquestions#How-many-php-CGI-processes-will-lighttpd-spawn 
              "max-procs" => 4, # default value
              "bin-environment" => (
                  "PHP_FCGI_CHILDREN" => "1" # default value
              )
          )
      )   
  )
 
```
 
 Finally, set  in /etc/php/php.ini
  cgi.fix_pathinfo = 1
 and systemctl reload lighttpd.service to have the effect of this new setting and test it works by the following php file content:
 <?php
 phpinfo();
 ?>

 To give php read/write access to a particular directory called 'data', do the following
 Find the user that runs the http process by
 ps aux | grep httpd
 In my case, the user is http and root. I'll give the access to http.
 (internet suggests other keywords such as www-data etc)
 Make the user owner of the directory 
 chown -R http:http /path/to/directory/data

 Displaying console output while running shell commands thorough shell_exec() in php: add 2>&1 at the end of the shell command.
 

 Error code display while running php:
 This is very useful while debugging but very dangerous while running because it is possible to figure out code from error messages. 

 Edit /etc/php/php.ini
 Change the line 
  display_errors = Off
 to
  display_errors = On
 Important: Do not forget to revert it later.

 Another way is to add the following codes to your php files:
 echo ('showing errors!');
 ini_set('display_errors', 1);
 ini_set('display_startup_errors', 1);
 error_reporting(E_ALL);


