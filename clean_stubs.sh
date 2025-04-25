
STUB_DIRS=('panorama_diann_libFree_stub' 'panorama_diann_stub' 'panorama_encyclopedia_skyline_stub' 'panorama_msconvert_only_stub' 'pdc_bruker_d_diann_stub' 'pdc_diann_stub')

for d in ${STUB_DIRS[@]} ; do
    pushd $d
    rm -rf work/*
    rm -rfv results/* reports/* .nextflow.*
    popd
done
