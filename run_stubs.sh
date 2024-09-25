
NEXTFLOW_RUN='nextflow run /home/ajm/code/nf-teirex-dia/main.nf -profile standard -stub -resume -c pipeline.config'

for i in "$@"
do
case $i in
    -f|--noResume)
        NEXTFLOW_RUN='nextflow run /home/ajm/code/nf-teirex-dia/main.nf -profile standard -stub -c pipeline.config'
    ;;
    *)
        echo "Unknown option: \'$i\'"
        exit 1
    ;;
esac
done

STUB_DIRS=('panorama_diann_libFree_stub' 'panorama_diann_stub' 'panorama_encyclopedia_skyline_stub' 'panorama_msconvert_only_stub')

declare -A exit_codes
declare -A exit_code_count=(['success']=0 ['failure']=0)

for d in ${STUB_DIRS[@]} ; do
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
        echo "Failure: $d, rc=${exit_codes["$d"]}"
    done
    echo
fi

