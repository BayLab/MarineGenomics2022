###Week4 Lesson

## Lines that start with a # will not be executed in R
## So we often start comment lines with a #
## Comments help you to remember what you did and why you did it.
## We recommend you comment profusely!

#################################
##### 4.2 ORIENTATION TO R  #####
#################################

## R can be used for basic arithmetic



## It can also store values in variables
 # assign an object using <-, =


 # see that object


 # objects can be numbers, characters


## We can make vectors using c() to concatenate
 # vectors can include numbers


  # we can use colons to get sequences of numbers


 # vectors can include characters (in quotes)


## Manipulating a vector object 
 # We can get summaries of vectors


  # we can see how long a vector is


  # use [] to get parts of vectors


## Operations act on each element of a vector
  # +2


  # *2


  # mean


  # ^2


## Operations can also work with two vectors
  # x + y


  # x * y


## We can keep track of what objects R is using, with the functions ls() and objects()
 # how to get help for a function


 # you can get rid of objects you don't want
  # rm()

 # and make sure it got rid of them


## remember annotate your code! For you and so you can share

            # EXERCISE 1.1 # 


########################################
##### 4.3 CHARACTERIZE A DATAFRAME #####
########################################

#useful functions: install.packages(), library(), data(), str(), dim(), colnames(), rownames()
                 # class(), as.factor(), as.numeric(), unique(), t(), max(), min(), mean(), summary()


## Install a package; We're going to use the package ggplot2. This package is for plotting but also contains a few datasets


## Call library(package)

library("ggplot2")

## We're going to use data on msleep
 # load the data (it's called msleep)


 # See what this data looks like
  # head(), tail()


  # str()


  # data from packages usually has additional info like a function


  # dim(), ncol(), nrow()


  # colnames(), rownames()


  # Rstudio allows us to View() the data



## Classes of data & subsetting datasets
## How to access parts of the data
 # one element


 # one column


 # one row


 # we can look at a single column at a time
  # there are three ways to access this $, [,#], [,"a"]


  # sometimes it is useful to know what class() the column is


 # we can look at a single row at a time
  # there are two ways to access this [#,], ["a",]


## we can select more than one row or column at a time
 # see two columns


 # and make a new data frame from these subsets


## But what if we actually care about how many unique things are in a column?
 # unique()


 # table()


 # levels(), if class is factor



## If your data is transposed in a way that isn't useful to you, you can switch it.
##  note that this often changes the class of each column!
##  In R, each column must have the same type of data
 # t()


## It's important to know the class of data if you want to manipulate it.
##   for example, you can't add characters!
## msleep is made of many types of data
##   some common classes are: factors, numeric, integers, characters, logical
 # class()


 # str()


## Often we want to summarize data
 # calculate mean() of a column


 # max()


 # min()


 # summary()


## Sometimes, the values we care about aren't provided in a data set. When this happens, we can create a new column

# what if what we cared about was our sleep_total/sleep_rem ratio?
# add a sleep_total/sleep_rem ratio column to our msleep dataframe with $




# look at our dataframe again


          ## EXERCISE 1.2 ##


##############################################
##### 4.4 SUBSETTING DATASETS & LOGICALS #####
##############################################

# useful commands: "==", "!=", ">", "<", "&", "|", which

# Reminder: assignment operators in R 
 # <-
 # =

## logical conditions vs. assignment operators
 # logical values of TRUE and FALSE are special in R


 # What class is a logical value?


 # Logical values are stored as 0 for FALSE and 1 for TRUE
 #  so you can do math with them
  # sum()


## logicals will be the output of various tests
 # equals


 # does not equal


 # greater than


 # less than


 # combining logical conditions with and (&), or(|)

 
 # we can take the opposite of a logical by using !



### Testing for conditions can be extended to vectors and columns of data frames
 # Which numbers in 1:10 are greater than 3?


 # How many numbers in 1:10 are greater than 3?


# in our msleep data frame, which species have total sleep greater than 18 hours?
# reload the msleep data with library(ggplot2) and data(msleep) if you need to


# Using which() to identify which rows match the logical values (TRUE) and length to count how many species there are


# which four species are these?


# what if we only want to see the bats that sleep more than 18 hours per 24 hour period?


      ### EXERCISE 1.3 ###


# next week we'll be making plots, doing for loops, and the apply family of functions!

