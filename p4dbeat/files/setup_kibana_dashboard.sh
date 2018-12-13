#!/bin/bash
# Initialise Kibana dashboard

KIBANA_HOST=${1:-kibana}
KIBANA_PORT=${2:-5601}
DASHBOARD_JSON=${3:-/p4/api_dashboard.json}

until nc -zw 1 $KIBANA_HOST $KIBANA_PORT; do sleep 1; done

URL="http://$KIBANA_HOST:$KIBANA_PORT"

curl -X POST -H "Content-Type: application/json" -H "kbn-xsrf: true" "$URL/api/kibana/dashboards/import?exclude=some-pattern" -d @${DASHBOARD_JSON}

curl -X POST -H "Content-Type: application/json" -H "kbn-xsrf: true" "$URL/api/kibana/settings/defaultIndex" -d '{"value": "ff817440-fee5-11e8-be70-8997336355d9"}' 

