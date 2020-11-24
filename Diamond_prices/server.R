#
# This is the Shiny web application to predict diamond price by size, cut, 
# color, and clarity. 
#

library(tidyverse)
library(shiny)
library(ggplot2)
library(scales)
library(curl)

# Define server logic
shinyServer(function(input, output) {
    
    # load data
    data("diamonds")
    
    # create the initial output
    output$distPlot <- renderPlot({
        
        # subset the data based on the inputs
        diamonds_sub <- subset(diamonds, cut == input$cut &
                                   color == input$color &
                                   clarity == input$clarity)
        
        # plot the diamond data with carat and price
        ggplot(data = diamonds_sub, aes(x = carat, y = price)) + 
            geom_point() + 
            geom_smooth(method = "lm") + 
            scale_x_continuous(limits = c(0, quantile(diamonds_sub$carat, 0.99))) +
            scale_y_continuous(limits = c(0, quantile(diamonds_sub$price, 0.99))) +
            labs(title = "Diamond prices by carat", x = "Carat", y = "Price")
    }, height = 700)
    
    # create linear model
    output$predict <- renderPrint({
        diamonds_sub <- subset(diamonds, cut == input$cut &
                                    color == input$color &
                                    clarity == input$clarity)
        m1 <- lm(price ~ carat,data = diamonds_sub)
        unname(predict(m1, data.frame(carat = input$m1)))})
    
    observeEvent(input$predict, {distPlot <<- NULL
    output$distPlot <- renderPlot({ggplot(data = diamonds_sub, aes(x = carat, y = price)) + 
            geom_point() + 
            geom_smooth(method = "lm") + 
            scale_x_continuous(limits = c(0, quantile(diamonds_sub$carat, 0.99))) +
            scale_y_continuous(limits = c(0, quantile(diamonds_sub$price, 0.99))) +
            labs(x = "Carat", y = "Price")
    }, height = 700)})})