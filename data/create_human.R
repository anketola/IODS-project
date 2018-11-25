# Antti Ketola, 25.11.2018. This is the data wrangling script for week 4 workshop.

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

# Reading it once more and checking it

human_check = read.csv("data/human.csv")
str(human_check)





