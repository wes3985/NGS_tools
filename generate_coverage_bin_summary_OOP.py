# -*- coding: utf-8 -*-
"""
Created on Tue Sep 25 12:22:43 2018

@author: rmhawwo
This script reads in all bin coverage files associated with a sample and constructs a summary of bin-wise coverage across 
each chromosome, it then summarises coverage across all chromosomes and generates a report of bin-wise coverage.
 
"""

import sys
import os

class chromosome(object):
    
    # CONSTRUCTOR
    def __init__(self, SampleName, chrName):
        self.SampleName = SampleName
        self.chrName = str(chrName).upper()
        self.BinCount = 0   # keep track of lines in file (bins in chrom)
        self.NonZeroBinCount = 0 # keep track of bins with >1 read
        # self.NonZeroBinDict = {}  # consider keeping track of the specific bins that have non-zero coverage to compare between samples
        
    # REPRESENTATION METHOD: WHAT WILL BE PRINTED BY DEFAULT IF THE OBJECT IS CALLED
    def __repr__(self):
        return  self.chrName +'>'
    
    def update(self, BIN):
        self.BinCount += 1
        if float(BIN[2]) != 0.0:
            self.NonZeroBinCount += 1
        return self.BinCount, self.NonZeroBinCount
    

def generate_summary(bin_file_directory,SampleName,outfile_path):
    infiles=[os.path.join(bin_file_directory,f) for f in os.listdir(bin_file_directory)]       # get infiles
    chrNames=['chr'+str(c)+'_' for c in range(1,23)] + ['chr'+str(c) for c in ['M','X','Y']]   # generate names
    # build keys between chrNames and infiles
    # NOTE: a more stable way to do this would be to just supply ordered lists of infiles and chrnames in a file as part of the function call
    chr_dict = {}
    for chrom in chrNames:
        for f in infiles:
            if chrom in f:
                chr_dict[chrom]=f
    
    chrom_reports=[]
    for c in chr_dict:
        c_report = chromosome(SampleName,c)
        with open(chr_dict[c], 'r') as fh:
                depth_lines = get_data(fh)
                while True:
                    try:
                        c_report.BinCount, c_report.NonZeroBinCount = c_report.update(next(depth_lines))                                    
                    except:
                        StopIteration
                        break    
        chrom_reports.append(c_report)
    
# GENERATOR FUNCTION
def get_data(file_handle):
    for line in file_handle:
        yield line.split(',')
        
if __name__ == '__main__':
    # generate_coverage_report(DirectoryContainingBinFiles, SampleName, FullOutfilePath)
    generate_coverage_report(sys.argv[1], sys.argv[2], sys.argv[3])