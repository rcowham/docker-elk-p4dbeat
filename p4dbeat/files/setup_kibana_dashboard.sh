#!/bin/bash
# Initialise Kibana dashboard - first waiting until it responds
# Primary usage of script is as part of Dockerfile

# Hostname for kibana - could be localhost
KIBANA_HOST=${1:-kibana}
# Default port
KIBANA_PORT=${2:-5601}
# JSON file - see below for how to create
DASHBOARD_JSON=${3:-/p4/api_dashboard.json}

until nc -zw 1 $KIBANA_HOST $KIBANA_PORT; do sleep 1; done

# Please note that the following file MUST have been created using the API.
# https://www.elastic.co/guide/en/kibana/current/dashboard-import-api-export.html
# 
# curl -X GET "http://localhost:5601/api/kibana/dashboards/export?dashboard=942dcef0-b2cd-11e8-ad8e-85441f0c2e5c" -H 'kbn-xsrf: true'
#
# Obviously substitute appropriate UUID - which turns out not to be so easy to find via API.
#
# If you attempt to use a file that was exported using the web UI it will not work since
# Elastic in their wisdom have made the formats close but not the same!!

URL="http://$KIBANA_HOST:$KIBANA_PORT"

# In the below it might say "?exclude=index-pattern" but we explicitly want the index
# created.

curl -X POST -H "Content-Type: application/json" -H "kbn-xsrf: true" "$URL/api/kibana/dashboards/import?exclude=some-pattern" -d @${DASHBOARD_JSON}

# Finally having imported dashboard we extract index pattern it contained and set it to be default
index_id=$(grep -B1 "index-pattern" $DASHBOARD_JSON | grep '"id"' | sed -e 's/.*: "//' -e 's/",//')

curl -X POST -H "Content-Type: application/json" -H "kbn-xsrf: true" "$URL/api/kibana/settings/defaultIndex" -d '{"value": "$index_id"}' 
