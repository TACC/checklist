Checklist
==============

Checklist evaluates the access/availability of critical components in User Space for using HPC Systems.
Checklist 4.0 is a complete rewrite and redesign of the Sanitytool sanitycheck developed at TACC by McLay and Si Liu.

#### General:

* The checklist command and its modules are Born Shell (bash) Scripts.  
The modules are check properties/accessiblity/restrictions
for services/file systems/allocations/quotas/etc. indicated by 
the modules name.  The module are call in numerical order of 
the prefix number in the module name (01_SSH, <##>_<whatever>)

* The checklist cmd and modules appear in the same directory as:

```
         checklist 01_SSH  02_Storage  0#_<check_item>.
```

#### Checklist Operation:

* Load checklist module and execute `checklist`:

```
         $ checklist    # Maybe  system-installed in /usr/bin
         $            
         $ module load checklist
         $ checklist
```

* Output
Each module returns an exit status of 0, 1, 3 for
PASS, FAIL, and WARNING, and captures the text printed 
to standard out from each module as a message (single or multi-line).
From these two pieces of information, checklist outputs:
```
         PASS|FAIL|WARN  ##  <message(s)>

         (e.g.)
          $checklist t   #terse mode
          [PASS] 01 SSH setup
                    Found public key id_ed25519.pub and ...
                    Permissions OK for: .ssh id_ed25519 ...
                
```
> where <message(s)> is output from 02_SSH scripts:
a one line terse description of the check, and other
lines with relevant checking details.
Checks that FAIL include diagnostic information.
Checks that provide WARNings may also provide diagnostic information.

#### User Check List
* Users can include their own checks in a directory, with
names of the form *PrefixNo_Name*, and specify the pathname
to their module directory by setting the environment
CL_USER_DIR environment variable to the full path to the directory.
When checklist is run, it executes the user modules and 
reports on the returned values after completing 
the system-wide modules. 

* Directory location of your checklist module commands should be exported (in a startup script--  ~/.profile, etc.).  If modules located in $HOME/apps/checklist, then use:
  
```
         $ export CL_USER_DIR=$HOME/apps/checklist
```

* The following is a template for a user module. The module can be an executable
in any language, but must supply an exit status (return
in C, exit in SHELL) value for the bash `checklist` command to capture 
(with \"$?\"), and writes a message to stdout).

* BASH Template
```
         $ cat $CL_USER_DIR/01_APPS

         #!/bin/bash

         echo "APPS checking for my_app in \$PATH"  # line 1 general description

         $( type my_app >/dev/null 2>&1 )           # check 4 my_app, no output
         if [[ $? == 0 ]]; then
           echo " my_app is present."               # message & status (0=PASS)
           exit 0                                  
         else
           echo " my_app is NOT present (check uses \"type\" cmd)."
           echo " Check \$PATH variable."
           echo " Acquire from https/github.com/$USER/my_app."
           exit 1                                            # status (1=FAIL)
         fi
```

  
> When multiple lines are printed include 10 spaces after the first line so that
the output lines up for the checklist reporting (e\.g\. for above):
       
```
         [FAIL] 01 APPS checking for my_app in $PATH."
                   my_app is NOT present (check uses "type" cmd).
                   Check $PATH variable.
                   Acquire from https/github.com/>username>/my_app."
```

* BASH Template verbosity standard checklist options
```
#!/bin/bash
        [[ $# != 1 ]] && O=N    #Command line options t=Terse,v=Verbose, default Normal
        [[ $1 == t ]] && O=T 
        [[ $1 == v ]] && O=V 

         $( type my_app >/dev/null 2>&1 ) # check 4 my_app, no output
         if [[ $? == 0 ]]; then
           echo " my_app is present."        # message and status (0=PASS)
           exit 0                            #return status       
         else
           [[ $O == T ]]  &&                               # terse
             echo " my_app was NOT FOUND."
           [[ $O == N ]] || [[ $O == V ]] &&               # normal or verbose
             echo " my_app was NOT FOUND by \"type\"." && 
             echo " Check \$PATH variable or default module setup."
           [[ $O == V ]] &&                                #verbose
             echo " Acquire from https//:github.com/$USER/my_app."
           exit 1                                          # return status
         fi

```


#### References
[Checklist](https://github.com/tacc/checklist)

[Sanitytool](https://github.com/siliu-tacc/sanitytool)

[Bash Cheat Sheet](https://github.com/RehanSaeed/Bash-Cheat-Sheet/blob/main/README.md)

[MD Cheat Sheet](https://www.markdownguide.org/cheat-sheet/)

