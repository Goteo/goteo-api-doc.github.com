#/bin/bash

API='https://api.goteo.org/v1/'

while [[ $# > 1 ]]; do
key="$1"

case $key in
    -u|--user)
    OPTIONS="--user $2"
    shift # past argument
    ;;
    -b|--bearer)
    OPTIONS="--H 'Authorisation: Bearer $2'"
    shift # past argument
    ;;
    -a|--api)
    API="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

if [ -z "$OPTIONS" ] || [ -z "$API" ]; then
	echo "Usage:"
	echo ""
	echo "$0 [--user][-u] apiuser:apisecret [--bearer][-b] XXXXX  [--api][-a] api_url "
	exit 2
fi

function save {
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo "ERROR: specify the API path as first argument and json name as second"
		exit 2
	fi

	url=$API$1
	response=$(curl $OPTIONS --write-out %{http_code} --silent --output /dev/null $url)
	if [ "$response" != "200" ]; then
		echo "Response code error [$response] in [$url]"
		echo "Aborting... Please check credentials!"
		exit 2
	fi
	curl $OPTIONS --silent $url > _json/$2.json
	echo "Generated _json/$2.json"
}


save spec swagger_specs
save projects/ projects
save projects/llevamealhuerto project
save users/ users
save users/goteo user
save categories/ categories
save licenses/ licenses

