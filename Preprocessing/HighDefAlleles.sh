#! /bin/bash
#SBATCH --output=/nrnb/users/jtalwar/Data/Melanoma_Exome_Sequencing/out/%A.%x.%a.out
#SBATCH --error=/nrnb/users/jtalwar/Data/Melanoma_Exome_Sequencing/err/%A.%x.%a.err
#SBATCH --array=1-505%113
#SBATCH -n 5 
#SBATCH --mem-per-cpu=31G

cd ../GenotypeData/Melanoma_Exome_Sequencing/fastq #cd into directory where paired fastqs are downloaded

sra_run_ids=() #Populate this with SRA run ids from study under investigation
itsGoTime=${sra_run_ids[$SLURM_ARRAY_TASK_ID - 1]} 

fastq1=$itsGoTime\_1.fastq.gz
fastq2=$itsGoTime\_2.fastq.gz

OutputDir=../Data/Melanoma_Exome_Sequencing/HLA_HD_Calls #pass in full path (i.e., no ..) if raises issues
HLAHD=../../../programs/hlahd.1.2.1

echo "Doing the thing ..."
echo $'\n'

echo "======= Starting HLA-HD ======="
echo $(date)
echo $'\n'

$HLAHD/bin/hlahd.sh -t 8 -m 70 -f $HLAHD/freq_data $fastq1 $fastq2 $HLAHD/HLA_gene.split.3.32.0.txt $HLAHD/dictionary $itsGoTime $OutputDir
echo "I am Sparticus and have called HLA alleles!"
echo $'\n'

echo "Remoiving space eating temporary files generated by HLA-HD..."

rm -rf $OutputDir/$itsGoTime/exon
rm -rf $OutputDir/$itsGoTime/intron
rm -rf $OutputDir/$itsGoTime/mapfile
rm -rf $OutputDir/$itsGoTime/maplist
rm -rf $OutputDir/$itsGoTime/exon
rm -rf $OutputDir/$itsGoTime/log
