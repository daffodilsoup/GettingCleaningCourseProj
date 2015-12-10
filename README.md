Getting and Cleaning Data Course Project
===========================================
This is the writeup for the course project for the Getting and Cleaning Data course on Coursera. This script utilizes data from Running the R Script ```runAnalysis.R``` will do the following:

- Read in the raw data tables if they are available in the working directory
- Read all files into separate tables
- Combines test and training data and assigns the appropriate column headers
- Filters down to include only columns which contain a ```mean``` or a ```standard deviation``` for that variable
- Generally tidies the dataset, providing readable column names
- Creates a separate clean dataset that includes the average value of each variable for each distinct subject and activity.

The independent tiny dataset is shown in the file ```tidy_data.txt```.
