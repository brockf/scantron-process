#################################################################
#
# Scantron Processor
#
# Converts an ugly RESPONSES Scantron Excel file (converted to CSV) into a proper datasheet
# that can be correlated, curved, analyzed, etc.
# 
# (C) Copyright 2012, Brock Ferguson (brockferguson.com)
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#################################################################

scantron_process <- function() {
  ####################### Configuration ###########################
  
  # excel_folder
  # by default, the Excel file will be looked for in the current R working directory.
  # otherwise, specify the folder where the Excel ITEM report file is
  excel_folder <- getwd()
  
  # excel_file
  # The filename of the Scantron RESPONSES report (in the folder above) that has been exported
  # as a CSV file
  excel_file_csv <- 'midterm1-responses.csv'
  
  # grading_key
  # specify the correct answer for each of the questions in the exam, in ascending order
  grading_key <- c(
    'D','D','B','A','C','C','A','C','B','D',
    'B','C','B','A','A','A','D','A','C','D',
    'B','B','A','C','D','D','B','C','A','B',
    'A','B','B','B','C','B','A','D','C','A',
    'C','A','D','B','B','C','B','C','C','C'
    )
  
  ##################### End Configuration##########################
  
  # load CSV file as dataframe
  excel <- read.csv(paste(excel_folder,'/',excel_file_csv,sep=""))
  colnames(excel) <- c('Label','Value','Page')
  
  # create target dataframe
  processed <- data.frame(matrix(nrow=0,ncol=length(grading_key) + 2))
  colnames(processed)[1] <- 'Student'
  colnames(processed)[2] <- 'Total'
  
  for (i in 1:length(grading_key)) {
    colnames(processed)[i + 2] <- paste('Q',i,sep="")
  }
  
  # iterate through file
  for (i in 1:nrow(excel)) {
    row <- excel[i, ]
    
    if (row[, 'Label'] == 'Student Name') {
      student_row <- nrow(processed) + 1
      
      processed[student_row, 'Student'] <- as.character(row[, 'Value'])
    }
    else if (length(grep('Question[0-9]+', row[, 'Label'])) > 0) {
      question_number <- substr(row[, 'Label'], 9, 14)
      question_number <- as.integer(question_number)
      
      if (grading_key[question_number] == row[, 'Value']) {
        correct <- 1
      }
      else {
        correct <- 0
      }
      
      processed[student_row, paste('Q',question_number,sep="")] <- correct
    }
  }
  
  # tally totals
  processed$Total <- rowSums(processed[,1:length(grading_key) + 2])
  
  # sort by highest to lowest score
  processed <- processed[order(-processed$Total, processed$Student), ]
  
  # add column totals
  processed[nrow(processed) + 1, 1:length(grading_key) + 2] <- colSums(processed[,1:length(grading_key) + 2])
  
  write.csv(processed, 'processed.csv', row.names = FALSE)
}

