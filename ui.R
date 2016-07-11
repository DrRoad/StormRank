library(shiny)
shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      h2('Storm Rank'),
      radioButtons("measure", "Select Measure to Rank",
                         c("Economic Damages ($US)" = "Damage",
                           "Harmed (# People)" = "Harmed",
                           "Fatalities (# People)" = "Fatalities")),
      selectInput("agType", "Select Aggregation Method",
                  c("Total All Storms" = "Total",
                    "Mean All Storms" = "Mean Overall",
                    "Mean Top 10% Storms" = "Mean Top Decile",
                    "Worst Single Storm" = "Max")),
      sliderInput('topN', 'Number of Storm Types to Display', value = 5, min = 1, max = 20, step = 1),
      textInput("filr", label = "Chart Color", value = "orange"),
      checkboxInput("showStorm", "Display single worst storm", value = FALSE)
    ),
    mainPanel(
      h3(textOutput("plotTitle"), align="center"),
      plotOutput('stormPlot', height = "500px"),
      h6('n = Number of storms included in category', align = "center"),
      conditionalPanel(condition = "input.showStorm",
                      h4("Worst Storm for Selected Measure"),
                      h5(textOutput("worstStorm")))
    )
  )
))

