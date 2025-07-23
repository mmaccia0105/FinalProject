# Use rocker/r-ver as base image 
FROM rocker/r-ver:4.2.3

# Install necessary R packages
RUN R -e "install.packages(c('plumber', 'tidyverse'), repos='https://cran.r-project.org')"

# Set working directory inside container
WORKDIR /app

#copy necessary files 
COPY plumber.R /app/plumber.R
COPY model_data.rds /app/model_data.rds
COPY best_diabetes_model.rds /app/best_diabetes_model.rds

# Expose port 8000 for API
EXPOSE 8000

# Run the plumber API on container start
CMD ["R", "-e", "pr <- plumber::plumb('plumber.R'); pr$run(host='0.0.0.0', port=8000)"]

