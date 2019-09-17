server <- function(input, output, session) {
  
  s <- MakeFeatureMatrix(-Inf, -3)
  
  push <- -1  
  observeEvent(input$alignment, {
    push <<- input$alignment
  })
  
  aln <- 0
  output$table <- renderTable({
    if (input$alignment == push) {
      push <<- -1
      #word.list <- MakeWordList(paste("data", input$word, sep = "/"))
      word.list <- MakeWordList(input$file1$datapath)
      word.list <- MakeInputSeq(word.list)
      aln <<- switch (input$method,
                      "Remove First" = RemoveFirst(word.list, s),
                      "Best First" = BestFirst(word.list, s),
                      "Random" = Random(word.list, s))
    } else {
      # no operation
    }
  })
  
  output$download <- downloadHandler(
    filename = function() {
      paste(input$file1$name, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(aln, file, row.names = F)
    }
  )
  
}