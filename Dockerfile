# start from the rstudio/plumber image
FROM rstudio/plumber

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y  libssl-dev  libcurl4-gnutls-dev  libpng-dev pandoc 
    
    
# install plumber, tidyverse
RUN R -e "install.packages(c('tidyverse', 'plumber', 'tidymodels'))"

# Set working directory inside container
WORKDIR /app

#copy necessary files 
COPY plumber.R /app/plumber.R
COPY model_data.rds /app/model_data.rds
COPY best_diabetes_model.rds /app/best_diabetes_model.rds

# Expose port 8000 for API
EXPOSE 8000

# when the container starts, start the plumber.R script
ENTRYPOINT ["R", "-e", \
    "pr <- plumber::plumb('plumber.R'); pr$run(host='0.0.0.0', port=8000)"]

