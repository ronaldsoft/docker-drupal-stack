#!/bin/bash
#
# Drupal container entrypoint.
#
# This entrypoint script will create a new Drupal codebase if one is not already
# present in the DOCUMENT_ROOT directory.

set -e

# Allow container to specify skipping cert validation.
DRUPAL_DOWNLOAD_VERIFY_CERT=${DRUPAL_DOWNLOAD_VERIFY_CERT:-true}

# Drupal URLs and version options.
DRUPAL_DOWNLOAD_URL="https://ftp.drupal.org/files/projects/drupal-8.9.3.tar.gz"

# Project directories.
DOCUMENT_ROOT=${DOCUMENT_ROOT:-$DOCUMENT_ROOT}

# Download Drupal to $DOCUMENT_ROOT if it's not present.
if [ ! -f $DOCUMENT_ROOT/index.php ]; then

  cd $DOCUMENT_ROOT
  echo "Downloading Drupal..."
  if [ $DRUPAL_DOWNLOAD_VERIFY_CERT = true ]; then
    curl -sSL $DRUPAL_DOWNLOAD_URL | tar -xz --strip-components=1
  else
    curl -sSLk $DRUPAL_DOWNLOAD_URL | tar -xz --strip-components=1
  fi

  mkdir -p /var/www/config/sync
  chmod -R 777 /var/www/config/sync
  echo "Download complete!"

  echo "Configuring settings.php with environment variables..."
  cp $DOCUMENT_ROOT/sites/default/default.settings.php $DOCUMENT_ROOT/sites/default/settings.php
  cat <<EOF >> $DOCUMENT_ROOT/sites/default/settings.php
\$databases['default']['default'] = array (
  'database' => '$DB_NAME',
  'username' => '$DB_USER',
  'password' => '$DB_PASS',
  'prefix' => '',
  'host' => '$DB_HOST',
  'port' => '3306',
  'namespace' => 'Drupal\\\\Core\\\\Database\\\\Driver\\\\mysql',
  'driver' => 'mysql',
);
\$config_directories['sync'] = '../config/sync';
\$settings['hash_salt'] = '$DRUPAL_HASH_SALT';
EOF

  echo "Correcting permissions on /var/www..."
  chown -R www-data:www-data /var/www

  echo "Drupal codebase ready!"
fi

exec "$@"
