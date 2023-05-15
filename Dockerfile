# Full contents of Dockerfile
FROM rocker/tidyverse
LABEL description="Base docker image with tidyverse and hence R and util libraries"
ARG ENV_NAME="gmsd"

# Install dependencies if any needed -- this is a template
# Since our base image is an R docker base we will use BiocManager install

RUN apt-get update && \ 
    R -e "install.packages(c('BiocManager'), repos='https://cloud.r-project.org/');BiocManager::install('package-name-here')" && \
    apt-get clean -y


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
ADD ./your-script-name.R /usr/local/bin/

RUN chmod +x /usr/local/bin/your-script-name.R


