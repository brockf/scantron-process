scantron-process (R script)
================

Create a clean analysis ready for analysis from a Scantron "response" Excel file report (for academics who use Scantron for multiple-choice exams).

INSTRUCTIONS:

	1) Open your "*-RESP.xlsx" Scantron RESPONSES report in Excel.
	
	2) Save as a .CSV file.
	
	3) Configure the excel_folder and excel_file_csv variables (below) in this R script, to
	   point to this CSV file.  By default, it will look for excel_file_csv in your current working
	   directory.

	4) Run scantron_process() to create your new analyzeable datafile.  It will output a "processed.csv" in your R
	   working directory with each student as a row, each question as a column, 1's and 0's marking correct/incorrect,
	   and total scores tallied for each question and student.