#!/bin/bash
# creates a checklist which uses functions, or scripts,
# depending upon the input argument.
#
#  USAGE="USAGE: mk_checklist [scripts|functions] "
#
#  If scripts, just copy checklist.sh to checklist
#  if functions, do the following:

#    1 Create a single file of shell functions
#      from modules (0* files).
#    2 Create checklist with function files 
#      with functions before checklist.sh

USAGE="USAGE: `basename $0` [scripts|functions] "

if [[ $# -ne 1 ]]; then
  echo "$USAGE"
  exit 0
fi

[[ $1 == scripts   ]] && cp checklist.sh checklist && echo "Copied checklist.sh to checklist." && exit 0
[[ $1 != functions ]] && [[ $1 != scripts ]] && \
    echo " Error: did not understand $0 $1" && echo "$USAGE" && exit 1

       base_file=checklist.sh
  functions_file=checklist.shf
  checklist_file=checklist

  clist=( $(ls -1 [0-9][0-9]*) )
# clist=(x)

  rm -f $functions_file
  echo ""                                                       > $functions_file
  echo "#     ---------- checklist shell functions ----------" >> $functions_file
  
  for file in ${clist[@]}; do
     func_decl="${file}(){"
     echo ""                            >> $functions_file  # Space
     echo "# === $file ==="             >> $functions_file  # Comment
     sed '1 s/^.*$/'$func_decl'/' $file >> $functions_file  # Substitue #!/bin/bash with decl
     echo "}"                           >> $functions_file  # End function
     echo " "                           >> $functions_file  # Space
  done
     echo "clist=(${clist[@]}) #defined for inserted functions above." \
                                        >> $functions_file  # Include clist
     echo "USE=functions "              >> $functions_file  # Space
     echo " "                           >> $functions_file  # Space

  output=`grep -n '# END COMMENTS -- Do Not Remove, Alter or Duplicate' $base_file 2>/dev/null`
  if [[ $? == 0 ]]; then
    N=${output%:*}
    Np1=$((N+1))
  else
    Np1=2
  fi
  sed  -n "1,${N}p" $base_file  > $checklist_file  # Add commends and #!/bin/bash
  cat  $functions_file         >> $checklist_file  # Add functions
  tail -n +$Np1 $base_file     >> $checklist_file  # Uses Np1, not N as one would expect
  chmod 700 $checklist_file

  rm -f $functions_file

echo " -> Finished making checklist with functions based on these files:"
echo " -> ( ${clist[@]} )"
exit 0
