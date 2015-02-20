# CourseraCleaningDataProject
Repo for Coursera Getting and Cleaning Data project code, February 2015 https://class.coursera.org/getdata-011/

The code in this repository, contained in run_analysis.R combines data from a multi-file data set containing smart phone sensor readings from a variety of basic human activities.  The dataset can be found here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The code combines data extracted from 6 files in particular:
 * test/subject_test.txt -- holds ID for person wearing smartphone
 * test/y_test.txt -- holds enumeration value of activity engaged in during measurements
 * test/X_test.txt -- holds large set of measurements, described as "features" in the original data documentation
 * train/subject_train.txt
 * train/y_train.txt
 * train/X_train.txt

For efficiency, only the features we are interested in (columns with "mean" and "std" data) are ever read from the X_*.txt files.  These measurements are combined with the categorical subject and activity columns, and the test and training data is in turn combined into one large data frame.

After adjusting column names and substituting in meaningful activity names for the enumerated value, the large dataframe is then arranged into groups by activity then subject ID and the mean measurement for each of these subgroups is computed and output to a tidy data text file "getdata-011_projTidy.txt"

The final tidy output follows the following principles:
1. Each measured variable is in one column
2. Each different observation (mean per activity/subject grouping) is on a different row
3. One file per table (just one table, so one file)
4. Variable names human readable and cleaned of non-alpha characters
5. Header row at top clearly names columns

The individual measurements are discussed in detail in the accompanying CodeBook.md, including explanations and units.

The tidy data can be read into R with read.table(header=TRUE)

References:
https://class.coursera.org/getdata-011/forum/thread?thread_id=248