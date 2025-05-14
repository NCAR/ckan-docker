
# Add API token to admin user, so we can create an Organization, thereby allowing creation of a WAF.
if [ ! -d "/tmp/apikey.txt" ]; then
    ckan -c ~/ckan.ini user token add ckan_admin api-token | tail -1 | xargs > /tmp/apikey.txt
    apiKey=`cat /tmp/apikey.txt`
    wget 'http://localhost/api/3/action/organization_create'
fi



# Create web-accessible folder structure
if [ ! -d "/var/www/html/sagedev-dset-harvest-test" ]; then
    cd /var/www/html
    git clone https://github.com/NCAR/sagedev-dset-harvest-test.git
    ckan -c ~/ckan.ini harvester source create "mini-waf" "http://localhost:9000/sagedev-dset-harvest-test" "waf" "MINI WAF" "TRUE" "ncar" "MANUAL" '{"user" : "ckan_admin", "read_only": true}'
    ckan -c ~/ckan.ini harvester run-test mini-waf
fi

