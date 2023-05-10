# https://catalog.redhat.com/software/containers/search
# Using Red Hat base images, which is better than using outdated, always changing CentOS
FROM registry.access.redhat.com/ubi8/ubi:8.7

# Log the OS Details of the container image
RUN cat /etc/os-release

# customary update before we install additional packages
RUN dnf update -y \
    && dnf install -y make unzip

# Enable required php version
RUN dnf module list php
RUN dnf module enable -y php:8.0

# Install php and basic modules
RUN dnf install -y php \
    && dnf install -y php-json php-mbstring php-xml php-pdo php-pear php-devel \
    && php -m \
    && php -i | grep -i "Loaded Configuration File"

# Installing composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && mv composer.phar /usr/local/bin/composer \
    && php -r "unlink('composer-setup.php');" \
    && composer --version 

