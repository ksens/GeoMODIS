# MODIS DEMO
Some demos using the NASA MODIS radar dataset (http://modis.gsfc.nasa.gov/)

## Note about different versions of SciDB
Currently works for SciDB 15.12. If you want to try with earlier versions, go back to the first commit"

## Retrieve the data
Expects the following data files (preloaded in the AMI):
```
load\
	places.csv
	granule1.csv
	granule2.csv
	granule4.csv
```

## Load the data
First load the data (preloaded in the AMI):
```
cd load
./load_all.sh
./load_places.sh
cd ..
```

## Demo
Next, open the demo file `modisDemo.R` in RStudio, source the file and run the following functions:
```
draw()
draw_regrid()
find_place('San Francisco')
```
