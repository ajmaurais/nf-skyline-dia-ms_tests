#!/usr/bin/env bash

REPO="$HOME/code/nf-skyline-dia-ms"
RESUME='-resume'

CONFIG_FILES=( ${REPO}/test-resources/*.config )

function usage() {
    echo "run_stubs.sh [--noResume] [stub_dir] [...]"
}

arg_dirs=()

while ! [[ -z "$1" ]] ; do
    case $1 in
        -f|--noResume)
            RESUME=''
        ;;
        -h|--help)
            usage
            exit 0
        ;;
        *)
            while ! [[ -z "$1" ]] ; do
                if [[ "$1" == -* ]] ; then
                    echo "Unknown option: \'$1\'"
                    usage
                    exit 1
                else
                    arg_dirs+=( "$1" )
                fi
                shift
            done
        ;;
    esac
    shift
done

NEXTFLOW_RUN="nextflow run ${REPO} -profile standard -c pipeline.config -stub ${RESUME}"

if [ ${#arg_dirs[@]} -eq 0 ] ; then
    stub_dirs=()
    for f in ${CONFIG_FILES[@]} ; do
        stub_dirs+=( repo_stub_tests/$(basename $f '.config') )
    done
else
    stub_dirs=(${arg_dirs[@]})
fi

declare -A exit_codes
declare -A exit_code_count=(['success']=0 ['failure']=0)

for d in ${stub_dirs[@]} ; do
    if [ ! -d $d ] ; then
        mkdir -pv $d || exit 1
    fi
    pushd $d
    if [ $? -eq 0 ] ; then
        echo $NEXTFLOW_RUN
        # $NEXTFLOW_RUN
        rc=$?
        popd
    else
        rc=127
    fi

    exit_codes["$d"]=$rc
    if [ $rc -eq 0 ] ; then
        ((exit_code_count['success']++))
    else
        ((exit_code_count['failure']++))
    fi
done
#
# echo -e "\n${exit_code_count['success']} succeded, ${exit_code_count['failure']} failed"
#
# if [ ${exit_code_count['failure']} -gt 0 ] ; then
#     echo
#     for d in ${!exit_codes[@]} ; do
#         if [ ${exit_codes["$d"]} -ne 0 ] ; then
#             echo "Failure: $d, rc=${exit_codes["$d"]}"
#         fi
#     done
#     echo
# fi
#
