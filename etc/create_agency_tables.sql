﻿/*
	This script defines/creates the necessary database schema. It uses psql 
	variables and should be run with psql on a PostgreSQL database with 
	PostGIS installed. You'll need to set the projection for your region 
	and optionally provide a table name prefix or otherwise change the table 
	names to distinguish among agencies within a database.
*/

-- this should be a meter based projection like UTM
\set EPSG 26917
-- set your table names here, and again in config.py
\set stops_table       prefix_stops
\set directions_table  prefix_directions
\set trips_table       prefix_trips
\set stop_times_table  prefix_stop_times

/*
	equivalent to GTFS stops table
*/
DROP TABLE IF EXISTS :stops_table;
CREATE TABLE :stops_table (
	uid serial PRIMARY KEY,
	stop_id varchar,
	stop_name varchar, -- required
	stop_code integer, -- public_id
	lon numeric,
	lat numeric,
	the_geom geometry( POINT, :EPSG ),
	report_time double precision, -- epoch time
	active boolean DEFAULT TRUE -- debugging flag
);
CREATE INDEX ON :stops_table (stop_id);


/*
	Similar to GTFS trips table, in that it stores sequences of 
	stops to be served by a trip and these can be matched to a 
	direction_id on a particular vehicle
*/
DROP TABLE IF EXISTS :directions_table;
CREATE TABLE :directions_table (
	uid serial PRIMARY KEY,
	route_id varchar,
	direction_id varchar,
	title varchar,
	name varchar,
	branch varchar,
	useforui boolean,
	stops text[],
	report_time double precision -- epoch time
);
CREATE INDEX ON :directions_table (direction_id);

/*
	Data on vehilce locations fetched from the API gets stored here along 
	with map-matched geometries. When extracted into GTFS, most feilds here 
	are ignored. "Trips" are the primary object of the data processing sequence.  
*/
DROP TABLE IF EXISTS :trips_table;
CREATE TABLE :trips_table (
	trip_id integer PRIMARY KEY,
	orig_geom geometry( LINESTRING, :EPSG ),	-- geometry of all points
	times double precision[], -- sequential report_times, corresponding to points on orig_geom
	route_id varchar,
	direction_id varchar,
	service_id smallint,
	vehicle_id varchar,
	block_id integer,
	match_confidence real,
	ignore boolean DEFAULT TRUE,	-- this trip has not been processed or has been unsucessfully
	-- debugging fields
	match_geom geometry( MULTILINESTRING, :EPSG ), -- map-matched route geometry
	clean_geom geometry( LINESTRING, :EPSG ), -- geometry of points used in map matching
	problem varchar DEFAULT '', -- description of any problems that arise
	active boolean DEFAULT TRUE -- debugging flag
);
CREATE INDEX ON :trips_table (trip_id);

/*
	Where interpolated stop times are stored for each trip. 
*/
DROP TABLE IF EXISTS :stop_times_table;
CREATE TABLE :stop_times_table (
	trip_id integer,
	stop_id varchar,
	stop_sequence integer,
	etime double precision -- non-localized epoch time in seconds
);
CREATE INDEX ON :stop_times_table (trip_id);
