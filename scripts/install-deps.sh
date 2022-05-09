#!/bin/bash

# Basic dependencies.
_apps="cmake texlive-full"

# Private variables.
_opt=""
_err=0

# Parse arguments.
for _arg in "$@"; do
  case ${_arg} in
    "-b" | "--build")
      _apps="${_apps} inkscape";;
    "-d" | "--dev")
      _apps="${_apps} okular geany geany-plugin-spellcheck hunspell-hu";;
    "-y" | "--yes")
      _opt="--yes";;
    *)
      echo "Usage: ${0} [OPTION]"
      echo ""
      echo "Option:"
      echo "  -h, --help   show this help"
      echo "  -b, --build  install dependencies for re-build whole project"
      echo "  -d, --dev    install some usefull editor, spellchecker"
      echo "  -y, --yes    install with suto yes"
      exit 0;;
  esac
done

# Run installation.
echo "sudo apt-get ${_opt} install ${_apps}"
[[ ${_err} == 0 ]] && sudo apt-get ${_opt} install ${_apps}
_err=${?}

# Check running result.
if [[ ${_err} != 0 ]] ; then
  echo "Something went wrong!!!"
else
  echo "Done!"
fi
exit ${_err}
