# RF_MCMC
This is a trial to develop new approach of using combination of MCMC and RF for regression analysis of asphalt temperature with air temperature and depth.
“final_forest.m” is the code for the random forest algorithm. Running this code will train and test the random forest algorithm for the 
dataset with 70% data for training and 30% data for testing.
“final_MCMC.m” and “final_hybrid.m” are the codes for MCMC and the hybrid algorithm respectively.
All the codes can be run on the three versions of the original dataset.
“new_data.mat” is the dataset edited with no outlier points (outlier points taken inside data with interpolation). This data can be considered as ideal dataset with maximum of 100% accuracy can be achieved.
“new_data1.mat” is the dataset edited with keeping only the outliers within range of 10% error
To run the codes on original dataset (i.e. as it is on the data given in excel sheet) one needs to be uncomment the code lines of initial part of the code that contain lines reading excel sheet. The line which loads
“new_data.mat” or “new_data1.mat” must be commented in order to run
algorithms on original data.
The algorithms can be run on datasets other that the datasets in the
project with proper editions.
***************** Thank You *****************
