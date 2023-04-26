library(tidyverse)

# compute the bonus for each participant
bonus_files <- list.files("../../../data/raw/", pattern = "bonus", full.names = T)

df_bonus <- bonus_files %>% 
  map_dfr(~read_csv(.x, col_types = cols(.default = col_character())))

df_bonus <- df_bonus %>%
  filter(subject_ID != "subject_ID") %>%
  mutate(bonus = as.numeric(bonus)) %>%
  filter(bonus > 0) %>%
  select(subject_ID, bonus)

# turn into a csv file
write_csv(df_bonus, "bonus.csv")

# function to open a file, remove the subject ID,
# and save the data as a new file, while removing the old file
remove_ID <- function(file_name, old_ID, new_ID){
  # file_name: the rest of the file name, containing the directory names
  # old_ID: the original subject ID
  # new_ID: the new anonymous ID participants get
  
  old_file <- paste0(file_name, old_ID, ".csv")
  new_file <- paste0(file_name, new_ID, ".csv")
  
  # open the original file and replace the subject ID in the data
  d_tmp <- read_csv(old_file) %>%
    mutate(subject_ID = ifelse(subject_ID == "subject_ID", "subject_ID", new_ID))
  
  
  # save the modified data as a new file
  write_csv(d_tmp, file = new_file)
  file.remove(old_file)
  
}

# get a list of all subject IDs
subjectID_list <- list.files("../../../data/raw/", pattern = "main", full.names = FALSE)

subjectID_list <- subjectID_list %>%
  str_remove("PauseForThought_main_") %>%
  str_remove(".csv")

# go through the participants one by one
for (old_ID in subjectID_list){
  
  # each participant has four files
  file_name_list <- c("bonus", "main", "premature", "UPPSP")
  
  new_ID <- which(old_ID == subjectID_list)
  
  for (a_file in file_name_list) {
    
    file_name <- paste0("../../../data/raw/PauseForThought_", a_file, "_")
    
    remove_ID(file_name, old_ID, new_ID)
    
  }
}
