#Read in Diabetes data
#recreate the subset orderset

library(plumber)
library(tidyverse)

diabetes_data <- as.tibble(read.csv("~/ST558 Repo/Final Project/model_data.csv", header = TRUE))
diabetes_model <- readRDS(file.path("~", "ST558 Repo", "Final Project", "best_diabetes_model.rds"))


#* @apiTitle Modeling Diabetes Data API
#* @apiDescription This API will work to test out making an API using the best model I created from diabetes survey data

