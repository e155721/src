library(shiny)
source("execution_pairwise.R")
source("execution_levenshtein.R")
source("data_processing/GetPathList.R")
source("data_processing/list2mat.R")

path.list <- GetPathList("data")
file.vec <- list2mat(path.list)[, 2]

ui <- fluidPage(
  titlePanel("censusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
               information from the 2010 US Census."),
      
      selectInput("word",
                  label = "Choose a word file",
                  choices = c(file.vec,
                              "No Selected"),
                  selected = ""),
      
      selectInput("var", 
                  label = "Choose a variable to display",
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