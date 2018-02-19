#!/bin/python
"""
# --------------------------------------------------------------------------
# Script to parse FreeBSD netstat -w1 -d command to convert them into
# csv files. This will make easier the translation of the scores.
# Graphs can be done from here too with matplotlib.
# Author: Jordan A. Caraballo-Vega
# --------------------------------------------------------------------------
"""
import glob
import os
import os.path
import csv

### General Variables
FilesPath = "/Users/WhoAmI/Firewall/Scores/Here/" # path that stores the reports

### Create list with all the csv available files
ScoreFiles = glob.glob(FilesPath + "*.txt")
if len(ScoreFiles) == 0:
   print "ERROR: Files were not found."

### Open, parse, and create new files
for files in ScoreFiles:
    scoresList = list()
    with open(files) as netstat:
        lines = netstat.readlines()
        for i in lines:
            i = i.split()
            if i[0] != "input" and i[0] != "packets":
                scoresList.append(i)
    with open(files[:-3] + "csv",'wb') as resultFile:
        wr = csv.writer(resultFile, dialect='excel')
        wr.writerows(scoresList)

### Validate Created Files
CSVFiles = glob.glob(FilesPath + "*.csv")
if len(ScoreFiles) == len(CSVFiles) and len(ScoreFiles) > 0:
   print "Done. Files were processed."
else:
   print "WARNING: The amount of .csv and .txt files is not the same. You might want to check the output files."
