library(shiny)
library(ggplot2)
library(dplyr)
load("stormSummary.RData")

shinyServer(
  function(input, output) {

    output$plotTitle <- renderText({paste("Top Storm Types by", input$agType, input$measure)})
    
    topStorm <- reactive({
      if (!input$showStorm) {
        NA
      } else if (input$measure == "Damage") {
        topDamageStorm
      } else if (input$measure == "Harmed") {
        topHarmStorm
      } else if (input$measure == "Fatalities") {
        deadlyStorm
      } else {
        NA
      }
    })
    
    output$worstStorm <- renderText({
      paste0(
        "The worst storm was ", topStorm()$EVTYPE,
        " which occured on ", as.Date(topStorm()$END_DATE, format = "%m/%d/%Y"),
        " in ", topStorm()$STATE,
        ".  Total Fatalities: ", topStorm()$FATALITIES,
        "; Total Injuries: ", topStorm()$INJURIES,
        "; Total Damages: ", topStorm()$totalDamage,
        ".   Remarks: ", topStorm()$REMARKS
      )
    })

    output$stormPlot <- renderPlot({
      rank = paste0("rank", input$measure)
      tot = paste0("total", input$measure)
      data <- filter(summary, summary[,rank] <= input$topN & label == input$agType)
      data$EVTYPE = factor(data$EVTYPE, levels = data[order(data[,rank], decreasing = TRUE), "EVTYPE"])

      p <-ggplot(data, aes_string(x = "EVTYPE", y = tot)) +
        geom_bar(colour = "black", fill = input$filr, stat="identity", size = .5, width = .8) +
        geom_text(aes(label=paste("n=", n)), hjust = 1.1) +
        coord_flip() +
        theme(plot.title = element_text(size = rel(1))) + 
        labs(y = paste(input$agType, input$measure), x="Event Type")

      print(p)
      
    }, height=500)
  }
)
