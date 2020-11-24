#
# This is the user-interface for the Shiny web application to predict diamond price by size, cut, 
# color, and clarity. You can run the application by clicking 'Run App' above.
#

library(shiny)
library(ggplot2)

# Load data
data("diamonds")

# Define UI for application
shinyUI(fluidPage(titlePanel("Predicted diamond price based on size, cut, color, and clarity"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(h4("Select diamond characteristics"),
            selectInput("clarity", "Clarity", sort(unique(diamonds$clarity))),
            selectInput("color", "Color", sort(unique(diamonds$color))),
            selectInput("cut", "Cut", sort(unique(diamonds$cut), decreasing = TRUE)),
            sliderInput("m1", "Carat",
                        min = min(diamonds$carat),
                        max = max(diamonds$carat),
                        value = max(diamonds$carat) / 2, step = 0.1),
                        h4("Predicted diamond price:"), verbatimTextOutput("predict")
        ),

        # Show a plot of the generated distribution
        mainPanel("Price per carat",
            plotOutput("distPlot")
        )
    )
))
