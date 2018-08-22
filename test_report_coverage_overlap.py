# -*- coding: utf-8 -*-
"""
Created on Thu Aug  9 15:58:14 2018

@author: rmhawwo
"""

import unittest
import time
import timeit
from report_coverage_overlap import initiate_overlap_dict
from report_coverage_overlap import report_coverage_overlap
from report_coverage_overlap import update_samples

class T(unittest.TestCase):
    
    def test_simple(self):
        #st=time.time()
        self.assertEqual(
                initiate_overlap_dict(["AE","BE","HE","C"]),
                {'AE': 0, 'BE': 0, 'HE': 0, 'C': 0,
                 'AE:BE': 0, 'AE:HE': 0, 'AE:C': 0, 'BE:HE': 0, 'BE:C': 0, 
                 'HE:C': 0, 'AE:BE:HE': 0, 'AE:BE:C': 0, 'AE:HE:C': 0, 
                 'BE:HE:C': 0, 'AE:BE:HE:C': 0}
                )
        #print(time.time()-st)
        self.assertEqual(
                initiate_overlap_dict([1,2,3]),
                {'1': 0, '2': 0, '3': 0,
                 '1:2': 0, '1:3': 0, '2:3': 0, '1:2:3': 0}
                )
        self.assertRaises(
                Exception,
                lambda: initiate_overlap_dict('ABC'),
                )
        self.assertEqual(
                initiate_overlap_dict(['ABC']),
                {'ABC': 0}
                )
        self.assertEqual(
                #update_samples(sample_list,current_df,depths,min_cov)
                update_samples(["AE","BE","HE","C"],
                                {'AE': 0, 'BE': 0, 'HE': 0, 'C': 0,
                 'AE:BE': 0, 'AE:HE': 0, 'AE:C': 0, 'BE:HE': 0, 'BE:C': 0, 
                 'HE:C': 0, 'AE:BE:HE': 0, 'AE:BE:C': 0, 'AE:HE:C': 0, 
                 'BE:HE:C': 0, 'AE:BE:HE:C': 0},
                    [0,0,0,0],
                    1),
                               ({'AE': 0, 'BE': 0, 'HE': 0, 'C': 0,
                                 'AE:BE': 0, 'AE:HE': 0, 'AE:C': 0, 'BE:HE': 0, 'BE:C': 0, 
                                 'HE:C': 0, 'AE:BE:HE': 0, 'AE:BE:C': 0, 'AE:HE:C': 0,
                                 'BE:HE:C': 0, 'AE:BE:HE:C': 0},
                               set([]))                                           
                )
        self.assertEqual(
                #update_samples(sample_list,current_df,depths,min_cov)
                update_samples(["AE","BE","HE","C"],
                                {'AE': 0, 'BE': 0, 'HE': 0, 'C': 0,
                 'AE:BE': 0, 'AE:HE': 0, 'AE:C': 0, 'BE:HE': 0, 'BE:C': 0, 
                 'HE:C': 0, 'AE:BE:HE': 0, 'AE:BE:C': 0, 'AE:HE:C': 0, 
                 'BE:HE:C': 0, 'AE:BE:HE:C': 0},
                    [1,1,1,1],
                    1),
                               ({'AE': 1, 'BE': 1, 'HE': 1, 'C': 1,
                                 'AE:BE': 0, 'AE:HE': 0, 'AE:C': 0, 'BE:HE':0, 'BE:C': 0, 
                                 'HE:C': 0, 'AE:BE:HE': 0, 'AE:BE:C': 0, 'AE:HE:C': 0,
                                 'BE:HE:C': 0, 'AE:BE:HE:C': 0},
                               set(['AE','BE','HE','C']))                                           
                )
        self.assertEqual(
                #update_samples(sample_list,current_df,depths,min_cov)
                update_samples(["AE","BE","HE","C"],
                                {'AE': 0, 'BE': 0, 'HE': 0, 'C': 0,
                 'AE:BE': 0, 'AE:HE': 0, 'AE:C': 0, 'BE:HE': 0, 'BE:C': 0, 
                 'HE:C': 0, 'AE:BE:HE': 0, 'AE:BE:C': 0, 'AE:HE:C': 0, 
                 'BE:HE:C': 0, 'AE:BE:HE:C': 0},
                    [1,0,1,0],
                    1),
                               ({'AE': 1, 'BE': 0, 'HE': 1, 'C': 0,
                                 'AE:BE': 0, 'AE:HE': 0, 'AE:C': 0, 'BE:HE':0, 'BE:C': 0, 
                                 'HE:C': 0, 'AE:BE:HE': 0, 'AE:BE:C': 0, 'AE:HE:C': 0,
                                 'BE:HE:C': 0, 'AE:BE:HE:C': 0},
                               set(['AE','HE']))                                           
                )

        
        # TIME WHOLE FUNCTION
        #timeit.Timer(lambda: report_coverage_overlap(depth_file, 2, ["AE","BE","HE","C"], outfile_path)).timeit(5)

if __name__ == '__main__':
    unittest.main()
