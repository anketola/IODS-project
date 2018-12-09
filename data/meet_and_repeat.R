# Antti Ketola, 9.12. Data wrangling for week 6.

# 1. Reading the BPRS and RATS datasets from GitHub

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

# Next exploring structure of the data, checking variable names etc
# First BPRS

library(dplyr)

names(BPRS)
str(BPRS)
summary(BPRS)
glimpse(BPRS)

# Then RATS

names(RATS)
str(RATS)
summary(RATS)
glimpse(RATS)

# Right now in wide format the BPRS has 40 observations and 11 variables. So basically each row contains 
# all the the measurements for a particular patient. The variables, on the other hand  (apart form subject and
# treatment ones), are the weekly results for the patient. RATS has 16 obs and 13 variables. The same idea regarding
# rows and columns apply to the RATS set here as described for BPRS.

# 2. Convert categorical variables of both data sets to factors

# For BPRS

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)


# For RATS
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Checking the data.. 
glimpse(RATS)


# 3. Convert the data sets to long form. Additionally we will
# add a week variable to BPRS and Time variable to RATS.

library(tidyr)

BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))


RATSL <- RATS %>% gather(key = WD, value = Weight, -ID, -Group) %>% mutate(Time = as.integer(substr(WD,3,4))) 

# 4. Taking look at the new (long) datas and comparing them to their wide form versions

names(BPRSL)
str(BPRSL)
summary(BPRSL)
glimpse(BPRSL)

names(RATSL)
str(RATSL)
summary(RATSL)
glimpse(RATSL)

# EXPLANATION OF THE DIFFERENCES BETWEEN WIDE AND LONG FORMATS

# Above you can see the explorations of the new long form dataset
# About the differences: both datasets have gone through considerable changse in terms of the data structures.
# We can see how the long form has now for BPRSL total of 360 observations and 5 variables. This is a major change 
# from the wide data of 40 observations and 11 variables. Rats on the other hand in the new long form 176 observations
# and total of 5 variables. This would be propably easier to just show as a graph, but as it has to be explained here,
# what has happened is that single observations in for example BSPR have are going now downwards, with each patient
# having multiple rows. This is a striking difference to the wide format where the observations for the patient
# are all in the same row. The same idea applies to RATS dataset. 


# (5.) Writing the datas to files

write.table(BPRSL, file="data/bprsl.csv", row.names=FALSE)
write.table(RATSL, file="data/ratsl.csv", row.names=FALSE)



