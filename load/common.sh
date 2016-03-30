#!/bin/bash

##Chunk sizes
CS_VEHICLE_ID=10000
CS_EVENT_ID=10000
CS_TRIP_ID=5000
CS_TRIP_SECOND=100000

##One-dimensional load chunk size
LOAD_CHUNK_SIZE=500000

#Function cleanup. This function is executed whenever the user issues ctrl+c or kill's the script.
#The command "kill -9" is special and won't be handled by this function
trap cleanup 1 2 3 6 15
cleanup()
{
  echo "Caught signal. Exiting"
  #Note: you may or may not want to remove temp arrays here. 
  #One problem is that remove might block. So it's safer not doing it.
  exit 1;
}

#Function afl_n():
#Run an AFL command, do not output the result
#If an error occurs - abort the script
afl_n()
{
  iquery -anq "$1"
  if [ $? -ne 0 ]; then
    echo "Error running query \"$1\". Terminating script."
    exit 1;
  fi
}

load_from_csv()
{
  echo Removing old copy of $ARRAY
  iquery -aq "remove($ARRAY)" > /dev/null 2>&1
  echo Creating $ARRAY
  afl_n "create empty array $ARRAY $SCHEMA [entryID=0:*,$LOAD_CHUNK_SIZE,0]"

  echo Loading $ARRAY
  PIPE=/tmp/load.pipe.$ARRAY
  rm -f $PIPE
  mkfifo $PIPE
  csv2scidb -s 1 -c $LOAD_CHUNK_SIZE -p $FORMAT < $FILE > $PIPE &
  sleep 2
  time afl_n "load($ARRAY, '$PIPE')"
  rm -f $PIPE
}
