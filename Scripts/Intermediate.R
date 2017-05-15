###### Intermediate R Workshop, 5/23/16, contact mdenny@psu.edu #####


###### Preliminaries -- Setting Up R To Do Work ######

# Clear your workspace -- This gets rid of all of the information that was there when you started to you have a clean slate.
rm(list = ls())

# Set your working directory -- This is where R goes to look for files and save stuff by default. You will need to do this for each computer you run your script file on. In RStudio, you can go to Session -> Set Working Directory -> Choose Directory and select a folder from a drop down menu. For me, this looks like:
setwd("~/Dropbox/RA_and_Consulting_Work/ISSR_Data_Management_in_R_2016")

###### cat vs. print ######

# the cat function will print things without "" marks around them, which often looks nicer, but it also does not skip to a new line if you call it multiple times inside of a function (something we will get to soon) or a loop. Lets try out both:
print("Hello World")
cat("Hello World")

# now we can try them inside bracketts to see how cat does not break lines:
{
    cat("Hello")
    cat("World")
}

{
    print("Hello")
    print("World")
}

# so we have to manually break lines with cat() using the "\n" or newline symbol
{
cat("Hello \n")
cat("World")
}

###### The paste function and making informative messages ######

#the paste function takes as many string, number or variable arguments as you want and sticks them all together using a user specified separator:

# lets define a variable to hold the number of fingers we have:
fingers <- 8
#now lets print out how many fingers we have:
print(paste("Hello,", "I have", fingers, "Fingers", sep = " "))
#now lets separate with dashes just for fun:

print(paste("Hello,", "I have", fingers, "Fingers", sep = "-----"))

#now lets try the same thing with cat
cat(paste("Hello,", "I have", fingers, "Fingers", sep = " "))
#however, with cat, I can just skip the paste part and it will print the stuff directly
cat("Hello,", "I have", fingers, "Fingers", sep = " ")

#if we want cat to break lines while it is printing, we can also include the "\n" symbol at the end (or anywhere for that matter)
cat("My Grocery List:\n", "1 dozen eggs\n","1 loaf of bread\n 1 bottle of orange juice\n", "1 pint mass mocha", sep = " ")

###### For Loops ######

#this is a way to automate performing tasks my telling R how many times you want to do something. Along with conditional statments and comparison operators, loops are more powerful than you can immagine. Pretty much everything on your computer can be boiled down to a combinations of these.

# for (           i in           1:10){
# for each number i in the range 1:10

# example of a for() loop -- first lets make a vector of data
my_vector <- c(20:30)
# take a look
cat(my_vector)

# notice how the value of i changes
i = 76
# loop over values in the vector
for(i in 1:length(my_vector)){
    cat(i,"\n")
    my_vector[i] <- sqrt(my_vector[i])
}
#display the result
cat(my_vector)

# lets add some stuff together
my_num <- 0
for(i in 1:100){
  my_num <- my_num + i
  cat("Current Iteration:",i,"My_num value:",my_num,"\n")
}

###### If/Else Statements ######

# these give your computer a "brain", they let it see if somethng is the case, and dependent on that answer your compute can then take some desired action.

#if(some condition is met){
#     do something
#}

#lets try an example to check and see if our number is equal to 20
my_number <- 19
if(my_number < 20){
    cat("My number is less than 20 \n")
}
my_number <- 22
if(my_number < 20){
    cat("My number is less than 20 \n")
}


# example of an if statement
my_vector <- c(20:30)
for(i in 1:length(my_vector)){
    cat("Current Index:",i,"Value:",my_vector[i],"\n")
    if(my_vector[i] == 25){
        cat("The square root is 5! \n")
    }
}

# you can also add in an else statement to do something else if the condition is not met.
my_vector <- c(20:30)
for(i in 1:length(my_vector)){
    cat("Current Index:",i,"Value:",my_vector[i],"\n")
    if(my_vector[i] == 25){
        print("I am 25!")
    }else{
        print("I am not 25!")
    }
}


###### Functions ######

#user defined functions allow you to easily reuse a section of code

#define a function that will take the sum of a particular column of a matrix (where the column index is a number)
my_column_sum <- function(col_number,
                          my_matrix){
    #take the column sum of the matrix
    col_sum <- sum(my_matrix[,col_number])
    return(col_sum)
}

#lets try it out
my_mat <- matrix(1:100,nrow=10,ncol=10)
#look at our matrix
my_mat
#take its column sum
temp <- my_column_sum(col_number = 1,
                      my_matrix = my_mat)

#lets double check
sum(my_mat[,1])

#now we can loop through all columns in the matrix
for(i in 1:10){
  cat(my_column_sum(i,my_mat),"\n")
}

# we can now write a function that calls our function to automatically
# do the above for any matrix
col_sums_for_fun <- function(mat) {
    # figure out the number of columns
    cols <- ncol(mat)
    # loop over columns
    for(i in 1:cols){
        # calculate the column sum
        cat(my_column_sum(i,mat),"\n")
    }
}

# lets try it with a larger matrix
my_mat2 <- matrix(301:700,nrow=20,ncol=20)
col_sums_for_fun(my_mat2)


###### A Data Cleaning Example ######

# lets read in some data
load("./Data/Example_Data.Rdata")

# This is a dataset with metadata on all bills introduced in the United States Congress between 2011-2012. Among many variables, it contains indicators of the number of cosponsors, the month the bill was introduced, the chamber it was introduced in (House or Senate), the major topic code (see reference list below) and the party of the sponsor.

# Lets say we wanted to look at a subset of all bills that were introduced in the House that were about any of the first ten topics and then take a the sum of the number of bills introduced in each month by each party that passed the house and divide by the total number of cosponsorships they recieved to get a weight for the effectiveness of each cosponsorship. Here are the topics:

# Major topic numbers ---
# 1. Macroeconomics
# 2. Civil Rights, Minority Issues, and Civil Liberties
# 3. Health
# 4. Agriculture
# 5. Labor and Employment
# 6. Education
# 7. Environment
# 8. Energy
# 9. Immigration
# 10. Transportation
# 12. Law, Crime, and Family Issues
# 13. Social Welfare
# 14. Community Development and Housing Issues
# 15. Banking, Finance, and Domestic Commerce
# 16. Defense
# 17. Space, Science, Technology and Communications
# 18. Foreign Trade
# 19. International Affairs and Foreign Aid
# 20. Government Operations

# lets start by subsetting our data -- we only want HR bills with a major topic less than 11

reduced_data <- data[which(data$BillType == "HR" & data$Major < 11),]

#define a matrix to hold our calcuated statistics
party_topic_statistics <- matrix(0, nrow = 10, ncol = 2)

#now we loop over topics
for(i in 1:10){

    #now for each month we loop over parties
    for(j in 1:2){
        # set teh variable we are going to lookup against for party ID
        if(j == 1){
            party <- 100
        }else{
            party <- 200
        }

        # subset down to party/topic combination
        current_data <- reduced_data[which(reduced_data$Party == party & reduced_data$Major == i),]

        # check to make sure that there are any observations for the current party/topic combination
        if(length(current_data[,1]) > 0){
            # Now subset to those that passed the house
            current_data <- current_data[which(current_data$PassH == 1),]

            #calculate the weight
            cosponsorship_weight <- nrow(current_data)/sum(current_data$Cosponsr)

            #check to see if it is a valid weight, if not, set equal to zero
            if(is.nan(cosponsorship_weight) | cosponsorship_weight > 1 ){
                cosponsorship_weight <- 0
            }

            #take that weight and put it in our dataset
            party_topic_statistics[i,j] <- cosponsorship_weight
        }

    }
}

# load the labels for bill major topics
load("./Data/Topic_Lookup.Rdata")
#replace a really long one with a shorter title for plotting
major_topic_lookup[2,1] <- "2. Civil Rights"

#specify the dimensions of our PDF output and the title
pdf(width = 5,height = 8, file = "My_Plot.pdf")

#we want a wider margin on the bottom and left sides so our text will fit. margins go (bottom, left, top, right)
par(mar = c(13,5,2,2))

# plot our data using matplot which lets us easily plot more than one series on the same axes
matplot(x= 1:10,  #this tells matplot what the x values should be
        y=cbind(party_topic_statistics[,2],party_topic_statistics[,1]), #this reverses democrat and republican so it is easier to see the democrat points and then specifies the y values
        pch = 19, #this sets the point type to be dots
        xlab = "", #this say do not plot an x label as we will specify it later
        ylab = "Cosponsorships Per Passed Bill", #the y label
        xaxt = "n", #dont plot any x-axis ticks
        col = c("red","blue"), #the colors for the dots, blue is democrat, red is republican
        ylim = c(-0.01,.2) #the y-limits of the plotting range
        )

#now we can add a custom x-axis with our text labels
axis(side = 1, at = 1:10, tick = FALSE, labels = major_topic_lookup[1:10,1], las = 3)

#we are done making our pdf so finalize it
dev.off()

