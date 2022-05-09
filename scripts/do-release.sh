#!/bin/bash


#_version_tags=($(git tag --list 'v*'))
#_last_version=${_version_tags[-1]}
#_last_version=${_last_version:1}
#_Mmp=( ${_last_version//./ } )

#echo ${_Mmp[@]}


# Set default values.
_inDir=./build/paper/src
_outDir=./release
_versionFile=./VERSION
_version=""

# Private variables.
_err=0
_type=2

# Private functions.

# Check dependencies.
function _checkGs {
  if ! which gs > /dev/null ; then
    echo "Need to be installed: 'sudo apt install gs'"
    exit 1
  fi
}

# Increment version.
function _incVersion {
  local _delimiter=.
  local _nums=( $(echo "${_version}" | tr ${_delimiter} '\n') )
  _nums[${1}]=$((_nums[${1}]+1))
  _i=$((${1}+1))
  while [ ${_i} -lt ${#_nums[@]} ] ; do _nums[${_i}]="0"; _i=$((_i+1)); done
  echo $(local IFS=${_delimiter} ; echo "${_nums[*]}")
}

function _checkFile {
  if [[ -f "${1}" ]] ; then
    read -e -p "The '${1}' is exist! Rewrite it? [Y/n] " _yn
    [[ $_yn == "y" || $_yn == "Y" || $_yn == "" ]] && return 0
    return 1
  fi
  return 0
}

# Parse arguments.
for _arg in "$@"; do
  case ${_arg} in
    "-h" | "--help")
      echo "Usage: ${0} [OPTIONS] [INPUT_FILE]"
      echo ""
      echo "Option:"
      echo "  -h, --help              show this help"
      echo "  -i, --info              get informations from articles"
      echo ""
      echo "  -M, --major             incrase MAJOR (<M>.m.p) version number"
      echo "  -m, --minor             incrase MINOR (M.<m>.p) version number"
      echo "  -p, --patch             incrase PATCH (M.m.<p>) version number"
      echo ""
      echo "  -a, --all               update all type of articles (original, full grayscale, separated)"
      echo "  -g, --grayscale-only    update the full grayscaled version of articles"
      echo "  -s, --separated-only    update the separated version of articles (grayscale and color pages)"
      echo "  -c, --color-pages-only  update the color pages version os articles"
      exit 0
      ;;
    "-i" | "--info")
      _checkGs
      echo "filename; all pages; number of grayscale pages; grayscale pages; number of color pages; color pages"
      for _path in $(ls ${_inDir}/*.pdf); do
        _filename=$(basename ${_path})
        _graysclaepages=( $(gs -q -o - -sDEVICE=inkcov ${_path} | grep -n "^ 0.00000  0.00000  0.00000" | cut -d: -f1) )
        _colorpages=( $(gs -q -o - -sDEVICE=inkcov ${_path} | grep -n -v "^ 0.00000  0.00000  0.00000" | cut -d: -f1) )
        _num_of_gs=${#_graysclaepages[@]}
        _num_of_c=${#_colorpages[@]}
        _num_of_pages=$(( _num_of_gs + _num_of_c ))
        echo "${_filename}; ${_num_of_pages}; ${_num_of_gs}; $(echo ${_graysclaepages[@]} | sed 's/ /,/g'); ${_num_of_c}; $(echo ${_colorpages[@]} | sed 's/ /,/g')"
      done
      exit 0
      ;;
    "-M" | "--major")
      _version=$(_incVersion 0)
      ;;
    "-m" | "--minor")
      _version=$(_incVersion 1)
      ;;
    "-p" | "--patch")
      _version=$(_incVersion 2)
      ;;
    "-a" | "--all")
      _type=$((2*3*5*5))
      ;;
    "-g" | "--grayscale-only")
      _type=3
      ;;
    "-s" | "--separated-only")
      _type=$((5*5))
      ;;
    "-c" | "--color-pages-only")
      _type=5
      ;;
  esac
done

# Update version file.
#[[ _version != "" ]] && echo ${_version} > ${_versionFile}
if [ ! -f ${_versionFile} ]; then
  echo "The '${_versionFile}' file not found!"
  exit 1
fi
_version=$(head -n 1 ${_versionFile})
_version=${_version:1}

_outDir=${_outDir}/"v${_version}"
[[ ! -d "${_outDir}" ]] && mkdir -p ${_outDir}

for _path in $(ls ${_inDir}/*.pdf); do
  _filename=$(basename ${_path} .pdf)
  echo ${_filename}.pdf:
  if [[ $((_type%2)) == 0 ]] ; then
    _newFile="${_outDir}/${_filename}.pdf"
    _checkFile ${_newFile} && echo "  cp ${_path} ${_newFile}" && cp ${_path} ${_newFile}
  fi

  _colorpages=( $(gs -q -o - -sDEVICE=inkcov ${_path} | grep -n -v "^ 0.00000  0.00000  0.00000" | cut -d: -f1) )
  _num_of_c=${#_colorpages[@]}
  [[ ${_num_of_c} == 0 ]] && continue

  _newPrefix=${_outDir}/${_filename}
  if [[ $((_type%3)) == 0 ]] ; then
    _newFile="${_newPrefix}_grayscaled.pdf"
    _cmd="gs -sOutputFile=${_newFile} -sDEVICE=pdfwrite -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray -dCompatibilityLevel=1.4 -dNOPAUSE -dBATCH ${_path}"

    _checkFile ${_newFile} && echo "  $_cmd" && $(${_cmd})
  fi
  if [[ $((_type%25)) == 0 ]] ; then
    _graysclaepages=( $(gs -q -o - -sDEVICE=inkcov ${_path} | grep -n "^ 0.00000  0.00000  0.00000" | cut -d: -f1) )
    _newFile="${_newPrefix}_only-grayscale-pages.pdf"
    _pages=${_graysclaepages[@]}
    _cmd="pdftk ${_path} cat ${_pages} output ${_newFile}"

    _checkFile ${_newFile} && echo "  $_cmd" && $(${_cmd})
  fi
  if [[ $((_type%5)) == 0 ]] ; then
    _newFile="${_newPrefix}_only-color-pages.pdf"
    _pages=${_colorpages[@]}
    _cmd="pdftk ${_path} cat ${_pages} output ${_newFile}"

    _checkFile ${_newFile} && echo "  $_cmd" && $(${_cmd})
  fi
done

# Check running result.
if [[ ${_err} != 0 ]] ; then
  echo "Something went wrong!!!"
else
  echo "Done!"
fi
exit ${_err}
