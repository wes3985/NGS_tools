# -*- coding: utf-8 -*-
"""
Created on Thu Aug  9 15:50:57 2018

@author: rmhawwo
"""

from itertools import combinations


def report_coverage_overlap(depth_file, min_cov, sample_list, outfile_path):
    
    overlap_df = initiate_overlap_dict(sample_list)
    combinations=set(overlap_df.keys()).difference(set([str(x) for x in sample_list]))  # get set of combinations, excluding original samples
    comb_dict={c:set(c.split(':')) for c in combinations}
    with open(depth_file, 'r') as fh:
        counter = update_overlap_df(overlap_df, min_cov, fh, sample_list, comb_dict)
        while True:
            try:
                cur=next(counter)
                overlap_df[cur[0]]=cur[1]                
            except:
                StopIteration
                break
        """
        TODO: Implement function in OOP
        TODO: unit testing of function
        """
    # GENERATE REPORT
    with open(outfile_path, 'w') as w:
        w.write("Sample\tBasesCovered\tFractionOfTotal\n")
        for s in overlap_df:            
            w.write(str(s) + '\t' + str(overlap_df[s]) + '\t' + str(float(overlap_df[s])/float(cur[2]))+'\n')
        w.write('TotalSize\t'+str(cur[2])+'\t1.00\n')
    
def initiate_overlap_dict(SAMPLE_LIST):
    # Takes a list or a string and converts it into a dict of all combinations, initiates the value of the dict as integer 0
    if len(SAMPLE_LIST)==1 and type(SAMPLE_LIST)==list:
        return {SAMPLE_LIST[0]: 0}
    elif len(SAMPLE_LIST)==0 and type(SAMPLE_LIST)==list:
        raise Exception('"SAMPLE_LIST" needs to contain samples!')
    elif type(SAMPLE_LIST) != list:
        raise Exception('"SAMPLE_LIST" must be a list of length >=1 in the same order as they appear in the depth_file')
    else:
        sample_list=[str(x) for x in SAMPLE_LIST]
        out={}
        
        for s in sample_list:
            out[s]=0
        for c in range(2,len(sample_list)+1):
            for s in combinations(sample_list,c):
                out[':'.join(s)]=0
        return out
    
def update_overlap_df(overlap_df, min_cov, fh, sample_list, comb_dict):
    """
    generator function to read in depth file and populate overlap_df where reads > min_cov
    """
    updated_df={**overlap_df}   # shallow copies the dict to update it (python 3.5+)
    count=0
    count_track=10000000
    for line in fh:
        count+=1
        if count_track==count:
            print(str(count) + ' bases counted')
            count_track+=10000000
        depths=line.split()[2:]
        # UPDATE THE DICT FOR WHERE INDIVIDUAL SAMPLES > min_cov 
        # GET SET OF SAMPLES > min_cov FOR update_combinations
        updated_df, cur_out = update_samples(sample_list,updated_df,depths,min_cov)
        
        #IF ONLY 1 SAMPLE THEN yield AT THIS POINT
        if len(comb_dict) ==0:
            for k in updated_df:
                yield k, updated_df[k], count
        # UPDATE THE DICT FOR COMBINATIONS OF SAMPLES WHERE ALL SAMPLES IN A GIVEN COMBINATION HAVE DEPTH > min_cov
        updated_df = update_combinations(updated_df, comb_dict, cur_out)
          
        for k in updated_df:
            yield k, updated_df[k], count
            
def update_samples(sample_list,current_df,depths,min_cov):
    cur_out=set()                              # keeps track of the line by line samples > min_cov to assist in populating the comb_dict
    updated_df={**current_df}
    for i,s in enumerate(sample_list):
        if int(depths[i]) >= min_cov:
            cur_out.add(s)
            updated_df[s]+=1 
    return updated_df, cur_out

def update_combinations(current_df,comb_dict, cur_out):
    updated_df={**current_df}
    for c in comb_dict:            
        if comb_dict[c].issubset(cur_out):
            updated_df[c]+=1
    return updated_df


if __name__ == '__main__':
    #depth_file="//ad.ucl.ac.uk/homeo/rmhawwo/Documents/MEGA/home_share/merged_bam_analysis/test_merged_depth_data.txt"
    depth_file="//ad.ucl.ac.uk/homeo/rmhawwo/Documents/MEGA/home_share/merged_bam_analysis/coverage_test_file_100k.txt"
    #depth_file="//ad.ucl.ac.uk/homeo/rmhawwo/Documents/MEGA/home_share/merged_bam_analysis/mergedBAMSchr1.coverage"
    outfile_path="//ad.ucl.ac.uk/homeo/rmhawwo/Documents/MEGA/home_share/merged_bam_analysis/coverage_test_file_100k_OUTPUT.txt"
    #outfile_path="//ad.ucl.ac.uk/homeo/rmhawwo/Documents/MEGA/home_share/merged_bam_analysis/mergedBAMSchr1_overlapReport.txt"
    report_coverage_overlap(depth_file, 2, ["AE","BE","HE","C"], outfile_path)