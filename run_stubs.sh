
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

for d in ${STUB_DIRS[@]} ; do
    pushd $d
    echo $NEXTFLOW_RUN
    $NEXTFLOW_RUN
    popd
done

