library(shiny)

source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_nwunsch.R")
source("lib/load_verif_lib.R")

source("msa/RemoveFirst.R")
source("msa/BestFirst.R")
source("msa/Random.R")

path.list <- GetPathList("data")
file.vec <- list2mat(path.list)[, 2]

methods <- c("Remove First", "Best First", "Random")

ui <- fluidPage(
  titlePanel("発音記号列のアラインメント"),
  
  sidebarLayout(
    sidebarPanel(
      
      if (0) {
        selectInput("word",
                    label = "入力ファイルの選択",
                    choices = c(file.vec))
      },
      fileInput("file1", "Choose File", multiple = F),
      selectInput("method", 
                  label = "アラインメント手法の選択",
                  choices = methods),
      actionButton("alignment", "アラインメント"),
      downloadButton("download", "ダウンロード")
      
    ),
    
    mainPanel(
      tableOutput("table")
    )
  )
)
