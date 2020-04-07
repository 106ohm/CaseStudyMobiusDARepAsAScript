#!/bin/bash

# the directory path of the results
PROJECTNAME="DSN2020ToolCaseStudy"

####################################

# Num observations sent in 1 update to SimMgr. (default=1000)
OBS="1"
# batch numbers for each run of solver
BATCHES_LIST="1 32"
# each run (for a fixed value of BATCHES) generates a result binary file .dat,
# NOTICE: to get correctly the final result files .txt and .csv by  merging different binary files .dat, different seeds must be set for each different .dat file,
# the seeds for random numbers, associated to each number of BATCHES of BATCHES_LIST
#SEEDS=(21657)
SEEDS=(31415 31415)

####################################

MYINPUTFILE_LIST="
caseStudy_9.xml
"

# list of solvers (one for each line) and experiments number (from 1) for each solver
SOLVER_LIST="
# solvername space-separated-exp-numbers
#sim 1 2 3
sim
"

# remove comments
MYSOLVER_LIST=$(echo "${SOLVER_LIST}" | awk '!/^[ ]*#.*/ {printf "%s\n", $0}')

########### MAIN CODE ##############

main() {
    # input options 
    init
    #rundarep
    getarguments "$@"
    makesolvers
    # if [ -n "$mflag" ]; then # option -m
    #     genmakefiles
    # else
    #     if [ \( -z "$gflag" -a -z "$rflag" -a -z "$oflag" \) \
    #          -o -n "$gflag" ]; then # no option or option -g
    #         makesolvers
    #     fi
    #     if [ \( -z "$gflag" -a -z "$rflag" -a -z "$oflag"  \) \
    #          -o -n "$rflag" ]; then # no option or option -r
    #         launchsolvers
    #     fi
    #     if [ \( -z "$gflag" -a -z "$rflag" -a -z "$oflag"  \) \
    #          -o -n "$oflag" ]; then # no option or option -o
    #         getresults
    #     fi
    # fi
}


# set variables
init() {
    PROJECTS="${HOME}/MobiusProject"
    THEPROJECT="${PROJECTS}/${PROJECTNAME}"
    PARAMS="${THEPROJECT}/params"
    DAREP="${THEPROJECT}/darep"
    SRC="${PARAMS}/src"
    BIN="${PARAMS}/bin"
    HOST=$(uname -n)
    NPROCS=$(getconf _NPROCESSORS_ONLN)
    # get arch
    if [ "$(uname -s)" == "Darwin" ]; then
	ARCH="macosx"
        # set mobius shell path based on OS
        MSHELL="/Applications/Mobius-2.5.app/mobius-shell.sh"
    else
	ARCH="linux"
        # mobius shell
        MSHELL="/usr/share/mobius-2.5/mobius-shell.sh"
    fi    

    # the temporary batch file including the mobius-shell commands to resave
    MSHELLBATCH="${THEPROJECT}/batches/.batch.mshell"
}

# run darep
rundarep() {
    eval make clean -C ${DAREP}/c++/
    ${DAREP}/bin/darep.pl -f ${INPUTFILE}
    eval make -C ${DAREP}/c++/
    unset IFS
}

# run params
runparams() {
    eval make -C ${PARAMS}/src/
    eval make debug -C ${PARAMS}/src/
    unset IFS
}

 
# generate all makefile, using mobius shell
genmakefiles () {    
    # set display
    if [ -z "$DISPLAY" ]; then
        if [[ "${HOST}" == "bradipo" ]]; then
            export DISPLAY=:3
        elif [[ "${HOST}" == "lumaca" ]]; then
            export DISPLAY=:7
        elif [ -n "$DOCKER" ]; then
            export DISPLAY=:99
        else 
            export DISPLAY=:99
        fi
    fi

    # generate the mobius shell commands to generate all makefile

    # atomic cmds
    MSHELLGENATOMICCMDS=""
    for ATOMIC in $(ls -A1 $THEPROJECT/Atomic | sort -V); do
        COUNTMATCH=$(cat ${THEPROJECT}/${PROJECTNAME}.prj | grep -c "<atomic key=\"${ATOMIC}\">")        
        if [ ${COUNTMATCH} -gt 0 ]; then
            MSHELLGENATOMICCMDS=$(cat << EOF
open a ${ATOMIC}
generate
close                                               
${MSHELLGENATOMICCMDS}
EOF
                               )
        fi
    done                

    # composed cmds
    MSHELLGENCOMPOSEDCMDS=""
    for COMPOSED in $(ls -A1 $THEPROJECT/Composed | sort -V); do
        COUNTMATCH=$(cat ${THEPROJECT}/${PROJECTNAME}.prj | grep -c "<composed key=\"${COMPOSED}\">")        
        if [ ${COUNTMATCH} -gt 0 ]; then
            MSHELLGENCOMPOSEDCMDS=$(cat << EOF
open c ${COMPOSED}
generate
close                                               
${MSHELLGENCOMPOSEDCMDS}
EOF
                               )
        fi
    done                

    # reward cmds
    MSHELLGENREWARDCMDS=""
    for REWARD in $(ls -A1 $THEPROJECT/Reward | sort -V); do
        COUNTMATCH=$(cat ${THEPROJECT}/${PROJECTNAME}.prj | grep -c "<reward key=\"${REWARD}\">")        
        if [ ${COUNTMATCH} -gt 0 ]; then
            MSHELLGENREWARDCMDS=$(cat << EOF
open r ${REWARD}
generate
close                                               
${MSHELLGENREWARDCMDS}
EOF
                               )
        fi
    done                

    # study cmds
    MSHELLGENSTUDYCMDS=""
    for STUDY in $(ls -A1 $THEPROJECT/Study | sort -V); do
        COUNTMATCH=$(cat ${THEPROJECT}/${PROJECTNAME}.prj | grep -c "<study key=\"${STUDY}\">")
        if [ ${COUNTMATCH} -gt 0 ]; then
            MSHELLGENSTUDYCMDS=$(cat << EOF
open y ${STUDY}
generate
close
${MSHELLGENSTUDYCMDS}
EOF
                               )
        fi
    done

    # solvers cmds
    MSHELLGENSOLVERCMDS=""
    for SOLVERNAME in $(ls -A1 $THEPROJECT/Solver | sort -V); do
        COUNTMATCH=$(cat ${THEPROJECT}/${PROJECTNAME}.prj | grep -c "<solver key=\"${SOLVERNAME}\">")        
        if [ ${COUNTMATCH} -gt 0 ]; then
            MSHELLGENSOLVERCMDS=$(cat << EOF
open s ${SOLVERNAME}
generate
close
${MSHELLGENSOLVERCMDS}
EOF
                               )
        fi
    done
                        
    # make temporary file including mobius-shell commands to generate makefile files
    cat << EOF > ${MSHELLBATCH}
open ${PROJECTNAME}
${MSHELLGENATOMICCMDS}
${MSHELLGENCOMPOSEDCMDS}
${MSHELLGENREWARDCMDS}
${MSHELLGENSTUDYCMDS}
${MSHELLGENSOLVERCMDS}
close
exit
EOF
    # mobius shell
    # list commands
    echo "mobius shell commands: "
    
    cat "${MSHELLBATCH}"
    # use eval otherwise mshell fails
    echo "running mobius shell ..."
    eval "${MSHELL} -s ${MSHELLBATCH}"
    
    # remove mobius-shell temporary file
    rm -f ${MSHELLBATCH}
    
    # patch solver makefile
    ${BIN}/patch_all_solver_makefile.bash
}

# make solvers
makesolvers() {
    IFS=$'\n'
    for INPUTFILE in ${MYINPUTFILE_LIST}; do
	MNAME="${INPUTFILE}"       # the full input file path with path and with extension
	MBASEFILE=${INPUTFILE##*/}     # the input file basename without path and with extension
	MBASENAME="${MBASEFILE%%.*}" # the input file basename without path and without extension

	# run darep and re-compile the lib
	echo "Timing darep + re-compile"
	time rundarep

	# re-compile params lib
	echo "Timing re-compile params"
	time runparams

        # generate all makefile, using mobius shell
	echo "Timing compilation time"
        time genmakefiles

        # make clean of all solvers
	for SOLVERINFO in ${MYSOLVER_LIST}; do
            SOLVERNAME=$(echo "$SOLVERINFO" | awk '{print $1}')
	    SOLVER="${THEPROJECT}/Solver/${SOLVERNAME}"

	    # the name of the solver command
	    COMMANDNAME="${SOLVERNAME}Sim_${ARCH}"
	    MYCOMMANDNAME="${SOLVERNAME}Sim_${ARCH}_${MBASENAME}"
	    SOLVERCMD="${SOLVER}/${COMMANDNAME}"
	    MYSOLVERCMD="${SOLVER}/${MYCOMMANDNAME}"

	    echo ""
	    echo "Make Solver clean:"
	    echo "cd ${SOLVER}"
	    cd "${SOLVER}"
	    if [ $? -ne 0 ]; then
		exit 1
	    fi
            
            # docker: ERROR: Build process returned exit code 137 during Docker build
            # [ https://stackoverflow.com/questions/34674325/error-build-process-returned-exit-code-137-during-docker-build-on-tutum ]
            # In Mac, to tackle with it, you might want to try changing memory allocation in Docker > Preference > Memory. 
	    eval "make -j${NPROCS} clean"
	done

        # make opt
	for SOLVERINFO in ${MYSOLVER_LIST}; do
            SOLVERNAME=$(echo "$SOLVERINFO" | awk '{print $1}')
	    SOLVER="${THEPROJECT}/Solver/${SOLVERNAME}"

	    # the name of the solver command
	    COMMANDNAME="${SOLVERNAME}Sim_${ARCH}"
	    MYCOMMANDNAME="${SOLVERNAME}Sim_${ARCH}_${MBASENAME}"
	    MYCOMMANDSHAREDNAME="${SOLVERNAME}Sim_${ARCH}_shared_${MBASENAME}"
	    SOLVERCMD="${SOLVER}/${COMMANDNAME}"
	    MYSOLVERCMD="${SOLVER}/${MYCOMMANDNAME}"

	    # the name of the solver command for debugging
            COMMANDNAME_DEBUG="${SOLVERNAME}Sim_${ARCH}_debug"
	    MYCOMMANDNAME_DEBUG="${SOLVERNAME}Sim_${ARCH}_debug_${MBASENAME}"
	    MYCOMMANDSHAREDNAME_DEBUG="${SOLVERNAME}Sim_${ARCH}_debug_shared_${MBASENAME}"
	    SOLVERCMD_DEBUG="${SOLVER}/${COMMANDNAME_DEBUG}"
	    MYSOLVERCMD="${SOLVER}/${MYCOMMANDNAME_DEBUG}"

	    echo ""
	    echo "Make Solver:"
	    echo "cd ${SOLVER}"
	    cd "${SOLVER}"
	    if [ $? -ne 0 ]; then
		exit 1
	    fi
            
            # debug solver based on default static lib
            # docker: ERROR: Build process returned exit code 137 during Docker build
            # [ https://stackoverflow.com/questions/34674325/error-build-process-returned-exit-code-137-during-docker-build-on-tutum ]
            # In Mac, to tackle with it, you might want to try changing memory allocation in Docker > Preference > Memory.
	    echo "Timing (parallel) make opt"
	    start=`date +%s`
	    eval "make -j${NPROCS} opt"
            # generate solver based on shared library and rename shared
            gensharedsolver "opt" "${COMMANDNAME}" "${MYCOMMANDSHAREDNAME}"
	    end=`date +%s`
	    runtime=$((end-start))
	    echo "the user time is ${runtime}s"

            # debug solver based on default static lib
	    echo "Timing (parallel) make debug"
	    start=`date +%s`
            eval "make -j${NPROCS} debug"
           # generate debug solver based on shared library and rename shared
            gensharedsolver "debug" "${COMMANDNAME_DEBUG}" "${MYCOMMANDSHAREDNAME_DEBUG}"
	    end=`date +%s`
	    runtime=$((end-start))
	    echo "the user time is ${runtime}s"

	    # rename default solver
	    mv -fv "${COMMANDNAME}" "${MYCOMMANDNAME}"
	    echo "Solver: ${MYCOMMANDNAME}"
	    mv -fv "${COMMANDNAME_DEBUG}" "${MYCOMMANDNAME_DEBUG}"
	    echo "Solver: ${MYCOMMANDNAME_DEBUG}"

	    echo ""

	done
    done

    unset IFS

}

# generate solver based on shared library
# $1: opt or debug
# $2: COMMANDNAME (for opt) or COMMANDNAME_DEBUG (for debug)
# $3: MYCOMMANDSHAREDNAME (for opt) or MYCOMMANDSHAREDNAME_DEBUG (for debug)
gensharedsolver() {
    local MAKEFLAG="$1"
    local SOLVERCOMMANDNAME="$2"
    local MYSOLVERCOMMANDSHAREDNAME="$3"
    if [ "$sflag" ]; then # generate shared library
        MOBIUSPROJECTLIB=$(ls -dt ${THEPROJECT}/lib/*/ | head -1) # most recently modified lib dir
        pushd "$MOBIUSPROJECTLIB" # project libs dir
        if [ "${MAKEFLAG}" == "opt" ]; then # make opt
            LIBSA=$(ls -A1 | grep .a | grep -v _debug.a) # the list of .a libraries
            MAKECMD="make -j${NPROCS} opt"
        fi
        if [ "${MAKEFLAG}" == "debug" ]; then # make debug
            LIBSA=$(ls -A1 | grep _debug.a) # the list of .a libraries
            MAKECMD="make -j${NPROCS} debug"
        fi
        if [ "$(uname -s)" == "Darwin" ]; then # macosx
            for libi in ${LIBSA}; do
                libib=$(basename $libi .a)
                g++ -fpic -shared -Wl,-force_load,${libib}.a -o ${libib}.dylib
            done
        else # linux
            for libi in ${LIBSA}; do
                libib=$(basename $libi .a)
                g++ -fpic -shared -Wl,--whole-archive ${libib}.a -Wl,-no-whole-archive -o ${libib}.so
            done
        fi
        popd # solver dir
        # generate solver using dynamic libraries
        if [ -x "${SOLVERCOMMANDNAME}" ]; then # already exist solver static version, rename to _shared
            mv -fv "${SOLVERCOMMANDNAME}" "${SOLVERCOMMANDNAME}_static"
            eval "${MAKECMD}"
            mv -fv "${SOLVERCOMMANDNAME}" "${MYSOLVERCOMMANDSHAREDNAME}"
            mv -fv "${SOLVERCOMMANDNAME}_static" "${SOLVERCOMMANDNAME}"
        else # does not exist solver static version
            eval "${MAKECMD}"
        fi
    fi 
}
 
# for each batch, set options for solvers and prepare list of commands to launch them
setbatches() {
    # list of solver commands to run in parallel
    CMDLIST=""
    # list of .dat files generated by each solver, including in each line a solver name and all the .dat files, one for each experiment, associated to the solver
    # a solver name could occur in more than one line, for different input file names .m
    # results_file_basename solvername datfilename_exp1 datfilename_exp2 ... 
    DATFILELIST=""

    BATCHi=0 # the position, starting from 0, of current number of BATCHES in BATCHES_LIST, used to get the associated seed
    for BATCHES  in ${BATCHES_LIST}; do
	setsolvers
        BATCHi=$((BATCHi+1))
    done # for each different number of batches
}

    # set options for solvers and prepare list of commands to launch them
setsolvers() {
    IFS=$'\n'
    for INPUTFILE in ${MYINPUTFILE_LIST}; do
	MNAME="${INPUTFILE}"       # the full input file path with path and with extension
	MBASEFILE=${INPUTFILE##*/}     # the input file basename without path and with extension
	MBASENAME="${MBASEFILE%%.*}" # the input file basename without path and without extension
	
	for SOLVERINFO in ${MYSOLVER_LIST}; do
            SOLVERNAME=$(echo "$SOLVERINFO" | awk '{print $1}')
            EXPS=$(echo "$SOLVERINFO" | awk '{$1=""}1')
	    SOLVER="${THEPROJECT}/Solver/${SOLVERNAME}"

	    # the name of the solver command
	    COMMANDNAME="${SOLVERNAME}Sim_${ARCH}"
	    MYCOMMANDNAME="${SOLVERNAME}Sim_${ARCH}_${MBASENAME}"
	    SOLVERCMD="${SOLVER}/${COMMANDNAME}"
	    MYSOLVERCMD="${SOLVER}/${MYCOMMANDNAME}"

            # results_file_basename
            RESFILEBASENAME="Results_${MBASENAME}_N${BATCHES}_s${SEEDS[$BATCHi]}_${HOST}"
            # the list of the dat files, one for each experiment, associated to each solver
	    DATFILESOLVERLIST="${RESFILEBASENAME} ${SOLVERNAME}"
            
            # for each experiment (starting from 1)
            unset IFS
            for EXP in ${EXPS}; do                
	        # the dat file (output)               
	        DATFILE="${SOLVER}/Results_${MBASENAME}_Exp${EXP}_N${BATCHES}_s${SEEDS[$BATCHi]}_${HOST}_bin.dat"
                # .dat file basename, including ext
                DATFILEBASENAME="Results_${MBASENAME}_Exp${EXP}_N${BATCHES}_s${SEEDS[$BATCHi]}_${HOST}_bin.dat"
                # rexpesults file basename, excluding ext .txt or .csv
                EXPRESFILEBASENAME="Results_${MBASENAME}_Exp${EXP}_N${BATCHES}_s${SEEDS[$BATCHi]}_${HOST}"
	        
	        echo ""
	        echo "Set solver options:"
	        
	        OPTIONS="-e$((EXP-1)) -N${BATCHES} -n${OBS} -s${SEEDS[$BATCHi]} -b ${DATFILE}"
	        #echo "${MYSOLVERCMD} ${OPTIONS} >&/dev/null &"
	        #${MYSOLVERCMD} ${OPTIONS} >&/dev/null &
	        # echo "${MYSOLVERCMD} ${OPTIONS} >&/dev/null"|sh &
	        # bash -c "${MYSOLVERCMD} ${OPTIONS} >&/dev/null" &
	        #eval "${MYSOLVERCMD} ${OPTIONS} >&/dev/null" &
                
	        # append commands to list
	        CMD="${MYSOLVERCMD} ${OPTIONS} >&/dev/null"
	        echo "${CMD}"
                if [ -z "${CMDLIST}" ]; then
	            CMDLIST="${CMD}"
                else
                    CMDLIST="${CMDLIST}\n${CMD}"
                fi
                DATFILESOLVERLIST="${DATFILESOLVERLIST} ${EXPRESFILEBASENAME},${DATFILEBASENAME}"
	        
	        echo ""
            done # EXPS
            IFS=$'\n'

            # the dat files associated to each solver
            if [ -z "${DATFILELIST}" ]; then
	        DATFILELIST="${DATFILESOLVERLIST}"
            else
	        DATFILELIST="${DATFILELIST}\n${DATFILESOLVERLIST}"
            fi

	done # MYSOLVER_LIST
    done # MYINPUTFILE_LIST

    unset IFS

}

# run solvers in parallel
parallelsolvers() {

    # Run up to PARALLELRUNS jobs in parallel
    echo "Parallel running:"

    #PARALLELRUNS=$(sysctl -n hw.ncpu)
    #PARALLELRUNS="4"
    PARALLELRUNS=$(getconf _NPROCESSORS_ONLN)

    # where are the shared libs
    MOBIUSPROJECTLIB=$(ls -dt ${THEPROJECT}/lib/*/ | head -1) # most recently modified lib dir
    # to run shared-lib-based solver executable
    export LD_LIBRARY_PATH=${MOBIUSPROJECTLIB}
    
    printf "${CMDLIST}" | parallel -v --no-notice -j${PARALLELRUNS} 

}

# process binary result files to get csv and txt files
processbinresults() {

    # generate commands for mobius shell
    cat << EOF > ${MSHELLBATCH}
open ${PROJECTNAME}
EOF

    IFS=$'\n'
    for DATFILEINFO  in $(printf "${DATFILELIST}"); do # for each list of dat files associated to each solver
        RESULTSBASEFILENAME=$(echo "$DATFILEINFO" | awk '{print $1}')
	SOLVERNAME=$(echo "$DATFILEINFO" | awk '{print $2}')
        DATFILES=$(echo "$DATFILEINFO" | awk '{$1=""; $2=""}1')

        # commands for mobius shell
        cat << EOF >> ${MSHELLBATCH}
open s ${SOLVERNAME}
EOF

        unset IFS # space separed .dat file names
        for RESDATINFO  in $(printf "${DATFILES}"); do # for each dat file associated to each solver
	    EXPRESFILEBASENAME=$(echo "$RESDATINFO" | awk -F',' '{print $1}')
	    DATFILE=$(echo "$RESDATINFO" | awk -F',' '{print $2}')
            
            # make temporary file including mobius-shell commands to generate csv results file from .dat file
            cat << EOF >> ${MSHELLBATCH}
results -f -t csv -o ${EXPRESFILEBASENAME} -b ${DATFILE}
results -f -t txt -o ${EXPRESFILEBASENAME} -b ${DATFILE}
EOF
            
        done # for each dat file associated to each solver
        IFS=$'\n'

        # commands for mobius shell
        cat << EOF >> ${MSHELLBATCH}
close
EOF

    done # for each list of dat files associated to each solver
    unset IFS

        # commands for mobius shell
        cat << EOF >> ${MSHELLBATCH}
close
exit
EOF

        # print commands for mobius shell
        echo "mobius shell commands: "
        cat "${MSHELLBATCH}"
        # mobius shell
        # use eval otherwise mshell fails
        echo "running mobius shell ..."
        bash -c "${MSHELL} -s ${MSHELLBATCH}"
        
        # remove mobius-shell temporary file
        rm -f ${MSHELLBATCH}
}

# lauch solvers
launchsolvers() {
    setbatches
    parallelsolvers
}


# get results using mobius shell
getresults() {
    setbatches
    processbinresults    
}


# get arguments of the script
getarguments () {

    E_BADARGS=1
    while getopts ":hmgros" opt; do
        case $opt in
	    m)
                if [ "${OPTARG:0:1}" = "-" ]; then
                    echo "Ops! Invalid parameter \"${OPTARG}\" provided for argument \"-${opt}!\"" 1>&2
                    hflag=1
                else
		    #               echo "-d was triggered! Parameter: $OPTARG" >&2
                    mflag=1
                fi
	        ;;
	    g)
                if [ "${OPTARG:0:1}" = "-" ]; then
                    echo "Ops! Invalid parameter \"${OPTARG}\" provided for argument \"-${opt}!\"" 1>&2
                    hflag=1
                else
		    #               echo "-d was triggered! Parameter: $OPTARG" >&2
                    gflag=1
                fi
	        ;;
	    r)
                if [ "${OPTARG:0:1}" = "-" ]; then
                    echo "Ops! Invalid parameter \"${OPTARG}\" provided for argument \"-${opt}!\"" 1>&2
                    hflag=1
                else
		    #               echo "-d was triggered! Parameter: $OPTARG" >&2
                    rflag=1
                fi
	        ;;
	    o)
                if [ "${OPTARG:0:1}" = "-" ]; then
                    echo "Ops! Invalid parameter \"${OPTARG}\" provided for argument \"-${opt}!\"" 1>&2
                    hflag=1
                else
		    #               echo "-d was triggered! Parameter: $OPTARG" >&2
                    oflag=1
                fi
	        ;;
	    s)
                if [ "${OPTARG:0:1}" = "-" ]; then
                    echo "Ops! Invalid parameter \"${OPTARG}\" provided for argument \"-${opt}!\"" 1>&2
                    hflag=1
                else
		    #               echo "-d was triggered! Parameter: $OPTARG" >&2
                    sflag=1
                fi
	        ;;
	    h)
                if [ "${OPTARG:0:1}" = "-" ]; then
                    echo "Ops! Invalid parameter \"${OPTARG}\" provided for argument \"-${opt}!\"" 1>&2
                    hflag=1
                else
		    #               echo "-h was triggered! Parameter: $OPTARG" >&2
                    hflag=1
                fi
	        ;;
	    \?)
	        echo "Ops! Invalid option: -$OPTARG" >&2
	        hflag=1
	        E_BADARGS=65
	        ;;
	    :)
	        echo "Option -$OPTARG requires an argument." >&2
	        hflag=1
	        E_BADARGS=65
	        ;;
        esac
    done

    shift $(($OPTIND - 1))
    
    # the help
    if [ $hflag ];then
        help
        exit $E_BADARGS
    fi

    # check number of input args
    if [ $# -gt 0 ];then
        echo "Ops! Too many arguments!"
        help
        exit $E_BADARGS
    fi

    if [ -n "$mflag" ]; then 
        if [ -n "$gflag" -o -n "$rflag" -o -z "$oflag" ]; then 
	    echo "Ops! Use option -m without other options."
            help
	    exit -1        
        fi
    fi

}



# help based on here document approach
function help {
    cat << EOF

This script, for each combination of listed .m files and listed solvers, in the order:
1. generates all the solvers,
2. runs all the solvers,
3. generate the csv and txt result files.
Step 1., 2. or .3 can be enabled using the options -g, -r or -m, respectively. 

Set variables before MAIN CODE to define the configuration adopted for the runs. 

Before launching this script with options -m, -g or -o (or without options), set the DISPLAY environment variable and start X11 server, in order to run mobius shell.

Before runnning shared-lib-based solvers, set the LD_LIBRARY_PATH environment variable to the path project-path/lib/u1604-m64, where are the shared libraries of the project components. 

IMPORTANT NOTICE: for the current version of the script, option -s (and -r, to run the shared executable solver) works correctly only with 1 (one) entry in the list INPUTFILE_LIST.

Usage: $0 [-h] {{[-g] [-r] [-o] [-s]}|[-m]}
  -g (optional argument): generate all solvers listed in SOLVER_LIST, regenerating all data structures and makefile, for each input file listed in INPUTFILE_LIST. 
  -s (optional argument): integrate -g option, generating shared libraries for each static lib compiled with -fPIC option, thus the resulting solver executable is based on the generated shared libraries (when both shared and static library is found, linker prefers the shared one). This option requires the compiler option -fPIC and the seting of the LD_LIBRARY_PATH environment variable to run the generated executable. The shared libraries are generated in the directory project-path/lib/u1604-m64.
If static executable is already generated, then the shared executable is renamed appending it the prefix _shared.
  -r (optional argument): run all solvers listed in SOLVER_LIST, for each input file listed in INPUTFILE_LIST. The LD_LIBRARY_PATH environment variable to run the shared-lib-based solver executable is automatically set to project-path/lib/u1604-m64.
  -o (optional argument): get result files .txt and csv from files .dat.
  -m (optional argument): generate makefile only.
  -h (optional argument): help info.

Examples:
            setenv DISPLAY :99 (with tcsh shell)
            Xvfb :99 -screen 0 640x480x8 -nolisten tcp &
            $0 (generate and run all solvers)
            $0 -g (generate all sovers)
            $0 -g -s (generate all sovers, also solvers  based on dynamic libs)
            $0 -r (run all sovers)
EOF
    exit $E_BADARGS
}

main "$@"
