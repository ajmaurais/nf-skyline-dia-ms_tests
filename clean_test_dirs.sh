
TEST_DIRS=('local_mzML_diann' \
           'local_mzML_enc' \
           'local_mzML_enc_wide_only' \
           'pdc_diann' \
           'pdc_encyclopedia' \
           'panorama_raw_diann' \
           'panorama_mzML_diann' \
           'pdc_bruker_d_diann' \
           'panorama_multi_batch_diann')

for d in ${TEST_DIRS[@]} ; do
    pushd $d
    rm -rf work/* reports/*
    rm -rfv results/* .nextflow.*
    popd
done
