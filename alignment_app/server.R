server <- function(input, output, session) {
  
  s <- MakeFeatureMatrix(-Inf, -3)
  
  push <- -1  
  observeEvent(input$alignment, {
    push <<- input$alignment
  })
  
  output$table <- renderTable({
    if (input$alignment == push) {
      push <<- -1
      
      if(is.null(input$file1)) {
        return(NULL) 
      } else {
        word.list <- MakeWordList(input$file1$datapath)
      }
      
      #word.list <- MakeWordList(paste("data", input$word, sep = "/"))
      word.list <- MakeInputSeq(word.list)
      switch (input$method,
              "Remove First" = RemoveFirst(word.list, s),
              "Best First" = BestFirst(word.list, s),
              "Random" = Random(word.list, s))
    } else {
      # no operation
    }
  })
  
}