#!/bin/bash
# Checklist is a rename and rewrite of the python sanitycheck tool "at TACC".
# It "checks" the same user environment components, but is a complete rewrite 
# in the BASH shell scripting language, performing checks in different way
# and reporting is somewhat different.
# Nevertheless, it is versioned 4.0 in recognition of the previous work.

# One important design concept of 4.0 is that
# it simplifies how to include your own scripts for checking.
# Write a script (Bash, python, ...) or C/C++/Fortran executable that returns:
#   one generic line of the purpose.
#   Additional line(s) about the success, failure or warning.
#   Return value (for the SHELL execution to read) of 0, 1 or 3, respectively.
# Read README.md for more details.
# 
#                                          2025-08-08 Written by Kent Milfeld
# 
# END COMMENTS -- Do Not Remove, Alter or Duplicate
#-----
USAGE=" $0 [t|v]  #terse|verbose"

#Command line options t=terse,v=verbose, default normal
[[ $# == 1 ]] && [[ $1 != t ]] && [[ $1 != v ]] &&  echo "$USAGE" && exit 1

 BLUE="\033[0;34m"
 CYAN="\033[0;36m"

 GRNB="\033[1;32m" GRN="\033[0;32m"
 REDB="\033[1;31m" RED="\033[0;35m"
 GLDB="\033[1;33m" GLD="\033[0;33m"
RESET="\033[0m"
#Black: 30, Red: 31, Green: 32, Yellow: 33, Blue: 34, Magenta: 35, Cyan: 36, and White: 37.

#   Add APP Checks HERE to clist when check files (not functions) are used.
if [[ -z $clist ]]; then
  USE=scripts
  CL_DIR=$(dirname $0)
  CL_CHECK_DIR=$CL_DIR
  clist=( $(cd $CL_CHECK_DIR; ls -1 [0-9][0-9]*) )
fi

#   Add User Checks HERE to clist when check files (not functions) are used.
if [[ -d $CHECKLIST_USER_DIR ]]; then
   user_clist=( $(cd $CHECKLIST_USER_DIR; ls -1 [0-9][0-9]*) )
   clist=(${clist[@]} ${user_clist[@]})
fi

for check in ${clist[@]}; do

  # Indicate when User check start, and use user's checklist directory
  if [[ $check == ${user_clist[0]} ]]; then
    USE=scripts
    echo "  =========  vvv User Checklist vvv ============"
    CL_DIR=$CHECKLIST_USER_DIR
  fi

  NO=${check%%_*}       # Get prefix sequence number (e.g. prefix number of 01_SSH)
# [[ $USE == scripts   ]] && output=`$CL_DIR/$check $1` && status=$?
  [[ $USE == functions ]] && output=$($check $1)        && status=$? #function option

  if [[ $USE == scripts   ]]; then
    output=`$CL_DIR/$check $1` 
    status=$?
  fi
#output=$( ${list[@]} )

  STRING1=$( echo $output | sed -n 1p | awk '{print $1}')

    # For highlighting first word, then remove color around line1 in printf
    # word1=$( echo $output | sed -n 1p | awk '{print $1}')
    # line1=$(sed 's/'$word1'/\\e[0;36;1m'$word1'\\e[0m/' <<< $line1)
      line1=$( head -1     <<< "$output")
      lines=$( tail -n +2  <<< "$output")
      lines=$(sed 's/^/          /' <<< "$lines")

  if [[ $status == 0 ]]; then
      printf " [${GRNB}PASS${RESET}]"
      printf " %2s "  "$NO"
      printf "${GRN}$line1${RESET}\n"
      printf "%s\n"  "$lines"
  elif [[  $status == 1 ]]; then
     #echo ""           # Space failures out and colorize them
      printf " [${REDB}FAIL${RESET}]"
      printf " %2s" $NO
      printf " ${GRN}$line1${RESET}\n"
      printf "${RED}$lines${RESET}\n"
  else
      printf " [${GLDB}WARN${RESET}]"
      printf " %2s" $NO
      printf " ${GRN}$line1${RESET}\n"
      printf "${GLD}$lines${RESET}\n"
  fi

done
