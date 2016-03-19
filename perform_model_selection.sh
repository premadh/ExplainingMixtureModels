#!/usr/bin/bash
# Bash script to run BernoulliMix Mixture Modelling Training 
#
# (c) Prem Raj Adhikari
#     www.premraj.me
#     August, 2015

# Check for the presence of directory, otherwise try to create it. 
# We need delete the earlier results if folder exists because 
# we will append results to the previous files 

if [ -d "models" ]
then
    echo "Folder models exists. Deleting earlier results"
    rm models/tlkhood*.txt models/vlkhood*.txt
else
    echo "Folder model does not exist. Creating one"
    mkdir models
fi

# The training of mixture models

for cmp in {2..20} # Number of clusters, i.e components in the mixture models to try 
do
	echo "Training Model with components ${cmp}"
	for rpt in {1..50}	# Number of repeats of the training 
	do
		for k in {1..10} # Number of folds in k-fold cross-validation
		do
			# Train the models using training set
			aaa=$(bmix_train -f train${k}.data -t 10000 -r 0.00001 -o models/mdl${cmp}_${k}.model  -c ${cmp} -e ${cmp})
			
			# Calculate the Training and Test Likelihood of the tested model, store them in the array
			tlkhood[$k]=$(bmix_like -f train${k}.data -i models/mdl${cmp}_${k}.model  --total-likelihood)
			vlkhood[$k]=$(bmix_like -f test${k}.data -i models/mdl${cmp}_${k}.model  --total-likelihood)
			
		done
		
	# Append the likelihoods in the file	
	echo  ${tlkhood[@]} >> models/tlkhood${cmp}.txt
	echo  ${vlkhood[@]} >> models/vlkhood${cmp}.txt
	done
done


