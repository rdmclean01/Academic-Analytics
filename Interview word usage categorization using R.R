################################################################################
# Author: Ryan McLean, (801) 680-1086
# This code was built for Peter Reschke to automate the emotion coding process
################################################################################
setwd("C:/Users/ryan.mclean/Box/ZZ Personal Files/Storybook")
# Libraries and packages
if(!require(tidyverse)) install.packages("tidyverse"); library(tidyverse)
if(!require(officer)) install.packages("textreadr"); library(officer)
if(!require(rstudioapi)) install.packages("rstudioapi"); library(rstudioapi)
if(!require(stringr)) install.packages("stringr"); library(stringr)
if(!require(qdapRegex)) install.packages("qdapRegex"); library(qdapRegex)
if(!require(zoo)) install.packages("zoo"); library(zoo)
if(!require(readxl)) install.packages("readxl"); library(readxl)
if(!require(tidyr)) install.packages("tidyr"); library(tidyr)

# Import Relevant Locations and Auxiliary Files
keyword_path <- rstudioapi::selectFile(caption = "Select an excel file with your keywords", filter = "Excel Files (*.xlsx)")
rawFile_path <- rstudioapi::selectDirectory(caption = "Select the folder with your transcript files")
keywords <- readxl::read_xlsx(keyword_path,sheet = "keywords")
page_lookup <- readxl::read_xlsx(keyword_path,sheet = "pages")

# Clean up the Auxiliary files
## Keywords
keywords_spelling <- names(keywords[grepl("Spelling",names(keywords))]) # Get the column names for different spellings
keywords$str_regex = apply(keywords[,keywords_spelling],1,function(x) paste(x[!is.na(x)],collapse = "|")) # Paste it all together for grepl()
keywords <- keywords %>%
  mutate(
    Category = stringr::str_to_lower(Category),
    Main = stringr::str_to_lower(Main),
    str_regex = stringr::str_to_lower(str_regex),
  )
## Page Lookup
page_lookup <- page_lookup %>%
  mutate(
    Target_Emotion = str_to_lower(Target_Emotion),
    Target_Emoter = str_to_lower(Target_Emoter),
    Target_Object = str_to_lower(Target_Object)
  )


# For every file in the directory
df_long_full <- data.frame()
filePaths <- list.files(path = rawFile_path)
for (currDoc in filePaths) {
  if(FALSE){currDoc = filePaths[[1]]}
  print(paste0("Processing ",currDoc))
  full_path <- paste0(rawFile_path,"/",currDoc)
  raw_contents <- select(officer::docx_summary(officer::read_docx(full_path)),text)
  clean_contents <- raw_contents %>%
    mutate(
      # Define Student
      studentID = currDoc,
      # Make contents Lowercase
      text = stringr::str_to_lower(text),
      # Extract Speaker
      Speaker = ifelse(grepl("child:",text),"Child",
                       ifelse(grepl("parent:",text),"Parent","Other")),
      # Extract Page 
      Page = qdapRegex::ex_between(text,"[page","]"),
      # Clean up Text
      text = qdapRegex::rm_between(text,"\"","\""), # Remove url from text
      text = gsub("child:|parent:|note:|hyperlink","",text), # Remove speaker from text
      text = gsub("[0-9]+:[0-9]+","",text), # Remove Timestamp from text
      text = gsub("\\[page [0-9]+\\]","",text),
      text = stringr::str_trim(text,side = "both"), # Clean up Whitespace
    ) %>%
    # Fill in the Page Profile from the Row above
    dplyr::do(zoo::na.locf(.)) %>%
    filter(
      !is.na(Page),
      Speaker %in% c("Child","Parent")
    )
  # Combine Contents based on ID, Speaker, and Page
  grouped_contents <- clean_contents %>%
    group_by(studentID,Speaker,Page) %>%
    summarize(
      text = toString(text),
      .groups = "drop_last"
    ) %>%
    mutate(
      # Count the total number of words but first remove instances of [[corrected_word]]
      total_word_count = stringr::str_count(
        stringr::str_trim(gsub(" \\[\\[[A-Za-z0-9]+\\]\\]","",text),side="both"),"\\S+")
    )
  
  # Emotion Words
  #. Get the list of Emotion Words to Count
  emotion_words <- keywords$Main[keywords$Category == "emotion"]
  if(FALSE){emotion_words <- sample(emotion_words,3)}
  #.Count the Emotion Words
  for (emot in emotion_words) {
    if(FALSE){emot = "joy"} # Default Value
    col = paste0("count_",emot)
    words = keywords$str_regex[keywords$Main == emot]
    grouped_contents <- grouped_contents %>%
      mutate(
        # Dynamically reference column name
        emotion = stringr::str_count(text,words)
      )
    names(grouped_contents)[grep("emotion",colnames(grouped_contents))] = col
  }
  
  # Emoter Words
  emoter_words <- keywords$Main[keywords$Category == "emoter"]
  for (emoter in emoter_words) {
    if(FALSE){emoter = "male"} # Default Value
    col = paste0("count_",emoter)
    words = keywords$str_regex[keywords$Main == emoter]
    grouped_contents <- grouped_contents %>%
      mutate(
        # Dynamically reference column name
        emoter = stringr::str_count(text,words)
      )
    names(grouped_contents)[grep("emoter",colnames(grouped_contents))] = col
  }
  
  # Object Words
  object_words <- keywords$Main[keywords$Category == "object"]
  for (object in object_words) {
    if(FALSE){object = "page_1_16"} # Default Value
    col = paste0("count_",object)
    words = keywords$str_regex[keywords$Main == object]
    grouped_contents <- grouped_contents %>%
      mutate(
        # Dynamically reference column name
        object = stringr::str_count(text,words)
      )
    names(grouped_contents)[grep("object",colnames(grouped_contents))] = col
  }
  
  # Bind the data for each file together
  df_long_full <- bind_rows(
    df_long_full,
    grouped_contents
  )
}

df_long_full <- df_long_full %>%
  mutate(
    # Filling in the page profile makes the data type a list but it needs
    # to be numeric
    Page := as.numeric(as.character(Page))
  ) %>%
  left_join(
    page_lookup,
    by = "Page"
  ) %>%
  select(
    studentID,Speaker,Page,
    contains("Target"),
    everything()
  )
# There is a warning message at the code at this point, that says NAs introduced by coercion,
# as of 12/28/2021, I don't think it is a serious issue impacting the reliability of the results. 
write.csv(df_long_full,"Storybook_Long_Full.csv",row.names = F,na="")



# Cleaning up Results for easier analysis
df_emot_condensed <- data.frame()
# Pick right emotion column
for(emotion in sort(unique(df_long_full$Target_Emotion))){
  col = paste0("count_",emotion)
  df_emotion <- df_long_full %>%
    filter(
      Target_Emotion == emotion
    ) %>%
    select(
      studentID,Speaker,Page,
      Target_Emotion_Words = !!sym(col)
    )
  df_emot_condensed <- bind_rows(
    df_emot_condensed,
    df_emotion
  )
}
# Pick right emoter column
df_emoter_condensed <- data.frame()
for(emoter in sort(unique(df_long_full$Target_Emoter))){
  col = paste0("count_",emoter)
  df_emoter <- df_long_full %>%
    filter(
      Target_Emoter == emoter
    ) %>%
    select(
      studentID,Speaker,Page,
      Target_Emoter_Words = !!sym(col)
    )
  df_emoter_condensed <- bind_rows(
    df_emoter_condensed,
    df_emoter
  )
}

# Pick right object column
df_object_condensed <- data.frame()
for(p in sort(unique(df_long_full$Page))){
  col = names(df_long_full)[grep(paste0("_",p,"_"),colnames(df_long_full))]
  df_emoter <- df_long_full %>%
    filter(
      Page == p
    ) %>%
    select(
      studentID,Speaker,Page,
      Target_Object_Words = !!sym(col)
    )
  df_object_condensed <- bind_rows(
    df_object_condensed,
    df_emoter
  )
}

df_long_condensed <- df_long_full %>%
  select(
    studentID,
    Speaker,
    Page,
    contains("Target"),
    Transcript = text,
    Total_Word_Count = total_word_count
  ) %>%
  left_join(
    df_emot_condensed,
    by = c("studentID", "Speaker", "Page")
  ) %>%
  left_join(
    df_emoter_condensed,
    by = c("studentID", "Speaker", "Page")
  ) %>%
  left_join(
    df_object_condensed,
    by = c("studentID", "Speaker", "Page")
  )
write.csv(df_long_condensed,"Storybook_Long_Condensed.csv",row.names = F,na="")

df_wide_condensed <- df_long_condensed %>%
  mutate(
    # Recode variable from Parent --> P etc. 
    Speaker = factor(Speaker,levels = c("Parent","Child"),labels = c("P","C"))
  ) %>%
  tidyr::pivot_wider(
    id_cols = c("studentID","Page","Target_Emotion","Target_Emoter","Target_Object"),
    names_from = "Speaker",
    values_from = c("Transcript","Total_Word_Count","Target_Emotion_Words","Target_Emoter_Words","Target_Object_Words"),
    names_glue = "{Speaker}_{.value}" # Specifies that Speaker (P_Transcript) should be prefix instead of default suffix (Transcript_P)
  )
write.csv(df_wide_condensed,"Storybook_Wide_Condensed.csv",row.names = F,na="")
