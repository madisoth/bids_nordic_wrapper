#!/bin/bash -l
#SBATCH -J nordicsbatch
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=80G
#SBATCH -t 5:00:00
#SBATCH -p msismall
#SBATCH -o output_logs/nordicsbatch_%A_%a.out
#SBATCH -e output_logs/nordicsbatch_%A_%a.err
#SBATCH -A rando149

# usage: sbatch nordicsbatch.sh <args>

# input arguments (all are required)
# $1 = workdir
# $2 = input mag file
# $3 = input phase file
# $4 = NORDIC output file basename (no ".nii.gz" extension)
# $5 = number of noise volumes in input files

# outputs: 
# NORDIC-processed magnitude timeseries 
# NORDIC and non-NORDIC magnitude timeseries, with noise volumes cropped (filenames will have "rmnoisevols" appended to the BIDS task field)
# json sidecars for all timeseries output (copied from the sidecar of the input magnitude timeseries)

module load matlab/R2019a
module load fsl/5.0.10

cp -n /home/feczk001/shared/code/external/utilities/NORDIC/20211206/NIFTI_NORDIC.m $1
echo matlab -nodisplay -nodesktop -r "cd '/home/faird/shared/code/internal/utilities/bids_nordic_wrapper'; runnordic('$1','$2','$3','$4',$5)" 
matlab -nodisplay -nodesktop -r "cd '/home/faird/shared/code/internal/utilities/bids_nordic_wrapper'; runnordic('$1','$2','$3','$4',$5)"
echo gzip ${1}/${4}.nii 
gzip ${1}/${4}.nii
echo cp ${1}/${2::-7}.json ${1}/${4}.json
cp ${1}/${2::-7}.json ${1}/${4}.json
for INFILE in ${1}/${2} ${1}/${4}.nii.gz; do OUTFILE=`echo ${INFILE} | sed -E 's/_task-([^_]*)_/_task-\1rmnoisevols_/'`; NVOLS=`fslinfo $INFILE | grep -w dim4 | awk '{print $2}'`; NEWVOLS=`echo "${NVOLS} - ${5}" | bc`; sbatch /home/faird/shared/code/internal/utilities/bids_nordic_wrapper/genericsbatch_low_resources.sh "module load fsl; fslroi $INFILE $OUTFILE 0 $NEWVOLS"; cp ${INFILE::-7}.json ${OUTFILE::-7}.json; done