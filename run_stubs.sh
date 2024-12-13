
NEXTFLOW_RUN='nextflow run /home/ajm/code/nf-teirex-dia/main.nf -profile standard -stub -resume -c pipeline.config'
STUB_DIRS=('panorama_diann_libFree_stub' 'panorama_diann_stub' 'panorama_encyclopedia_skyline_stub' 'panorama_msconvert_only_stub' 'pdc_diann_stub' 'panorama_local_mix_stub')

function usage() {
    echo "run_test_workflows.sh [--noResume] [stub_dir] [...]"
}

arg_dirs=()

for i in "$@" ; do
    case $1 in
        -f|--noResume)
            NEXTFLOW_RUN='nextflow run /home/ajm/code/nf-teirex-dia/main.nf -profile standard -stub -c pipeline.config'
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

if [ ${#arg_dirs[@]} -eq 0 ] ; then
    stub_dirs=(${STUB_DIRS[@]})
else
    stub_dirs=(${arg_dirs[@]})
fi

declare -A exit_codes
declare -A exit_code_count=(['success']=0 ['failure']=0)

for d in ${stub_dirs[@]} ; do
    pushd $d
    if [ $? -eq 0 ] ; then
        echo $NEXTFLOW_RUN
        $NEXTFLOW_RUN
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

echo -e "\n${exit_code_count['success']} succeded, ${exit_code_count['failure']} failed"

if [ ${exit_code_count['failure']} -gt 0 ] ; then
    echo
    for d in ${!exit_codes[@]} ; do
        if [ ${exit_codes["$d"]} -ne 0 ] ; then
            echo "Failure: $d, rc=${exit_codes["$d"]}"
        fi
    done
    echo
fi

