#!/bin/bash

me=`readlink -f $0`
# Absolute path this script is in, thus /home/user/bin
mydir=`dirname $me`

pushd $mydir > /dev/null
mydir=`pwd`

iquery -anq "remove(MODIS_DATA)" > /dev/null 2>&1
iquery -aq  "create array MODIS_DATA <altitude:double null> [latitude_e4=-900000:900000,20000,0, longitude_e4=-1800000:1800000,20000,0]"

iquery -anq "insert(
 redimension(
  apply(
   parse(
    split('$mydir/granule1.csv', 'header=1'), 
    'num_attributes=14',
    'attribute_delimiter=,'
   ),
   longitude_e4, dcast(a0,int64(null)),
   latitude_e4,  dcast(a1, int64(null)),
   altitude,     dcast(a7, double(null))
  ),
  MODIS_DATA,
  false
 ),
 MODIS_DATA
)"

iquery -anq "insert(
 redimension(
  apply(
   parse(
    split('$mydir/granule2.csv', 'header=1'), 
    'num_attributes=14',
    'attribute_delimiter=,'
   ),
   longitude_e4, dcast(a0,int64(null)),
   latitude_e4,  dcast(a1, int64(null)),
   altitude,     dcast(a7, double(null))
  ),
  MODIS_DATA,
  false
 ),
 MODIS_DATA
)"

iquery -anq "insert(
 redimension(
  apply(
   parse(
    split('$mydir/granule4.csv', 'header=1'), 
    'num_attributes=14',
    'attribute_delimiter=,'
   ),
   longitude_e4, dcast(a0,int64(null)),
   latitude_e4,  dcast(a1, int64(null)),
   altitude,     dcast(a7, double(null))
  ),
  MODIS_DATA,
  false
 ),
 MODIS_DATA
)"



