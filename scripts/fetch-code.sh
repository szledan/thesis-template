#!/bin/bash

# Include argument parser.
. ./scripts/arg-parser.sh

# Set default values.
repository="git@github.com:szledan/gepard.git"
gitTag=master
helpMsg="usage "`basename $0`" --repo=<git-repository> --tag=<tag>"

# Show help.
if [[ $(getFlag "--help -h --usage" $@) ]] ; then
  echo $helpMsg
  exit 0
fi

# Parse flags.
repository=$(getValue $(getFlag "--repo" $@) $repository)
gitTag=$(getValue $(getFlag "--tag" $@) $gitTag)

# Define variables.
codeName=`basename $repository .git`
codeDir="$PWD/code"
codeRootDir="$codeDir/$codeName"

# Create directoryy if neede.
mkdir -p $codeDir
cd $codeDir
errorCode=$?

# Clone repository.
if [[ "$errorCode" == "0" && ! -d $codeRootDir ]] ; then
  git clone $repository $codeRootDir
  errorCode=$?
fi

# Checkout to tag.
if [ "$errorCode" == "0" ] ; then
  cd $codeRootDir
  git checkout $gitTag
  errorCode=$?
fi

if [ "$errorCode" == "0" ]; then
  echo "Done!"
else
  echo "Error! (Code: $errorCode.)"
fi
