rm -rf pub/static/* var/view_preprocessed/* generated/* vendor/*
composer install --no-interaction --no-dev --prefer-dist --no-ansi
 bin/magento setup:di:compile
composer dump-autoload -o --apcu
bin/magento setup:static-content:deploy --ansi --no-interaction -f -t Mgs/claue en_US
bin/magento setup:static-content:deploy --ansi --no-interaction -f -t Mgs/claue_rtl en_US
bin/magento setup:static-content:deploy --ansi --no-interaction -f -t Mgs/mgsblank en_US
bin/magento setup:static-content:deploy -f
echo "Check setup:upgrade status"
# use --no-ansi to avoid color characters
message=$( bin/magento setup:db:status --no-ansi)
if [[ ${message:0:3} == "All" ]]; then
  echo "No setup upgrade - clear cache";
   bin/magento cache:clean
else
  echo "Run setup:upgrade - maintenance mode"
   bin/magento maintenance:enable
   bin/magento setup:upgrade --keep-generated
   bin/magento maintenance:disable
fi

