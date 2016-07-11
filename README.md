---
title: "Project for Getting and Cleaning Data Course"
author: "HYC91"
date: "July 10, 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
## This repository contains files needed for the project. 

## Data:
The goal of this project is to produce a tidy set of the following raw data:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Files:

1. The R script, run_analysis.R, does the following:

    Merges the training and the test sets to create one data set.
    
    Extracts only the measurements on the mean and standard deviation for each  measurement.
    
    Uses descriptive activity names to name the activities in the data set
    
    Appropriately labels the data set with descriptive variable names.
    
    From the data set above, creates a second, independent tidy data set with the  average of each variable for each activity and each subject.

2. The tidy dataset is shown in the file tidy.txt.

3. Codebook.md describes the variables, the data, and any transformations or work to 
   clean up the data

