# publication quality graphics (5/24/16)
# Matthew J. Denny
# email mdenny@psu.edu with questions or comments

# In this script, I will provide several examples and seek to introduce you to
# the kinds of things one should always do to produce really clean plots for
# publication. I cannot possibly hope to cover every siutation, but I always
# find myself doing the same sorts of things whenever I make plots for
# publication. This is really where R shines. We will be using the base R
# graphics and ggplot2.

# install ggplot2 and gridExtra
# install.packages("ggplot2", dependencies = TRUE)
# install.packages("gridExtra", dependencies = TRUE)

# preliminaries
rm(list = ls())
library(ggplot2)
library(gridExtra)

# lets load in some "data" we will use in this tutorial
setwd("~/Dropbox/RA_and_Consulting_Work/ISSR_Data_Management_in_R_2016/Data/")
load("LaCour_Data.Rdata")
load("Influence_Data.Rdata")
load("Influence_Data_2.Rdata")

# now set the working directory where we would like to save plots
setwd("~/Desktop")

# this code is taken from:
# https://stanford.edu/~dbroock/broockman_kalla_aronow_lg_irregularities.pdf
# page 5.

# start by subsetting the data
lacour.therm.study1 <- subset(LaCour_Data,
                              wave == 1 & STUDY == "Study 1")$Therm_Level

# now lets look at it using a histogram:
hist(lacour.therm.study1,
     breaks = 101,
     xlab = "Feeling Thermometer",
     main = "LaCour (2014) Study 1, Baseline")

# what can we improve?

# one thing we could do would be to color the bars. However the base colors in R
# are not always the prettiest, fortunately, we can create our own! I did this
# using the color pallette available on this website:
# http://www.umass.edu/webdev/tools_colors.html
# and I use these colors in all of my plots that allow color. To define a color
# we will use the rgb() function. We can see how this works by typing the
# following into our console:
?rgb()

# to convert hex to rgb we can use: http://hex.colorrrs.com/

# now lets give it a try
UMASS_BLUE <- rgb(51,51,153,195,maxColorValue = 255)
UMASS_RED <- rgb(153,0,51,195,maxColorValue = 255)
UMASS_GREEN <- rgb(0,102,102,195,maxColorValue = 255)
UMASS_YELLOW <- rgb(255,255,102,255,maxColorValue = 255)
UMASS_ORANGE <- rgb(255,204,51,195,maxColorValue = 255)
UMASS_PURPLE <- rgb(65,39,59,195,maxColorValue = 255)
UMASS_BROWN <- rgb(148,121,93,195,maxColorValue = 255)

# now lets try to fill in some additional parameters. We can start to do this by
# looking at the documentation available by typing in:
?hist()

# now give a couple of additional arguments a try:
hist(lacour.therm.study1,
     breaks = 101,
     ylab = "Number of Respondents",
     xlab = "Feeling Thermometer",
     main = "LaCour (2014) Study 1, Baseline",
     col = UMASS_BLUE,
     ylim = c(0,2000))

# my preffered way of exporting plots for inclusion in a LaTeX document is as a
# pdf. We can do this as follows:
pdf(file = "Example_Histogram.pdf",
    height = 4,
    width = 8)
hist(lacour.therm.study1,
     breaks = 101,
     ylab = "Number of Respondents",
     xlab = "Feeling Thermometer",
     main = "LaCour (2014) Study 1, Baseline",
     col = UMASS_ORANGE,
     ylim = c(0,2000))
dev.off() # ends the plot

# the key here is to get the dimensions correct.

# lets try another example from a paper I wrote:
# http://papers.ssrn.com/sol3/papers.cfm?abstract_id=2465309

plot(x = data$Congress, y = data$Floor_Amendments)

g1 <- ggplot(data , aes(x = Congress, y = Floor_Amendments)) +
    geom_point() + stat_smooth(method = lm) +
    ylab("Successful Floor Amendments") +
    xlab("Session of Congress") +
    scale_x_continuous(name = "Session of Congress",
                       breaks = 1:12,
                       minor_breaks = waiver(),
                       labels = 97:108)

g2 <- ggplot(data , aes(x = Congress, y = Connectedness)) +
    geom_point() + stat_smooth(method = lm) +
    ylab("Connectedness") +
    xlab("Session of Congress") +
    scale_x_continuous(name = "Session of Congress",
                       breaks = 1:12,
                       minor_breaks = waiver(),
                       labels = 97:108)

g3 <- ggplot(data , aes(x = Congress, y = Influence)) +
    geom_point() + stat_smooth(method = lm) +
    ylab("Influence") +
    xlab("Session of Congress") +
    scale_x_continuous(name = "Session of Congress",
                       breaks = 1:12,
                       minor_breaks = waiver(),
                       labels = 97:108)

# generate the plot
pdf("Example_Multiple_Plot.pdf", width = 12, height = 4)
# you can check out ?grid.arrange() for how this works. We need to use this
# function to arrange ggplot objects as opposed to par()
grid.arrange( g1, g2, g3, ncol = 3)
dev.off()


# now lets try a more complicated example where we run a regression for each
# session of congress then plot the resulting parameter estimates together.

# we are going to work through sessions of congress starting with the 97th. We
# do this first iteration outside of the loop and then complete using a loop.
i <- 97

# subset the data
cur_data <- data2[which(data2$Congress == i),]

# fit a linear model
fit <- lm(formula = "Connectedness ~ Seniority + NOMINATE + NOMINATE_SQ +  In_Majority + Committee_Chair", data = cur_data )

# we can look at the output
summary(fit)

# create a session variable which we will add on to our coefficients
Session <- rep(i,5)

# column bind them together
Session_Regression_Coefficients <- cbind(summary(fit)$coefficients[2:6,],
                                         Session)

# take a look!
print(Session_Regression_Coefficients)

# now we loop over the remaining sessions of Congress.
for (i in 98:108) {
    # let the user know what iteration we are on
    cat("Currently working on session:",i,"\n")

    # subset the data to the current session
    cur_data <- data2[which(data2$Congress == i),]

    # fit a linear model
    fit <- lm(formula = "Connectedness ~ Seniority + NOMINATE + NOMINATE_SQ +  In_Majority + Committee_Chair", data = cur_data )

    # add in session variable
    Session <- rep(i,5)

    # create the data frame we will add on to the existing
    # Session_Regression_Coefficients data.frame
    addition <- cbind(summary(fit)$coefficients[2:6,],Session)

    # add on our addition using rbind
    Session_Regression_Coefficients  <- rbind(Session_Regression_Coefficients ,
                                              addition)
}

# get the row names of Session_Regression_Coefficients and use these as lables
Variable <- rownames(Session_Regression_Coefficients)

# create a data frame using stringsAs stringsAsFactors = F
Session_Regression_Coefficients <- data.frame(Session_Regression_Coefficients,
                                              Variable,
                                              stringsAsFactors = F)

# create confidence interval z values
interval1 <- -qnorm((1-0.9)/2)  # 90% multiplier
interval2 <- -qnorm((1-0.95)/2)  # 95% multiplier

# make the plot!
pdf(file = "Connectedness_Regression_Coefficients.pdf",
    width = 18,
    height = 4)
# plot coefficients faceted by Variable type
ggplot(Session_Regression_Coefficients, aes(x = Session, y = Estimate))  +
    facet_grid(. ~ Variable, scales = "free") +
    geom_point(shape = 19,color = UMASS_BLUE) +
    geom_hline(yintercept = 0, colour = gray(1/2), lty = 2) +
    geom_linerange(aes(x = Session, ymin = Estimate - Std..Error*interval2,
                       ymax = Estimate + Std..Error*interval2)) +
    #geom_smooth( method="lm", fullrange=TRUE) +
    ylab("Parameter Estimate") +
    xlab("Session of Congress")
dev.off()
