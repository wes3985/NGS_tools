# -*- coding: utf-8 -*-
"""
Created on Tue Apr 10 12:40:38 2018

@author: wes
"""

# RES: https://stackoverflow.com/questions/25962114/how-to-read-a-6-gb-csv-file-with-pandas

import pandas as pd
import numpy as np
import datetime
import os
import sys
import cProfile
import line_profiler

@profile
def process_bin(path,binSize,sampleName,sample_outdir):
    
    #bin_means=[]
    BIN_MEANS=pd.DataFrame(columns=['POSITION','MEANDEPTH']) #DF TO HOLD BIN DATA
    DO_NOT_RETURN_BIN_MEANS=False      # 
    CovOver0=0
    Cov0=0
    BIN_POS_TRACKER=[0,binSize]        # keeps track of chromosome postion
    chunk_tracker=0                    # keeps track of chunk number
    SIZE_LIMIT=1000000000
    
    for chunk in pd.read_csv(path, sep='\t', chunksize=binSize):
        chunk_tracker+=1
        #cur_bin_mean=chunk.ix[:,2].mean()   # get 3rd col, calculate mean
        cur_bin_mean=chunk.iloc[:,2].mean()   # get 3rd col, calculate mean
        #bin_means.append(cur_bin_mean)  # CHANGE TO ADD CHR,POS,cur_bin_mean
        bin_pos_string=str(BIN_POS_TRACKER).split('[')[1].split(']')[0].replace(', ',':')
        BIN_MEANS.loc[len(BIN_MEANS)]=[bin_pos_string,cur_bin_mean] # APPEND A ROW OF DATA
        if cur_bin_mean==0:
            Cov0+=1
        else: CovOver0+=1
        BIN_POS_TRACKER=[BIN_POS_TRACKER[0]+binSize,BIN_POS_TRACKER[1]+binSize]
        #CHECK SIZE OF BIN_MEANS, IF SIZE LIMIT IS EXCEEDED THEN PACKAGE INTO FILE AND RESET SIZE TRACKER
        if sys.getsizeof(BIN_MEANS) > SIZE_LIMIT:
            #BIN_MEANS['CHROM']='chr' + path.split('chr')[1].split('_')[0]   
            #BIN_MEANS['CHROM']='chr' + path.split('chr')[1].split('.')[0] 
            BIN_MEANS['CHROM']='chr' + sampleName
            #sampleName = path.split('/')[-1].split('_')[1]
            BIN_MEANS.to_csv(sample_outdir + '/'+sampleName+'_'+str(chunk_tracker)+'_'+str(binSize)+'.csv', sep=',')
            
        
    print ('N bins: ',len(BIN_MEANS))
    print ('mean cov: ',np.mean(BIN_MEANS))
    print('Cov0 bins: ',Cov0, 'Cov >0 bins: ',CovOver0)
    print('size of BIN_MEANS: ',sys.getsizeof(BIN_MEANS))
    
    if DO_NOT_RETURN_BIN_MEANS: return (DO_NOT_RETURN_BIN_MEANS, CovOver0, Cov0)
    else: return (BIN_MEANS, CovOver0, Cov0)
    
def process_file(path,binSizes,sample_outdir):
    
    CovOverZero_fractions = []
    NBINS = []
    
    for BIN in binSizes:
        sampleName = path.split('/')[-1].split('.')[0]                  # THERE IS SOMETIMES A BUG HERE WHERE THE sampleName IS DERIVED FROM THE path
        bin_data = process_bin(path,BIN,sampleName,sample_outdir)
        Nbins=bin_data[1]+bin_data[2]
        CovOverZero_fractions.append(bin_data[1]/Nbins)
        NBINS.append(Nbins)
        #APPEND CHROM TO DF
        if type(bin_data[0]) != bool:
            OUTDATA=bin_data[0]
            #print('chr' + path.split('chr')[1].split('_')[0])
            #OUTDATA['CHROM']='chr' + path.split('chr')[1].split('_')[0]
            OUTDATA['CHROM']='chr' + path.split('chr')[1].split('.')[0]
            print(OUTDATA.head())
            #SAVE DF TO FILE
            OUTDATA.to_csv(sample_outdir + '/'+sampleName+'_'+str(BIN)+'.csv', sep=',')        
        
    print('Fraction of nonZero bins: ',CovOverZero_fractions)
    print('Number of bins in chrom/file: ',NBINS)
    #SAVE SUMMARY OUTPUT
    
def process_chromosomes(sample_paths_file,binSizes,sample_outdir):

    with open(sample_paths_file, 'r') as r:
        sample_paths=[line.strip() for line in r]
    
    if not os.path.exists(sample_outdir):
        os.makedirs(sample_outdir)
    
    for path in sample_paths:
        print(datetime.datetime.now())
        print(path)
        process_file(path,binSizes,sample_outdir)
        

if __name__ == '__main__':
    print(datetime.datetime.now())
    # READ INPATHS FROM FILE
#    with open('/home/rmhawwo/Scratch/batch1_wgs_workflow/coverage_infile_paths.txt', 'r') as r:
#        sample_paths=[line.strip() for line in r]

#    sample_outdir='/home/rmhawwo/Scratch/batch1_wgs_workflow/LCM_coverage_binData/coverage_HC_LCM1'
#    binSizes=[10000]
#    process_chromosomes(sample_paths,binSizes,sample_outdir)
    #cProfile.run("process_chromosomes(sys.argv[1],[int(sys.argv[2])],sys.argv[3])")
    process_chromosomes(sys.argv[1],[int(sys.argv[2])],sys.argv[3])

