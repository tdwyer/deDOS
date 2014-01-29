#!/bin/bash
#===============================================================================
#
#          FILE: deDOS.sh
#
#         USAGE: dedos /home/user/Downloads
#
#   DESCRIPTION: Recursively strip symbols & caps from files & directories names
#
#       OPTIONS: dedos with no parameter sets current directory as target
#  REQUIREMENTS: bash find sed
#          BUGS: May result in filenames ending in a dash
#         NOTES: I banged my head against the wall so you dont have to
#        AUTHOR: Thomas Dwyer http://tomd.tel/
#       CREATED: Wed Jan 29 12:43:21 UTC 2014
#      REVISION: 2.0
#===============================================================================
#shopt -s globstar
DATE=/usr/bin/date
TARGET="./"
LOG="${TARGET}/deDOS-"$(${DATE} +"%m-%d-%y")".log"

main() {
  [[ ! -z ${1} ]] && TARGET="${1}"
  cd ${TARGET}

  echo "Recursively rename all everything in: $(pwd)"
  read -p "(Y/N) : " answer
  echo "Confirm Rename EVERYTHING in: $(pwd)"
  read -p "(Y/N) : " confirm

  [[ "${answer^^}" == "Y" && "${confirm,,}" == "y" ]] && run | tee ${LOG} 2>&1

  exit 0
}

run() {
  #
  # Change to TARGET directory
  # set dirs to a non-null value
  # set n to 0
  #
  # While dirs is not null
  #   set dirs to a list of all directories at a depth of n
  #   increment n by one
  #
  #   for each directory in dirs
  #     Change to directory
  #     Rename all objects in current directory
  #
  dirs="not null"
  n=0
  while [[ ! -z ${dirs} ]] ;do
    #
    dirs=$(find -maxdepth ${n} -mindepth ${n} -type d)
    ((n++))
    #
    for dir in ${dirs} ;do
      cd ${dir}
      rename
      cd -
    done
    #
  done
}

rename() {
  #
  # Rename all object to names with underscores in place of spaces
  # Set objects to a list of all objects in current directory
  #
  # For each object in objects
  #   Set new_name to the clean version of object current name
  #   Rename object to new_name
  #
  for f in *\ *; do mv "$f" "${f// /_}" 2>/dev/null ; done
  names=$(ls)
  #
  for name in ${names} ; do
    #
    new_name="$(echo ${name} | \
      tr '+' '_' | \
      tr '=' '-' | \
      tr -d '\\' | \
      tr -d "[\`\'\"~!@#$%^&*|;:,?(){}[]<>]" | \
      tr '[A-Z]' '[a-z]' | \
      sed -e 's/_-/_/g' -e 's/-_/-/g' | \
      sed -e 's/--/-/g' -e 's/__/_/g' | \
      sed -e 's/--//g' -e 's/__//g')"
    #
    mv -v ${name} ${new_name} 2>/dev/null
  done
}

main ${@}
exit 1
