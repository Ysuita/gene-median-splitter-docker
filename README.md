This program is to categorize patients based the gene expression of gene of interest (ex. MYC). 
Particurally, this creates 2 cohorts of patients ("high" and "low") by using median. 

gene-median-spliter.ipynb arg1 arg2 arg3 

arg1: input matrix (ex. /sbgenomics/project-files/downsyndrome-gene-counts-rsem-expected_count-collapsed.tsv)
arg2: output matrix of "high" patients (ex. "/sbgenomics/output-files/downsyndrome_testhigh.csv")
arg3: output matrix of "low" patients (ex. "/sbgenomics/output-files/downsyndrome_testlow.csv")

Build a Container for the gene-median-splitter-docker

Steps to build this docker container.

Set up GitHub Actions
To build your image from the command line:

Can do this on Google shell - docker is installed and available
```
docker build -t gmdsd .
```
To test this tool from the command line

Set up an environment variable capturing your current command line:
```
PWD=$(pwd)
```
Then mount and use your current directory and call the tool now encapsulated within the environment.

```
docker run -it -v $PWD:$PWD -w $PWD gmsd Rscript gene-median-splitter.R
```
