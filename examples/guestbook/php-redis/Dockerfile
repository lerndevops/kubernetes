FROM php:5-apache

RUN pear channel-discover pear.nrk.io
RUN pear install nrk/Predis

# If the container's stdio is connected to systemd-journald,
# /proc/self/fd/{1,2} are Unix sockets and apache will not be able to open()
# them. Use "cat" to write directly to the already opened fds without opening
# them again.
RUN sed -i 's#ErrorLog /proc/self/fd/2#ErrorLog "|$/bin/cat 1>\&2"#' /etc/apache2/apache2.conf
RUN sed -i 's#CustomLog /proc/self/fd/1 combined#CustomLog "|/bin/cat" combined#' /etc/apache2/apache2.conf

ADD guestbook.php /var/www/html/guestbook.php
ADD controllers.js /var/www/html/controllers.js
ADD index.html /var/www/html/index.html
