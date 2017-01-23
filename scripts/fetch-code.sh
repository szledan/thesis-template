#!/bin/bash

# Get repository.
if [[ "${1}" == "--help" || "${1}" == "-h" ]] ; then
  echo "usage fetch-code.sh [<git-repository> [<tag>]]"
  exit 0
fi

# Get git tag name.
gitTag=master
if [ "${2}" != "" ] ; then
  gitTag=${2}
fi

# Get repository.
repository="git@github.com:szledan/gepard.git"
if [ "${1}" != "" ] ; then
  repository=${1}
fi

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
  echo Done!
else
  echo "Error! (Code: $errorCode.)"
fi
