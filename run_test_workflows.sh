
REPO='/home/ajm/code/nf-teirex-dia/main.nf'
RESUME='-resume'
STUB=''
BRANCH=''

while ! [[ -z "$1" ]] ; do
case $1 in
    -f|--noResume)
        RESUME=''
    ;;
    --stub)
        STUB='-stub'
    ;;
    --repo)
        shift
        REPO="$1"
    ;;
    --branch)
        shift
        BRANCH="-r $1"
    ;;
    -h|--help)
        echo "run_test_workflows.sh [--stub] [--noResume] [--repo <repository>] [--branch <branch>]"
        exit 0
    ;;
    *)
        echo "Unknown option: \'$1\'"
        exit 1
    ;;
esac
shift
done

NEXTFLOW_RUN="nextflow run ${REPO} ${BRANCH} -profile standard -c pipeline.config ${RESUME} ${STUB}"

TEST_DIRS=('local_mzML_diann' 'local_mzML_enc' 'local_mzML_enc_wide_only' 'pdc_diann' 'pdc_encyclopedia')

for d in ${TEST_DIRS[@]} ; do
    pushd $d
    echo $NEXTFLOW_RUN
    $NEXTFLOW_RUN
    popd
done

