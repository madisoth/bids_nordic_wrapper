#!/bin/bash

# required inputs/args: 
# $1=BIDS func directory with magnitude and phase timeseries for NORDIC denoising 
# $2=number of noise volumes at end of each scan
#
# in the func dir, filenames of single-echo data should contain "task-restSE" and "task-restSEph", respectively
# for multi-echo, "task-restME" and "task-restMEph"

# outputs:
# both NORDIC-denoised and non-denoised timeseries, with noise volumes cropped from end of scans (e.g. "task-restSENORDICrmnoisevols", "task-restSErmnoisevols"), plus sidecar JSONs (copied from the input magnitude timeseries)   
 

FUNCDIR=$1
NOISEVOLS=$2

cd $FUNCDIR

mkdir -p output_logs

for PHASE in *_task-restSEph_*.nii.gz; do MAG=`echo ${PHASE} | sed -e s/_task-restSEph_/_task-restSE_/` ; NORDIC=`echo ${MAG} | sed s/_task-restSE_/_task-restSENORDIC_/`; NORDIChead=`echo ${NORDIC} | sed s/.nii.gz//`; WD=`pwd`; echo $WD; echo $MAG; echo $PHASE; echo $NORDIChead; echo $NOISEVOLS; sbatch /home/faird/shared/code/internal/utilities/bids_nordic_wrapper/nordicsbatch.sh $WD $MAG $PHASE $NORDIChead $NOISEVOLS; done; 

for PHASE in *_task-restMEph_*.nii.gz; do MAG=`echo ${PHASE} | sed -e s/_task-restMEph_/_task-restME_/` ; NORDIC=`echo ${MAG} | sed s/_task-restME_/_task-restMENORDIC_/`; NORDIChead=`echo ${NORDIC} | sed s/.nii.gz//`; WD=`pwd`; echo $WD; echo $MAG; echo $PHASE; echo $NORDIChead; echo $NOISEVOLS; sbatch /home/faird/shared/code/internal/utilities/bids_nordic_wrapper/nordicsbatch.sh $WD $MAG $PHASE $NORDIChead $NOISEVOLS; done; 