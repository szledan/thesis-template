#!/bin/bash

# Set default values.
_svgDir=./paper/src/svg
_imgDir=./paper/src/img
_epsDir=./paper/src/eps

_err=0
_inkscapeOpts=" --export-area-drawing --export-margin=0mm "
# Parse arguments
_ai=1
_an=$#
while [ ${_ai} -le ${_an} ] ; do
  case ${1} in
    "-h" | "--help")
      echo "Usage: ${0} [OPTION] [-- INKSCAPE_OPTIONS]"
      echo ""
      echo "Option:"
      echo "  -h, --help           show this help"
      echo "  -H, --inkscape-help  show the help of 'inkscape'"
      echo "  -sd, --svg-dir PATH  set the svg input directory, default: '$_svgDir'"
      echo "  -id, --img-dir PATH  set the image input directory, default: '$_imgDir'"
      echo "  -ed, --eps-dir PATH  set the eps output directory, default: '$_epsDir'"
      echo ""
      echo "Default inkscape options: ${_inkscapeOpts}"
      exit 0;;
    "-H" | "--inkscape-help")
      inkscape --help
      exit 0;;
    "-sd" | "--svg-dir")
      _ai=$((_ai + 1)); shift 1
      _svgDir=${1}
      ;;
    "-id" | "--img-dir")
      _ai=$((_ai + 1)); shift 1
      _imgDir=${1}
      ;;
    "-ed" | "--eps-dir")
      _ai=$((_ai + 1)); shift 1
      _epsDir=${1}
      ;;
    "--")
      _ai=$((_ai + 1)); shift 1
      _inkscapeOpts=${@}
      break;;
  esac
  _ai=$((_ai + 1)); shift 1
done

# Check dependencies.
if ! which inkscape > /dev/null ; then
  echo "Need to be installed 'inskcape'. 'sudo apt install inkscape'"
  exit 1
fi

mkdir -p ${_epsDir}
# Get working directories.
if [[ ! -d "${_svgDir}" || ! -d "${_imgDir}" ]] ; then
  echo "One of the directories does not exist!";
  exit 1
fi

# Convert 'svg' and 'images' to 'eps'.
for _file in `ls ${_svgDir}/*.svg ${_imgDir}/*` ; do
  _baseName="${_file##*/}"
  _name="${_baseName%.*}"
  _epsFile=${_epsDir}/${_name}.eps
  echo "inkscape ${_inkscapeOpts} ${_file} --export-eps=${_epsFile}"

  inkscape ${_inkscapeOpts} ${_file} --export-eps=${_epsFile}
  _errorCode=$?

  if [[ ${_errorCode} != 0 ]] ; then
    echo "Error! (Code=${_errorCode})"
    [[ ${_err} == 0 ]] && _err=${_errorCode}
  else
    echo "${_file} exported!"
  fi
done

# Check running result.
if [[ ${_err} != 0 ]] ; then
  echo "Something went wrong!!!"
else
  echo "Done!"
fi
exit ${_err}
