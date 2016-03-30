# MODIS DEMO
Some demos using the NASA MODIS radar dataset

## Retrieve the data
Expects the following data files:
```
load\
	places.csv
	granule1.csv
	granule2.csv
	granule3.csv
```

## Load the data
First load the data:
```
cd load
./load_all.sh
./load_places.sh
```

## Demo
Next, open the demo file in RStudio, source the file and run the following functions:
```
draw()
draw_regrid()
find_place('San Francisco')
```
