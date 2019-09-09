library(shiny)
source("execution_pairwise.R")
source("execution_levenshtein.R")
source("data_processing/GetPathList.R")
source("data_processing/list2mat.R")

path.list <- GetPathList("data")
file.vec <- list2mat(path.list)[, 2]

ui <- fluidPage(
  titlePanel("Alignment for Phonetic Symbol Strings"),
  
  sidebarLayout(
    sidebarPanel(
      # helpText("")
            
      selectInput("word",
                  label = "Choose a word file",
                  choices = c(file.vec,
                              "No Selected"),
                  selected = ""),
      
      selectInput("var", 
                  label = "Choose a method to alignment",
                  choices = c("Phoneme Feature",
                              "Levenshtein"),
                  selected = ""),
      
      actionButton("alignment", "Alignment")
      
    ),
    
    mainPanel(
      tableOutput("table")
    )
  )
)