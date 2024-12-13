
TEST_DIRS=('local_mzML_diann' 'local_mzML_enc' 'local_mzML_enc_wide_only' 'pdc_diann' 'pdc_encyclopedia' 'panorama_raw_diann' 'panorama_mzML_diann')

for d in ${TEST_DIRS[@]} ; do
    pushd $d
    rm -rf work/*
    rm -rfv results/* reports/* .nextflow.*
    popd
done
