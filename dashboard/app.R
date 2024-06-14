library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(here)
library(tidyr)
library(jsonlite)
library(stringr)
library(knitr)
library(plotly)
library(DT)

ui <- fluidPage(
  titlePanel("University Benchmarking Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selectedUniversities", "Select Universities", 
                  choices = c("University of Bradford", "University of Leeds", "University of Manchester", "University of Sheffield"),
                  selected = c("University of Bradford", "University of Leeds", "University of Manchester", "University of Sheffield"),
                  multiple = TRUE)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Total vs Recent Citations", 
                 plotlyOutput("plotCitations"), 
                 dataTableOutput("tableCitations")),
        tabPanel("Altmetric Score Comparison", 
                 plotlyOutput("plotAltmetric")),
        tabPanel("Research Output in Fields", 
                 plotlyOutput("plotFORLevel2"),
                 plotlyOutput("plotFORLevel4")),
        tabPanel("SDG Contributions", 
                 plotlyOutput("plotSDG"),
                 dataTableOutput("tableSDG")),
        tabPanel("Benchmarking Universities", 
                 dataTableOutput("tableBenchmark"))
      )
    )
  )
)

server <- function(input, output) {
  
  # Load data
  total_citations_df <- readr::read_csv(here("university_of_bradford_total_citations.csv"))
  recent_citations_df <- readr::read_csv(here("university_of_bradford_recent_citations.csv"))
  altmetric_median_df <- readr::read_csv(here("university_of_bradford_altmetric_median.csv"))
  publications_for_df <- readr::read_csv(here("university_of_bradford_publications_for.csv"))
  publications_sdg_df <- readr::read_csv(here("university_of_bradford_publications_sdg.csv"))
  
  # Combine total_citations_df and recent_citations_df
  combined_citations_df <- merge(total_citations_df, recent_citations_df, by = c("id", "name"))
  
  # Output for Total vs Recent Citations
  output$plotCitations <- renderPlotly({
    selected_universities <- combined_citations_df %>%  
      filter(name %in% input$selectedUniversities)
    
    plot <- ggplot(selected_universities, aes(x = name)) + 
      geom_bar(aes(y = citations_total, fill = "Total Citations"), stat = "identity", position = position_dodge()) + 
      geom_bar(aes(y = recent_citations_total, fill = "Recent Citations"), stat = "identity", position = position_dodge()) + 
      labs(title = "Total vs Recent Citations Comparison", x = "University", y = "Citations") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
      scale_fill_manual(values = c("Total Citations" = "blue", "Recent Citations" = "red"))
    
    ggplotly(plot)
  })
  
  output$plotAltmetric <- renderPlotly({
    selected_universities <- altmetric_median_df %>%  
      filter(name %in% input$selectedUniversities)
    
    plot <- ggplot(selected_universities, aes(x = name, y = altmetric_median, fill = name)) + 
      geom_bar(stat = "identity") + 
      labs(title = "Altmetric Score Comparison", x = "University", y = "Median Altmetric Score") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
      scale_fill_brewer(palette = "Set1")
    
    ggplotly(plot)
  })
  
  output$plotFORLevel2 <- renderPlotly({
    publications_for_level2 <- publications_for_df %>% filter(level == 2)
    plot <- ggplot(publications_for_level2, aes(x = reorder(name, -count), y = count, fill = name)) + 
      geom_bar(stat = "identity") + 
      labs(title = "Research Output in FOR Level 2 Fields", x = "Field of Research", y = "Number of Publications") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
      scale_fill_viridis_d()
    
    ggplotly(plot)
  })
  
  output$plotFORLevel4 <- renderPlotly({
    publications_for_level4 <- publications_for_df %>% filter(level == 4)
    plot <- ggplot(publications_for_level4, aes(x = reorder(name, -count), y = count, fill = name)) + 
      geom_bar(stat = "identity") + 
      labs(title = "Research Output in FOR Level 4 Fields", x = "Field of Research", y = "Number of Publications") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
      scale_fill_viridis_d()
    
    ggplotly(plot)
  })
  
  output$plotSDG <- renderPlotly({
    sdg_summary <- publications_sdg_df %>% 
      arrange(desc(count))
    
    plot <- ggplot(sdg_summary, aes(x = reorder(name, -count), y = count, fill = name)) + 
      geom_bar(stat = "identity") + 
      labs(title = "Overall Contribution to Sustainable Development Goals", x = "SDG", y = "Number of Publications") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
      scale_fill_viridis_d()
    
    ggplotly(plot)
  })
  
  output$tableSDG <- DT::renderDataTable({
    sdg_summary <- publications_sdg_df %>% 
      arrange(desc(count))
    DT::datatable(sdg_summary)
  })
  
  output$tableBenchmark <- DT::renderDataTable({
    selected_universities <- input$selectedUniversities
    
    comparison_df <- total_citations_df %>% 
      filter(name %in% selected_universities) %>% 
      select(name, citations_total) %>% 
      left_join(recent_citations_df %>% select(name, recent_citations_total), by = "name") %>% 
      left_join(altmetric_median_df %>% select(name, altmetric_median), by = "name") %>% 
      left_join(publications_for_df %>% select(name, count), by = "name") %>% 
      left_join(publications_sdg_df %>% select(name, count), by = "name")
    
    DT::datatable(comparison_df)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
