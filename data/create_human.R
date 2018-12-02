# Antti Ketola, 29.11.2018. This is the data wrangling script for week 5 workshop.
# This script continues week 4 script - The week 5 part is at the bottom, starting from a comment indicating week change
# The script will continue to work on the human.CSV file that is created during week 4 wrangling


# --- WEEK 4 Data wrangling ----

# Reading the two datasets from the given links

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Exploring the structure and dimensions of the data, create summaries of the variables

str(hd)
dim(hd)
summary(hd)

str(gii)
dim(gii)
summary(gii)

# Renaming variables with descriptive (shorter) names

colnames(hd)

colnames(hd) <- c("HDIRank", "Country", "HDI", "LifeExp", "EduExp", "EduMean", "GNI", "GNIminusRank" )

colnames(gii)

colnames(gii) <- c("GIIRank", "Country", "GII", "MatMorRatio", "AdoBirth", "ParliamentF", "Edu2F", "Edu2M", "LabourF", "LabourM" )

# Mutating the gender inequality data (GII) to create two new variables Edu2Ratio and LabourRatio

library(dplyr)

gii <- mutate(gii, Edu2Ratio = Edu2F / Edu2M)
gii <- mutate(gii, LabourRatio = LabourF / LabourM)

# Joining the two datasets using Country as identifier with inner join

human <- inner_join(hd, gii, by = "Country")

# Checking that the data joined has 195 observations and 19 variables

str(human)

# ..which it has

# Saving the new joined data in the data folder

write.csv(human, file = "data/human.CSV", row.names = FALSE)

# --- WEEK 5 Data wrangling ----

# Loading the data again from the file this script worked on before

human <- read.csv("data/human.csv")

# Note, explanations of the variables and the data will be in the diary 
# (it appears to me the assignment part was in the wrong place)
# Exploring the structure and dimensions of the data, Checking that the data has correctly 195 obs. and 19 var.

str(human)
dim(human)
summary(human)

# Mutating, transforming the GNI variable to numeric

library(stringr)

human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

# Keeping only the wanted variables, In this dataset, as renamed in week 4, the variables to keep are:
# Country, Edu2Ratio, LabourRatio, EduExp, LifeExp, GNI, MatMorRatio, AdoBirth, ParliamentF

keep <- c("Country", "Edu2Ratio", "LabourRatio", "LifeExp", "EduExp", "GNI", "MatMorRatio", "AdoBirth", "ParliamentF")
human <- select(human, one_of(keep))

# Removing all rows with missing values

human <- filter(human, complete.cases(human))

# Removing observations which relate to regions instead of countries

# Taking look at the last 10 obsv, choosing last indice we want to keep and choosing all until that

tail(human, 10)
last <- nrow(human) - 7
human <- human[1:last, ]

# Defining row names of data by the country name

rownames(human) <- human$Country

# And removing the country column..

human <- select(human, -Country)

# The dataset should now have 155 obsv. and 8 variables, confirming this next

str(human)

# And as confirmed, it has 155 obsv. and 8 variables.
# Saving the data including row names, overwriting the old CSV

write.csv(human, file = "data/human.csv", row.names = TRUE)

