#!/bin/bash
#
# NOTE: You can execute each ##_whatever script (file) to see module reports.
#
# scripts:
#   Creates checklist to use ##_whatever scripts (files).
#   checklist and scripts are (must be) in same directory.
#   Installs checklist in $PWD (or $PREFIX if defined).

# functions:
#   Creates checklist to contain ##_whatever scripts as functions 
#     Hence checklist (a single file) can be installed easily anyplace.
#   Installs checklist in $PWD (or $PREFIX if defined).
# 
# Suggestion for USERS:      PREFIX=$HOME/bin ./install.sh functions
#
# Suggestion for HPC Sites:  PREFIX=/usr/bin  ./install.sh functions
#          
# Suggestion for DEVELOPERS:                  ./install.sh scripts
#   Modify scripts for site.
#   Then install as USER/HPC SITE

USAGE1=" -> USAGE: `basename $0` [scripts|functions] "
USAGE2=" ->         Use functions normally, scripts if developing." 

[[ $# -ne 1 ]] &&  echo "$USAGE1" && echo " $USAGE_more" && exit 1
[[ $1 == scripts   ]] && ./mk_checklist.sh scripts
[[ $1 == functions ]] && ./mk_checklist.sh functions

exit
[[ $1 != scripts ]] && [[ $1 != functions ]] &&  \
   echo " Error: did not understand $0 $1" && echo "$USAGE1" && exit 1
exit

#============

if [[ $1 == scripts ]]; then
  if [[ -z $PREFIX ]]; then
    INSTALL_DIR=$PWD
    echo " -> Created checklist in \$PWD=$PWD, and will use scripts in \$PWD."
  else
    INSTALL_DIR=$PREFIX
    mkdir -p          $PREFIX
                              [[ $? != 0 ]] && \
                              echo " ERROR: Cannot create in PREFIX=$PREFIX." && exit 1
    cp -p checklist   $PREFIX
                              [[ $? != 0 ]] && \
                              echo " ERROR: Could not move checklist to PREFIX=$PREFIX." && exit 1
    cp -p [0-9][0-9]* $PREFIX
                              [[ $? != 0 ]] && \
                              echo " ERROR: Could not move scripts to PREFIX=$PREFIX." && exit 1

    echo " -> Created checklist. Installed checklist and scripts in $PREFIX."
  fi
fi

if [[ $1 == functions ]]; then

  if [[ -z $PREFIX ]]; then
    INSTALL_DIR=$PWD
    echo " -> Created checklist with ##_whatever scripts as internal functions "
    echo " -> in install directory \$PWD=$PWD."
    echo " -> checklist is self contained-- can be moved anyplace."
  else
    mkdir -p          $PREFIX
                              [[ $? != 0 ]] && \
                              echo " ERROR: Cannot create in PREFIX=$PREFIX." && exit 1
    cp -p checklist   $PREFIX
                              [[ $? != 0 ]] && \
                              echo " ERROR: Could not move checklist to PREFIX=$PREFIX." && exit 1

    echo " -> Created checklist with ##_whatever scripts as internal functions "
    echo " -> in install directory \$PREFIX=$PREFIX."
    echo " -> checklist is self contained-- can be moved anyplace."
  fi
fi
    echo ""
    echo " =============================================================================="
    echo "      => Please   include   $INSTALL_DIR in your PATH env. var."
    echo "      =>  BASH: export PATH=$INSTALL_DIR:\$PATH"
    echo " =============================================================================="
    echo ""
