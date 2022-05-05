#!/bin/bash

_apps="cmake texlive-full"

for _arg in "$@"; do
  case ${_arg} in
    "--build")
      _apps="${_apps} inkscape";;
    "--dev")
      _apps="${_apps} okular geany-plugin-spellcheck hunspell-hu";;
    *)
        echo "Usage: ${0} [OPTION]"
        echo ""
        echo "Option:"
        echo "  --help   show this help"
        echo "  --build  install dependencies for re-build whole project"
        echo "  --dev    install some usefull editor, spellchecker"
        exit 0;;
  esac
done

sudo apt-get install $_apps

if [[ ${?} != 0 ]] ; then
  echo "Something went wrong!!!"
else
  echo "Done!"
fi
