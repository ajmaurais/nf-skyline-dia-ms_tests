
NEXTFLOW_RUN='nextflow run /home/ajm/code/nf-teirex-dia/main.nf -profile standard -c pipeline.config'
RESUME='-resume'
STUB=''

for i in "$@"
do
case $i in
    -f|--noResume)
        RESUME=''
    ;;
    --stub)
        STUB='-stub'
    ;;
    -h|--help)
        echo "run_test_workflows.sh [--stub] [--noResume]"
    ;;
    *)
        echo "Unknown option: \'$i\'"
        exit 1
    ;;
esac
done

NEXTFLOW_RUN="${NEXTFLOW_RUN} $RESUME $STUB"

TEST_DIRS=('local_mzML_diann' 'local_mzML_enc' 'local_mzML_enc_wide_only' 'pdc_diann' 'pdc_encyclopedia')

for d in ${TEST_DIRS[@]} ; do
    pushd $d
    echo $NEXTFLOW_RUN
    $NEXTFLOW_RUN
    popd
done

