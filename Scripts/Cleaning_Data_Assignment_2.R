###### Cleaning and Combining Datasets: Assignment 2 #####


### Preliminaries ###
rm(list = ls())

# Set your working directory to a folder containing 471 .csv files
setwd("~/Documents/RA_and_Consulting_Work/ISSR_Data_Management_Web_Scraping_2017/Data/Multi_Datasets")

# You will want to make use of the following package, which you can download if
# you have not already:
# install.packages("rio", dependencies = TRUE)
library(rio)

# This assignment is a bit more open ended. If you go and look at the working
# directory, you will find 471 .csv files. You will need to read these in and
# combine them. They record some information about bills introduced in the U.S.
# Congress over a 22 year period (1993-2014). Each bill is broken down into
# sections, so there are mutliple observations for each bill. Here is an
# explanation of what each variable is:

# $session -- The session of Congress in which the bill was introduced.
# $chamber -- HR = House of Representatives, S = Senate.
# $number -- The number assigned to the bill in that session of Congress.
# $type -- IH = Introduced in House, IS = Introduced in Senate.
# $section -- The index of each section.
# $Cosponsr -- The number of Cosponsors for each bill.
# $IntrDate -- The date the bill was introduced.
# $Title -- The title of the bill.
# $NameFull -- The full name of the legislator who introduced the bill.
# $major_topic_label -- The topic of the bill.
# $party_name -- The party of the legislator that introduced the bill.




### Exercise 1 ###

# Use a 'for()' loop to read in the data and combine them into a singe
# data.frame. How many rows does this data frame have?





### Exercise 2 ###

# Create a new dataset that collapses the original dataset over bill sections so
# there is only one entry per unique bill. Add a field to this collapsed dataset
# called "Sections" that records the total number of sections associated with
# that bill. Removed the "section" variable from the data.frame as it is no
# longer necessary. How many rows are in this data.frame? Does the sum of the
# "Sections" variable in your new data.frame equal the number of rows in the old
# data.frame (with one entry per section)?




### Exercise 3 ###

# Now collapse your data even further. Create a new dataset with one row for
# each unique legislator (e.g. 'unique(data$NameFull)'). This dataset should
# have the following fields:

# $Name -- the name of the legislator (from the $NameFull field)
# $Total_Bills -- The total number of bills introduced by that legislator
# $Total_Sections -- The total number of sections in bills they introduced.
# $Average_Sections -- The average number of sections in bills they introduced.
# $Earliest_Bill -- The session their first bill was introduced.
# $Most_Common_Topic -- The most common topic for bills they introduced. If
# there is a tie, take the first one, alphabetically.


