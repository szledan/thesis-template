#!/bin/bash

# Include argument parser.
. ./scripts/arg-parser.sh

# Set default values.
inDir=./build/paper/src
outDir=$inDir
inFile=szakdolgozat.pdf
outFile=grayscaled-$inFile
helpMsg="usage: "`basename $0`" input.pdf [out.pdf]"

# Check help flags.
if [[ $(getFlag "--help -h --usage" $@) ]] ; then
  echo $helpMsg;
  exit 0;
fi

# Get working directories.
inFile=$(getValue $1 "./$inDir/$inFile")
outFile=$(getValue $2 "./$outDir/$outFile")

# Check dependencies.
if ! which gs > /dev/null ; then
  echo "need to be installed: 'sudo apt install gs'"
  exit 1
fi

# Convert colored pdf to grayscaled one.
gs \
  -sOutputFile=$outFile \
  -sDEVICE=pdfwrite \
  -sColorConversionStrategy=Gray \
  -dProcessColorModel=/DeviceGray \
  -dCompatibilityLevel=1.4 \
  -dNOPAUSE \
  -dBATCH \
  $inFile

errorCode=$?

if [ "$errorCode" != "0" ] ; then
  echo "Error! (Code=$errorCode)"
else
  echo "Done!"
fi
