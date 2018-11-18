# Antti Ketola, 18.11.2018. This is the data wrangling script for week 3 workshop.

library(dplyr)

# Reading the data of student-por.csv and student-mat.csv
mat <- read.table("data/student-mat.csv", sep = ";", header=TRUE)
por <- read.table("data/student-por.csv", sep = ";", header=TRUE)

# Next we explore the structure and dimensions of the data:

str(mat)
dim(mat)

# The commands give the structue and the dimensons of mat data (395 rows, 33 columns)

str(por)
dim(por)

# The commands give the structue and the dimensons of por data (649 rows, 33 columns)

# As the next step we will join the two sets using school, sex, age, address, famsize
# Pstatus, Medu, Fedu, Mjob, Fjob, reason, nursery and internet as identifiers

# we start by creating an object "join_by"

join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Fedu", "Medu", "Mjob", "Fjob", "reason", "nursery", "internet")

# Next we use the inner_join(function) to combine the to datasets

mat_por <- inner_join(mat, por, by = join_by, suffix = c(".mat", ".por"))

# Then we remove the duplicate answers in the joined data, we use the same method as in DataCamp

alc <- select(mat_por, one_of(join_by))

notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]

for(column_name in notjoined_columns) {
  two_columns <- select(mat_por, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  
  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(two_columns))
  } else {
    alc[column_name] <- first_column
  }
}

# Next we create a new column alc_use as an average of weekday and weekend consumption using mutate command

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# We also create a new logical column high_use, with value TRUE in case alc_use > 2, otherwise FALSE

alc <- mutate(alc, high_use = alc_use > 2)

# Finally, we will have a glimpse at the data using glimpse function

glimpse(alc)

# The function indiates there is now 382 observations and 35 variables. Everything seems to be in order.

# As the last step we save the modied data to the data folder

write.csv(alc, file = "data/alc.CSV", row.names = FALSE)




