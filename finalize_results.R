#!/usr/bin/Rscript
# R script to generate results and plot it 
#
# (c) Prem Raj Adhikari
#     www.premraj.me
#     August, 2015

# Initialize a  19 by 6 matrix to store the results
finLkhood <- matrix(0, 19, 6)

# Loop over the number of components in the mixture model
for(i in 2:20)
{
	# Read the training likelihood file
	trlkhood <- read.table(paste("models/tlkhood",i,".txt",sep=""),
	sep=" ", header=FALSE, row.names=NULL)
	
	# Store the mean training likelihood in first column 
	finLkhood[(i-1),1] <- mean(colMeans(trlkhood))
	
	# Store dispersion i.e. IQR changes with respect to mean in 2 and 3rd Column 
	finLkhood[(i-1),2] <- finLkhood[(i-1),1]-IQR(colMeans(trlkhood))
	finLkhood[(i-1),3] <- finLkhood[(i-1),1]+IQR(colMeans(trlkhood))
	
	# Read the validation likelihood file
	vllkhood <- read.table(paste("models/vlkhood",i,".txt",sep=""),
	sep=" ", header=FALSE, row.names=NULL)
	
	# Store the mean validation likelihood in 4th column 
	finLkhood[(i-1), 4] <- mean(colMeans(vllkhood))
	
	# Store dispersion i.e. IQR changes with respect to mean in 5th and 6th Column 
	finLkhood[(i-1),5]<-finLkhood[(i-1),4]-IQR(colMeans(vllkhood))/4
	finLkhood[(i-1),6]<-finLkhood[(i-1),4]+IQR(colMeans(vllkhood))/4
}


# Plot the results and save it to a file

#pdf("model_selection_tweets.pdf", height=7, width=10)

# Set to eps for better quality pictures and ease of using with LaTeX
setEPS()
postscript("model_selection_artificial_data_10_per_noise_1.eps", height=7, width=10)

# Larger margins 
par(mar = c(6,6,4,2) + 0.1)

# Adjust axis label locations relative to the edge of the inner plot window.
par(mgp = c(4.5, 1, 0))

#Plot the results 
matplot(2:20, finLkhood, 
type="o",col=c("red","green","green","blue","black","black"), #Colors of six lines
lty=c(1,5,5,1,5,5), # Line type for mean and dispersion are same
pch=c(15,8,8,2,1,1), # Different symbols for lines
las=2, # labels are perpendicular to axis
lwd= c(1.2,0.8,0.8,1.2,0.8,0.8), # width of lines 
xlab="Number of Components in Mixture Model", # x-axis labels
cex.lab=1.9,cex.main=2,cex.axis=1.3, # Increase default font sizes
main="Model Selection in Artificial Dataset", # Plot title 
ylab="Log Likelihood", # Y-axis labels
# suppress the x-axis 
xaxt='n')

# Add legend to top left
legend("topleft", legend=c("Training Likelihood","Training IQR","Test Likelihood",
"Test IQR"), cex=1, pch=c(15,8,2,1), col=c("red","green","blue","black"),
lty=c(1,5,1,5),)

# Add the x-axis as it was supressed
axis(1, 2:20, 2:20,par("usr")[2] - 0.2, col.axis = "blue", padj=1)

dev.off() # Close the axis device

