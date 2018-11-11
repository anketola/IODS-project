# Antti Ketola, 9.11.2018. Week 2 data wrangling exercise for Open Data Science course.

library(dplyr)

# reading the data
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# exploring the dimensions
dim(lrn14)
# comment on the output: the loaded data has 183 rows and 60 columns

# exploring the structures
str(lrn14)
# comment on the output: the output displays the structure of the data

# scaling the combination variables
lrn14$attitude <- lrn14$Attitude / 10

# combining questions
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# selectings colums for later analysis
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")
learning2014 <- select(lrn14, one_of(keep_columns))

# modifying column names for "Age" and Point" to lowercase
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

# excluding all observations where exam points is zero
learning2014 <- filter(learning2014, points != 0)

# saving the dataset to a file

write.csv(learning2014, file = "data/learning2014", row.names = FALSE)

# demonstring that the data is readable

newlearning2014 <- read.csv(file = "data/learning2014")

str(newlearning2014)
head(newlearning2014)

# based on the output, we have the the same data as when we saved it.


