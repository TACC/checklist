#!/bin/bash
# Checklist is a rename and rewrite the python sanitycheck tool "at TACC".
# It "checks" the same user environment components, but is a complete rewrite 
# in the BASH shell scripting language, performing checks in different ways
# and reporting is somewhat different.
# Nevertheless, it is versioned 4.0 in recognition of the previous work.

# One important design concept of 4.0 is that
# it simplifies how to include your own scripts for checking.
# Written by Kent Milfeld
# 
# END COMMENTS -- Do Not Remove, Alter or Duplicate
#-----
USAGE=" $0 [t|v]  #terse|verbose"

#Command line options t=terse,v=verbose, default normal
[[ $# == 1 ]] && [[ $1 != t ]] && [[ $1 != v ]] &&  echo "$USAGE" && exit 1

RED="\033[0;31m"
MAG="\033[0;34m"
RESET="\033[0m"
#Black: 30, Red: 31, Green: 32, Yellow: 33, Blue: 34, Magenta: 35, Cyan: 36, and White: 37.

#   Add APP Checks HERE to clist when check files (not functions) are used.
if [[ -z $clist ]]; then
  USE=scripts
  CL_DIR=`pwd`
  CL_CHECK_DIR=$CL_DIR
  clist=( $(cd $CL_CHECK_DIR; ls -1 [0-9][0-9]*) )
fi

#   Add User Checks HERE to clist when check files (not functions) are used.
CHECKLIST_USER_DIR=`pwd`/myown
if [[ -d $CHECKLIST_USER_DIR ]]; then
   user_clist=( $(cd $CHECKLIST_USER_DIR; ls -1 [0-9][0-9]*) )
   clist=(${clist[@]} ${user_clist[@]})
fi

for check in ${clist[@]}; do

  # Indicate when User check start, and use user's checlist directory
  if [[ $check == ${user_clist[0]} ]]; then
    USE=scripts
    echo "  =========  vvv User Checklist vvv ============"
    CL_DIR=$CHECKLIST_USER_DIR
  fi

  NO=${check%%_*}       # Get prefix sequence number (e.g. prefix number of 01_SSH)
  [[ $USE == scripts   ]] && output=`$CL_DIR/$check $1` && status=$?
  [[ $USE == functions ]] && output=$($check)           && status=$? #function option
#output=$( ${list[@]} )

  if [[ $status == 0 ]]; then
      printf "PASSED"
      printf " %3s %s\n" $NO "$output"
  else
      echo ""           # Space failures out and colorize them
      printf ${RED}FAILED${RESET}
      printf " %3s" $NO
      printf " ${MAG}$output${RESET}"
      echo ""
  fi

done
