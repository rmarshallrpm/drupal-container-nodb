FROM centurylink/apache-php:latest
MAINTAINER CenturyLink

# Install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor pwgen && \
  apt-get -y install mysql-client && \
  apt-get -y install postgresql-client
  
# Download v8.3.1 of Drupal into /app
RUN rm -fr /app && mkdir /app && cd /app && \
  curl -O https://ftp.drupal.org/files/projects/drupal-8.3.1.tar.gz && \
  tar -xzvf drupal-8.3.1.tar.gz && \
  rm drupal-8.3.1.tar.gz && \
  mv drupal-8.3.1/* drupal-8.3.1/.htaccess ./ && \
  mv drupal-8.3.1/.gitignore ./ && \
  rmdir drupal-8.3.1  

#Config and set permissions for setting.php
RUN cp app/sites/default/default.settings.php app/sites/default/settings.php && \
    chmod a+w app/sites/default/settings.php && \
    chmod a+w app/sites/default

EXPOSE 80

CMD exec supervisord -n
