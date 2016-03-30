#!/bin/bash
iquery -aq "remove(MODIS_PLACES)" > /dev/null
iquery -aq "create array MODIS_PLACES
<FEATURE_ID:string null,
 FEATURE_NAME:string null,
 FEATURE_CLASS:string null,
 STATE_ALPHA:string null,
 STATE_NUMERIC:string null,
 COUNTY_NAME:string null,
 COUNTY_NUMERIC:string null,
 PRIMARY_LAT_DMS:string null,
 PRIM_LONG_DMS:string null,
 PRIM_LAT_DEC:string null,
 PRIM_LONG_DEC:string null,
 SOURCE_LAT_DMS:string null,
 SOURCE_LONG_DMS:string null,
 SOURCE_LAT_DEC:string null,
 SOURCE_LONG_DEC:string null,
 ELEV_IN_M:string null,
 ELEV_IN_FT:string null,
 MAP_NAME:string null,
 DATE_CREATED:string null,
 DATE_EDITED:string null>
[i=0:*,10000,0]"

iquery -anq "
store(
 project(
  unpack(
   apply(
    parse(
     split('/home/scidb/modis/places2.csv', 'header=1'),
     'num_attributes=20',
     'attribute_delimiter=,'
    ),
    FEATURE_ID, a0 ,
    FEATURE_NAME, a1 ,
    FEATURE_CLASS, a2 ,
    STATE_ALPHA, a3 ,
    STATE_NUMERIC, a4 ,
    COUNTY_NAME, a5 ,
    COUNTY_NUMERIC, a6 ,
    PRIMARY_LAT_DMS, a7 ,
    PRIM_LONG_DMS, a8 ,
    PRIM_LAT_DEC, a9 ,
    PRIM_LONG_DEC, a10 ,
    SOURCE_LAT_DMS, a11 ,
    SOURCE_LONG_DMS, a12 ,
    SOURCE_LAT_DEC, a13 ,
    SOURCE_LONG_DEC, a14 ,
    ELEV_IN_M, a15 ,
    ELEV_IN_FT, a16 ,
    MAP_NAME, a17 ,
    DATE_CREATED, a18 ,
    DATE_EDITED, a19 
   ),
   i,
   10000
  ),
  FEATURE_ID,
  FEATURE_NAME,
  FEATURE_CLASS,
  STATE_ALPHA,
  STATE_NUMERIC,
  COUNTY_NAME,
  COUNTY_NUMERIC,
  PRIMARY_LAT_DMS,
  PRIM_LONG_DMS,
  PRIM_LAT_DEC,
  PRIM_LONG_DEC,
  SOURCE_LAT_DMS,
  SOURCE_LONG_DMS,
  SOURCE_LAT_DEC,
  SOURCE_LONG_DEC,
  ELEV_IN_M,
  ELEV_IN_FT,
  MAP_NAME,
  DATE_CREATED,
  DATE_EDITED
 ),
 MODIS_PLACES
)"
