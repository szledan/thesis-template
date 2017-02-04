#!/bin/bash

# Include argument parser.
. ./scripts/arg-parser.sh

# Set default values.
svgDir=./paper/src/svg
epsDir=./paper/src/img
margin=3mm
helpMsg="usage: "`basename $0`" [--export-margin=3mm] --svg=<$svgDir> --eps=<$epsDir>"

# Check help flags.
if [[ $(getFlag "--help -h --usage" $@) ]] ; then
  echo $helpMsg;
  exit 0;
fi

# Read flags.
margin=$(getValue $(getFlag "--export-margin" $@) $margin)

# Get working directories.
svgDir=$(getValue $(getFlag "--svg" $@) $svgDir)
epsDir=$(getValue $(getFlag "--eps" $@) $epsDir)
if [[ ! -d "$svgDir" || ! -d "$epsDir" ]] ; then
  echo "One of the directories does not exist!";
  echo $helpMsg;
  exit 1
fi

# Check dependencies.
if ! which inkscape > /dev/null ; then
  echo "need to be installed: 'sudo apt install inkscape'"
  exit 1
fi

# Convert 'svg' to 'eps'.
for svgFile in `ls $svgDir/*.svg` ; do
  svgBaseName=`basename $svgFile .svg`
  epsFile=$epsDir/`basename $svgBaseName _svg`_eps.eps
  echo "inkscape --export-margin=$margin $svgFile --export-eps=$epsFile"

  inkscape --export-margin=$margin $svgFile --export-eps=$epsFile
  errorCode=$?

  if [ "$errorCode" != "0" ] ; then
    echo "Error! (Code=$errorCode)"
  else
    echo "Done!"
  fi
done
