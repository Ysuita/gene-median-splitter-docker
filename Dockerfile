# Use an existing R Docker image as the base
FROM rocker/r-ver:4.1.0
LABEL description="Base docker image with dplyr and ggplot2"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev

# Install required R packages
RUN R -e "install.packages(c('dplyr', 'ggplot2'), repos = 'https://cloud.r-project.org/')"

# Copy your R script to the Docker image
ADD ./MycHighLow.R /usr/local/bin/

# Set the working directory
WORKDIR /app

# Run your R script
RUN chmod +x /usr/local/bin/MycHighLow.R

#
# Jupytext can be used to convert this to a a notebook
# as a script it can be used in a workflow
#
# to run as a script you can use Rscript Rscript
#
# you need to put your R script from the local directory into
# an accessible location for execution at the command line with
# the docker file
#




