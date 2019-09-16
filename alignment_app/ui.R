library(shiny)
source("execution_pairwise.R")
source("execution_levenshtein.R")
source("data_processing/GetPathList.R")
source("data_processing/list2mat.R")

path.list <- GetPathList("data")
file.vec <- list2mat(path.list)[, 2]

ui <- fluidPage(
  titlePanel("発音記号列のアラインメント"),
  
  sidebarLayout(
    sidebarPanel(
      
      selectInput("word",
                  label = "入力ファイルの選択",
                  choices = c(file.vec)),
      selectInput("method", 
                  label = "アラインメント手法の選択",
                  choices = c("Phoneme Feature",
                              "Levenshtein")),
      actionButton("alignment", "アラインメント")
      
    ),
    
    mainPanel(
      tableOutput("table")
    )
  )
)
