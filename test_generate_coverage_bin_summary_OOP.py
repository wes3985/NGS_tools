# -*- coding: utf-8 -*-
"""
Created on Wed Sep 26 09:12:25 2018

@author: rmhawwo
"""

import unittest
import time
import timeit

from generate_coverage_bin_summary_OOP import chromosome



class Test_generate_coverage_bin_summary_OOP(unittest.TestCase):
   
        
    def test_chromosome_initiation(self):
        c = chromosome("testSample","chr1")             # initiate an instance of the 'chromosome' object
        self.assertEqual(c.SampleName,"testSample")
        self.assertEqual(c.chrName, "CHR1")
        self.assertEqual(c.BinCount,0)
        self.assertEqual(c.NonZeroBinCount,0)

    def test_chromosome_update_empty_bin(self):
        c = chromosome("testSample","chr1")             # initiate an instance of the 'chromosome' object   
        c.update(["0","0:10000","0.0","chr1"])
        self.assertEqual(c.BinCount,1)
        self.assertEqual(c.NonZeroBinCount,0)
        
    def test_chromosome_update_non_empty_bin(self):
        c = chromosome("testSample","chr1")
        c.update(["1","10000:20000","0.0603","chr1"])
        self.assertEqual(c.BinCount,1)
        self.assertEqual(c.NonZeroBinCount,1)       

        
                
if __name__ == '__main__':
    unittest.main()