# Blast example against Silva database for Amazon Genomics CLI

A basic Blast pipeline using Nextflow and a local *.fa file. 
It runs also using Amazon Genomics Cli. 

## Get started

* Follow [Getting Started for Genomics CLI](https://catalog.us-east-1.prod.workshops.aws/v2/workshops/fa1442ae-312d-4d8c-93f9-f925b7385c34/en-US/01-introduction)
* Upload silva blast db to your s3 bucket
* Add your s3 bucket to `agc-project.yaml`
* Modify the s3 urls in `main.nf` to point to your specific bucket with the silva database
* Deploy agc context: `agc context deploy --context onDemandContext`
* Run the workflow with genomics cli: `agc workflow run blast-silva --context onDemandContext`

## Dependencies 

* Java 8 or later 
* Docker 1.10 or later 
