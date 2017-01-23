#!/bin/bash

if [[ "${1}" == "" || "${2}" == "" ]] ; then
  echo "usage $0 <svg-dir> <eps-dir>"
  exit 1
fi

if ! which inkscape > /dev/null ; then
  echo "need to be installed: inkscape"
  exit 1
fi

svgDir=$1
epsDir=$2

for svgFile in `ls $svgDir/*.svg` ; do
  svgBaseName=`basename $svgFile .svg`
  epsFile=$epsDir/`basename $svgBaseName _svg`_eps.eps
  echo "inkscape --export-margin=3mm $svgFile --export-eps=$epsFile"

  inkscape --export-margin=3mm $svgFile --export-eps=$epsFile
  errorCode=$?

  if [ "$errorCode" != "0" ] ; then
    echo "Error! (Code=$errorCode)"
  else
    echo "Done!"
  fi
done
