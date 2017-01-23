#!/bin/bash

# For generate the thesis.
sudo apt-get install texlive-full

if [[ ${1} == "--dev" ]] ; then
  echo "Install packages for developing..."
  sudo apt-get install okular geany-plugin-spellcheck hunspell-hu
fi

echo "Done!"
