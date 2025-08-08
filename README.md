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
         checklist 01_SSH, 02_xxx, 03_xxx.
```

#### Checklist Operation:

* Load checklist module and execute `checklist`:

```
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
         PASS  01  SSH permissions and keys OK.
```
> where <message(s)> gives a terse description of the check,
and relevant information.
Checks that FAIL include diagnostic information.

#### User Check List
* Users can include their own checks in a directory, with
names of the form *PrefixNo_Name*, and specify the pathname
to their module directory by setting the environment
CL_USER_DIR environment variable to the full path to the directory.
When checklist is run, it executes the user modules and 
reports on the returned values after completing 
the system-wide modules. 

* Directory location of your checklist module commands should be exported (in a startup script--  ~/.profile, etc.).  If modules located in $HOME/apps/checklist, the use:
  
```
         $ export CL_USER_DIR=$HOME/apps/checklist
```

* The following is a template for a user module. The module can be an executable
can be in any language, but must supply an exit status (return
in C, exit in SHELL) value for the bash `checklist` command to capture (with \"$?\"), and writes a message to stdout).

* BASH Template
```
         $ cat $CL_USER_DIR/01_APPS

         #!/bin/bash
         space='         '
         $( ls $HOME/apps/my_app >/dev/null 2>&1 ) # check 4 my_app, no output
         if [[ $? == 0 ]]; then
           echo "APPS my_app is present on this system"      # message to checklist
           exit 0                                            # return status
         else
           echo "APPS my_app is NOT present on this system." # message to checklist
           echo "$space It should have been installed in \~/apps."
           exit 1                                            # return status
         fi
```

  
> When multiple lines are printed include 10 spaces after the first line so that
the output lines up for the checklist reporting (e\.g\. for above):
       
```
         FAILED 01 APPS my_app is NOT present on this system.
                   It should have been installed in ~/apps.
```

* BASH Template verbosity standard checklist options
```
#!/bin/bash
        [[ $# != 1 ]] && O=N    #Command line options t=Terse,v=Verbose, default Normal
        [[ $1 == t ]] && O=T 
        [[ $1 == v ]] && O=V 

         space='         '
         $( ls $HOME/apps/my_app >/dev/null 2>&1 ) # check 4 my_app, no output
         if [[ $? == 0 ]]; then
           echo "APPS my_app is present on this system"      # message to checklist
           exit 0                                            # return status
         else
           echo "APPS my_app is NOT present on this system." # message to checklist
           [[ $O == N ]] || [[ $O == V ]] &&
           echo "$space It should have been installed in \~/apps."
           [[ $O == V ]] &&
             echo "$space my_app is available at github.com/$USER/my_app."
           exit 1                                            # return status
         fi

```


#### References
[Checklist](https://github.com/tacc/checklist)

[Sanitytool](https://github.com/siliu-tacc/sanitytool)

[Bash Cheat Sheet](https://github.com/RehanSaeed/Bash-Cheat-Sheet/blob/main/README.md)

[MD Cheat Sheet](https://www.markdownguide.org/cheat-sheet/)

