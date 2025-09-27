#!/bin/sh

# Download elasticsearch index if missing
if [ ! -d "/photon/photon_data/elasticsearch" ]; then
    echo "Downloading search index to /photon/photon_data"

    # Create data directory if it doesn't exist
    if [ ! -d "/photon/photon_data" ]; then
        echo "Creating /photon/photon_data directory"
        mkdir -p /photon/photon_data
    fi

    # Change to data directory before extracting
    cd /photon/photon_data || exit 1

    # Let graphhopper know where the traffic is coming from
    USER_AGENT="docker: photon-geocoder"
    # If you want to install a specific region only, enable the line below and disable the current 'wget' row.
    # See http://download1.graphhopper.com/public/extracts/by-country-code
    # wget --user-agent="$USER_AGENT" -O - http://download1.graphhopper.com/public/extracts/by-country-code/nl/photon-db-nl-latest.tar.bz2 | lbzip2 -cd | tar x
    wget --user-agent="$USER_AGENT" -O - http://download1.graphhopper.com/public/photon-db-latest.tar.bz2 | lbzip2 -cd | tar x

    # Return to photon directory
    cd /photon || exit 1
fi

ls -la /photon/photon_data

# Start photon if elastic index exists
if [ -d "/photon/photon_data/elasticsearch" ]; then
    echo "Start photon with configuration:"
    echo "  Host: 0.0.0.0"
    echo "  Port: 2322"
    echo "  Data directory: /photon/photon_data"
    echo "  Additional arguments: $@"
    exec java -jar photon.jar -host 0.0.0.0 -port 2322 -data-dir /photon/photon_data "$@"
else
    echo "Could not start photon, the search index could not be found"
    exit 1
fi
