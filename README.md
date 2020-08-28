# README

This is the code for the Coursera's Getting and Cleaning Data project.

## Purpose

The `run_analysis.R` file is going to merge the data from the `test` and
`train` folder under `UCI HAR Dataset` and return a tidy dataset which
contains the average value of the features containing mean() or std() of each
activity done by each subject. 

## How to run the code.

You need to have following packages: `tidyverse` and `data.table`. To install these packages, type `install.packages('tidyverse')` and `install.packages('data.table')` in R. 

To run the code, download the `run_analysis.R` file and place it in the `UCI HAR Dataset` folder. Start R in the same folder and type following:

```R
source('run_analysis.R')
results <- run_analysis()
```

The `results` will be the tidy dataset that meets the criteria for the project.
The dataset has four columns: 

1. subject: subject number
2. activity: activity name
3. variable: feature name that contains mean() or std()
4. average: the average value of each feature for each activity done by each subject
