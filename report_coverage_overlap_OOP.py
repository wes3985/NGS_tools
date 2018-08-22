# -*- coding: utf-8 -*-
"""
Created on Wed Aug 15 16:25:00 2018

@author: rmhawwo
"""

from itertools import combinations
from collections import OrderedDict

class CoverageReport(object):
    
    # CONSTRUCTOR
    def __init__(self, samples, minCov):
        self.samples = samples    # list of samples
        self.coverage,self.groups = self.initiate_report()
        self.count = 0   # KEEP TRACK OF LINES IN FILE
        self.cur_minCov_samples=set()
        self.minCov = minCov
    # REPRESENTATION METHOD: WHAT WILL BE PRINTED BY DEFAULT IF THE OBJECT IS CALLED
    def __repr__(self):
        return '<Samples and Coverage overlaps: ' + self.coverage +'>'
    
    def initiate_report(self):
        # Takes a list or a string and converts it into a dict of all combinations, initiates the value of the dict as integer 0
        if len(self.samples)==1 and type(self.samples)==list:
            return {self.samples[0]: 0}
        elif len(self.samples)==0 and type(self.samples)==list:
            raise Exception('"SAMPLE_LIST" needs to contain samples!')
        elif type(self.samples) != list:
            raise Exception('"SAMPLE_LIST" must be a list of length >=1 in the same order as they appear in the depth_file')
        else:
            sample_list=[str(x) for x in self.samples]
            out=OrderedDict()
            group_dict=OrderedDict()
            
            for s in sample_list:
                out[s]=0
            for c in range(2,len(sample_list)+1):
                for s in combinations(sample_list,c):
                    out[':'.join(s)]=0
                    group_dict[':'.join(s)]=set(s)
            return out,group_dict

    def update_report(self, depth):
        self.count +=1
        self.coverage, self.cur_minCov_samples = self.update_samples(depth, self.minCov)
        self.coverage = self.update_combinations()
        
        return self.coverage,self.count
    
    def update_samples(self, depth, min_cov):
        self.cur_minCov_samples=set()     # keeps track of the line by line samples > min_cov to assist in populating the comb_dict
        for i,s in enumerate(self.samples):
            if int(depth[i]) >= min_cov:
                self.cur_minCov_samples.add(s)
                self.coverage[s]+=1 
        return self.coverage, self.cur_minCov_samples
        
    def update_combinations(self):
        for g in self.groups:            
            if self.groups[g].issubset(self.cur_minCov_samples):
                self.coverage[g]+=1
        return self.coverage
    

        
def generate_coverage_report(depth_file,minCov,samples,outfile_path):
    report1=CoverageReport(samples,minCov) 
    with open(depth_file, 'r') as fh:
        depth_lines = get_data(fh)
        while True:
            try:
                report1.coverage,report1.count = report1.update_report(next(depth_lines))                                        
            except:
                StopIteration
                break    
    # GENERATE REPORT
    with open(outfile_path, 'w') as w:
        w.write("Sample\tBasesCovered\tFractionOfTotal\n")
        for s in report1.coverage:            
            w.write(str(s) + '\t' + str(report1.coverage[s]) + '\t' + str(float(report1.coverage[s])/float(report1.count))+'\n')
        w.write('TotalSize\t'+str(report1.count)+'\t1.00\n')
    return
# GENERATOR FUNCTION
def get_data(file_handle):
    for line in file_handle:
        yield line.split()[2:]

if __name__ == '__main__':
    #depth_file="//ad.ucl.ac.uk/homeo/rmhawwo/Documents/MEGA/home_share/merged_bam_analysis/test_merged_depth_data.txt"
    #depth_file="//ad.ucl.ac.uk/homeo/rmhawwo/Documents/MEGA/home_share/merged_bam_analysis/coverage_test_file_100k.txt"
    depth_file="//ad.ucl.ac.uk/homeo/rmhawwo/Documents/MEGA/home_share/merged_bam_analysis/mergedBAMSchr1.coverage"
    #outfile_path="//ad.ucl.ac.uk/homeo/rmhawwo/Documents/MEGA/home_share/merged_bam_analysis/coverage_test_file_100k_OUTPUT.txt"
    outfile_path="//ad.ucl.ac.uk/homeo/rmhawwo/Documents/MEGA/home_share/merged_bam_analysis/mergedBAMSchr1_overlapReport.txt"
    generate_coverage_report(depth_file, 2, ["AE","BE","HE","C"], outfile_path)