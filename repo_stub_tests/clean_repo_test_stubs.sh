
STUB_DIRS=( $(dirname $0)/test-* )

for d in ${STUB_DIRS[@]} ; do
    pushd $d
    rm -rf work
    rm -rfv results/* reports/* .nextflow.* mzml_cache/*
    rm -fv pipeline.config test-resources
    popd
    rmdir -pv $d
done
