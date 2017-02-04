#!/bin/bash
function getFlag()
{
  local flags=${1};
  for param in ${@:2}; do
    if [[ " ${flags[@]} " =~ " ${param[@]/%=*/} " ]]; then
      echo ${param[@]/*=/}
      exit
    fi
  done
}

function getValue()
{
  if [[ $1 ]]; then
    echo $1
  else
    echo $2
  fi
}
