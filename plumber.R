
#* @apiTitle Diabetes Prediction API
#* @apiDescription This API predicts the probability of prediabetes or diabetes from some lifestyle predictions.

library(plumber)
library(tidyverse)
#pull in data and model from modeling pages
diabetes_api <- readRDS("~/ST558 Repo/Final Project/model_data.rds")
diabetes_model <- readRDS("~/ST558 Repo/Final Project/best_diabetes_model.rds")

#create our default values
default_values <- diabetes_api |> 
  summarise(across( #summarize all variables
    c(veggies, exercise, alcohol_use, bmi),
    ~ names(sort(table(.x), decreasing = TRUE))[1] #get the most common response from each column
  )) |> 
  as.list() #make it a list for later

print(default_values) #can check in console results

#* Predict probability of diabetes
#* @param veggies Whether patient eats veggies (Yes/No)
#* @param exercise Whether patient exercises (Yes/No)
#* @param alcohol_use Whether patient uses alcohol (Yes/No)
#* @param bmi BMI category (Underweight, Healthy Weight, Overweight, Class 1 Obesity, Class 2 Obesity, Severe Obesity)
#* @get /pred
function(veggies = default_values$veggies, #function to take input, default was created above
         exercise = default_values$exercise,
         alcohol_use = default_values$alcohol_use,
         bmi = default_values$bmi) {
  
  #Construct a single-row tibble for prediction
  #match facotr values from before
  new_data <- tibble( 
    veggies = factor(veggies, levels = levels(diabetes_api$veggies)),
    exercise = factor(exercise, levels = levels(diabetes_api$exercise)),
    alcohol_use = factor(alcohol_use, levels = levels(diabetes_api$alcohol_use)),
    bmi = factor(bmi, levels = levels(diabetes_api$bmi))
  )
  
  # Predict probability of diabetes = Yes from above inputs
  prob <- predict(diabetes_model, new_data, type = "prob")$.pred_Yes #probability for yes
  list(predicted_probability = round(prob, 4)) #round to 4 and return a named list
}

#* Info endpoint with author and GitHub Pages URL
#* @get /info
function() {
  list(
    author = "Mike Maccia",
    github_pages = "https://mmaccia0105.github.io/FinalProject/EDA.html"
  )
}

# Example function calls:
# 1. Predict with veggies = "No", exercise = "Yes", alcohol_use = "No", bmi = "Overweight"
# httr::GET("http://127.0.0.1:16883/pred?veggies=No&exercise=Yes&alcohol_use=No&bmi=Overweight")

# 2. Predict with veggies = "Yes", exercise = "Yes", alcohol_use = "Yes", bmi = "Healthy Weight"
# httr::GET("http://127.0.0.1:16883/pred?veggies=Yes&exercise=Yes&alcohol_use=Yes&bmi=Healthy%20Weight")

# 3. Predict with veggies = "No", exercise = "No", alcohol_use = "No", bmi = "Severe Obesity"
# httr::GET("http://127.0.0.1:16883/pred?veggies=No&exercise=No&alcohol_use=No&bmi=Severe%20Obesity")


