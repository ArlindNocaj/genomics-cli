#! /bin/bash
for state in SUBMITTED PENDING RUNNABLE STARTING RUNNING
do 
    for job in $(aws batch list-jobs --job-queue TaskBatchJobQueueC19EF4-43ec483c8066e67 --job-status $state --output text --query jobSummaryList[*].[jobId])
    do 
        echo -ne "Stopping job $job in state $state\t"
        aws batch terminate-job --reason "Terminating job." --job-id $job && echo "Done." || echo "Failed."
    done
done
