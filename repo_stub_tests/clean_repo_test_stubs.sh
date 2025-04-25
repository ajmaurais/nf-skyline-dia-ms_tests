
STUB_DIRS=( $(dirname $0)/test-* )

for d in ${STUB_DIRS[@]} ; do
    pushd $d
    rm -rf work
    rm -rfv results/* reports/* .nextflow* mzml_cache/* raw_cache/*
    rm -fv pipeline.config test-resources
    rmdir -vp mzml_cache reports results raw_cache
    popd
    rmdir -pv $d
done
