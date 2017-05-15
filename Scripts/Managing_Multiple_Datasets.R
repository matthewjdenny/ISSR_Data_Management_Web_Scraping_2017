# Managing multiple datasets
# Matthew Denny, mdenny@psu.edu, 5/18/16

# some preliminaries
rm(list = ls())

# you will need to set this to the location of th folder you downloaded for this
# workshop
setwd("~/Dropbox/RA_and_Consulting_Work/ISSR_Data_Management_in_R_2016/Data")

# We are going to be looking at a dataset that comprises 11 sessions on congress
# and sepcifically the bills cosponsored by senators over that period of time.
# This is a very complex data management problem.
Congresses <- 11


# lets begin by loading in some data:
cat("Loading Raw Senate Cosponsorship Matrix Data... \n")

# create a list object to store the data in
cosponsorship_data <- vector(mode = "list",
                             length = Congresses)

# loop over sessions of Congress
for (i in 1:Congresses) {
    cur <- 99 + i
    cat("Currently working on congress:",cur,"\n")
    temp <- read.csv(paste(cur,"_senmatrix.txt", sep = ""),
                     stringsAsFactors = F,
                     header = F)
    # we are only going to look at the first 100 bills from each congress
    temp <- temp[,1:100]
    cosponsorship_data[[i]] <- list(raw_data = temp)
}


cat("Transforming Raw data into Cosponsorship Matrices...\n")

# loop over sessions of congress
for (i in 1:Congresses) {
    cur <- 99 + i
    # let the user know what iteration we are on:
    cat("Currently on Congress number: ",cur,"\n")

    # extract the raw data so we can use it
    temp <- cosponsorship_data[[i]]$raw_data

    #create a sociomatrix to populate
    num_senators <- length(temp[,1])
    temp_sociomatrix <- matrix(0,
                               ncol = num_senators,
                               nrow = num_senators)

    # this is an example of nested looping
    for (j in 1:length(temp[1,])) {#for every bill

        #find out who the bill sponsor is (coded as a 1)
        for (k in 1: length(temp[,1])) { #for every Senator
            if (temp[k,j] == 1) {
                sponsor <- k
            }
        }

        #find all of the cosponsors
        for (k in 1:length(temp[,1])) { #for every Senator
            if (temp[k,j] == 2) {
                temp_sociomatrix[sponsor,k] <- temp_sociomatrix[sponsor,k] + 1
            }
        }
    }

   # store the processed sociomatrix in a new field
   cosponsorship_data[[i]]$sociomatrix <- temp_sociomatrix

}

# give the list object descriptive names
names(cosponsorship_data) <- paste("Congress",100:110,sep = "_")

# function that counts the total number of cosponsorships in a given congress.
Multiple_Cosponsorships <- function(cosponsorship_matrix){
    total <- 0
    for (i in 1:length(cosponsorship_matrix[1,])) {
        for (j in 1:length(cosponsorship_matrix[,1])) {
            # only add if the value is greater than 1
            if (cosponsorship_matrix[j,i] > 1) {
                total <- total + 1
            }
        }
    }
    return(total)
}

# try it out
Multiple_Cosponsorships(cosponsorship_data[[1]]$sociomatrix)

# 4. We can use functions inside of functions as well.
Multiple_Cosponsorships_per_Congress <- function(data){
    num_congs <- length(data)
    counts <- rep(0, times = num_congs)
    for (i in 1:num_congs) {
        cur <- 99 + i
        cat("Currently on Congress Number: ", cur ,"\n")
        counts[i] <- Multiple_Cosponsorships(data[[i]]$sociomatrix)
    }
    return(counts)
}

# try it out
Mult_Cosp_per_Congress <- Multiple_Cosponsorships_per_Congress(cosponsorship_data)

# plot our work
barplot(Mult_Cosp_per_Congress,
        xlab = "Congress",
        ylab = "Number of Multiple Cosponsorships",
        names = c(100:110),
        col = rainbow(11))


# 5. try loading in our functions from a source file (you will need to change the
# path on your computer)
source("~/Dropbox/RA_and_Consulting_Work/ISSR_Data_Management_in_R_2016/Scripts/My_Functions.R")

# test them out
Threshold_103 <- Threshold(1,cosponsorship_data$Congress_103$sociomatrix)
RowSums_103 <- Row_Sums(cosponsorship_data$Congress_103$sociomatrix)

#6.5 having some fun
library(statnet)

par(mfrow = c(1,1))
colors <- 1:11
years <- 100:110

netplot <- function(year, color){
    net <- as.network(cosponsorship_data[[1]]$sociomatrix)
    plot(net, vertex.col = color)
    Sys.sleep(.5)

}

mapply(netplot, years, colors)








