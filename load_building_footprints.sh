#!/usr/bin/env bash

# Download building footprints from City of Chicago data portal and load them into PostgreSQL.

# Define variables.
DATA_URL="https://data.cityofchicago.org/api/geospatial/qv97-3bvb?method=export&format=Shapefile"
DATA_ZIP="building_footprints.zip"
DATA_FILE="buildings.shp"
DATA_DIR="data"
DB_NAME="city-of-big-data"

# Check to see if building footprints already downloaded from data portal.
# If not, get them and load them into PostgreSQL.
if [ ! -f $DATA_ZIP ]
then
	curl $DATA_URL > $DATA_ZIP
fi

# Unzip shapefile so shp2pgsql can use it
if [ ! -f $DATA_DIR/$DATA_FILE ]
then
	unzip $DATA_ZIP -d $DATA_DIR
fi

# Drop database if already there and create new one in postgres.
dropdb $DB_NAME
createdb $DB_NAME

# Spatially enable the database. If you don't do this, shp2pgsql fails.
psql --dbname $DB_NAME --command "CREATE EXTENSION postgis;"

# Drop building_footprints table if already there and load shapefile.
# -D load data in sql dump format, faster than insert statements.	
# -W specify LATIN1 encoding of data so it can be converted to UTF8.
shp2pgsql -d -c -D -W LATIN1 $DATA_DIR/$DATA_FILE | psql --dbname $DB_NAME