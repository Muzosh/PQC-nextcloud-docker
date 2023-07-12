# Example commands one would like to run after Nextcloud installation:
# GENERAL
php /var/www/html/occ config:system:set --type string --value files defaultapp

# LOGGING
php /var/www/html/occ config:system:set --type integer --value 1 log_level
php /var/www/html/occ config:system:set --type string --value "d.m.Y - H:i:s" logdateformat

# APPS
php /var/www/html/occ app:enable admin_audit
php /var/www/html/occ app:disable dashboard
php /var/www/html/occ app:disable firstrunwizard
php /var/www/html/occ app:disable survey_client

# ADD TESTUSER AND ENABLE WEBEID FOR HIM
# add testuser
export OC_PASS=testuser
php /var/www/html/occ user:add --password-from-env --display-name=testuser testuser

# install composer and twofactor_webeid dependecies
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
composer install --no-dev -d /var/www/html/custom_apps/twofactor_webeid/

# Enable twofactor_webeid, enable it for testuser and set his subject_cn for successfull login
php /var/www/html/occ app:enable twofactor_webeid
php /var/www/html/occ twofactorauth:enable testuser twofactor_webeid
php /var/www/html/occ user:setting testuser twofactor_webeid subject_cn "testuser