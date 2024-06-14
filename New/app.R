library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(here)
library(tidyr)
library(jsonlite)
library(stringr)
library(knitr)

ui <- fluidPage(
  titlePanel("University Benchmarking Dashboard"),
  tabsetPanel(
    tabPanel("Total vs Recent Citations", 
             plotOutput("plotCitations"), 
             tableOutput("tableCitations")),
    tabPanel("Altmetric Score Comparison", 
             plotOutput("plotAltmetric")),
    tabPanel("Research Output in Fields", 
             plotOutput("plotFORLevel2"),
             plotOutput("plotFORLevel4")),
    tabPanel("SDG Contributions", 
             plotOutput("plotSDG"),
             DT::dataTableOutput("tableSDG")),
    tabPanel("Benchmarking Universities", 
             tableOutput("tableBenchmark"))
    
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Load data
  total_citations_df <- readr::read_csv(here("UOB Benchmarking Data", "university_of_bradford_total_citations.csv")) 
  
  recent_citations_df <- readr::read_csv(here("UOB Benchmarking Data", "university_of_bradford_recent_citations.csv")) 
  
  altmetric_median_df <- readr::read_csv(here("UOB Benchmarking Data", "university_of_bradford_altmetric_median.csv")) 
  
  publications_for_df <- readr::read_csv(here("UOB Benchmarking Data", "university_of_bradford_publications_for.csv")) 
  
  publications_sdg_df <- readr::read_csv(here("UOB Benchmarking Data", "university_of_bradford_publications_sdg.csv")) 
  
  # Combine total_citations_df and recent_citations_df
  combined_citations_df <- merge(total_citations_df, recent_citations_df, by = c("id", "name"))
  
  # Output for Total vs Recent Citations
  output$plotCitations <- renderPlot({
    # Filter for selected universities
    selected_universities <- combined_citations_df %>%  
      filter(name %in% c("University of Bradford", "University of Leeds", "University of Manchester", "University of Sheffield"))
    
    # Bar Chart for Total and Recent Citations
    ggplot(selected_universities, aes(x = name, y = citations_total, fill = "Total Citations")) + 
      geom_bar(stat = "identity", position = position_dodge()) + 
      geom_bar(aes(y = recent_citations_total, fill = "Recent Citations"), stat = "identity", position = position_dodge()) + 
      labs(title = "Total vs Recent Citations Comparison", x = "University", y = "Citations") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
      scale_fill_manual(values = c("Total Citations" = "blue", "Recent Citations" = "red"))
  })
  # Output for Altmetric Score Comparison
  output$plotAltmetric <- renderPlot({
    # Filter for University of Bradford and a few other universities for comparison
    selected_universities <- altmetric_median_df %>%  
      filter(name %in% c("University of Bradford", "University of Leeds", "University of Manchester", "University of Sheffield"))
    
    # Bar Chart for Altmetric Scores
    ggplot(selected_universities, aes(x = name, y = altmetric_median, fill = name)) + 
      geom_bar(stat = "identity") + 
      labs(title = "Altmetric Score Comparison", x = "University", y = "Median Altmetric Score") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
      scale_fill_brewer(palette = "Set1")
  })
  # Output for Research Output in Fields
  output$plotFORLevel2 <- renderPlot({
    publications_for_level2 <- publications_for_df %>% filter(level == 2)
    ggplot(publications_for_level2, aes(x = reorder(name, -count), y = count, fill = name)) + 
      geom_bar(stat = "identity") + 
      labs(title = "Research Output in FOR Level 2 Fields", x = "Field of Research", y = "Number of Publications") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
      scale_fill_viridis_d()
  })
  
  output$plotFORLevel4 <- renderPlot({
    publications_for_level4 <- publications_for_df %>% filter(level == 4)
    ggplot(publications_for_level4, aes(x = reorder(name, -count), y = count, fill = name)) + 
      geom_bar(stat = "identity") + 
      labs(title = "Research Output in FOR Level 4 Fields", x = "Field of Research", y = "Number of Publications") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
      scale_fill_viridis_d()
  })
  # Output for SDG Contributions
  output$plotSDG <- renderPlot({
    sdg_summary <- publications_sdg_df %>% 
      arrange(desc(count))
    
    ggplot(sdg_summary, aes(x = reorder(name, -count), y = count, fill = name)) + 
      geom_bar(stat = "identity") + 
      labs(title = "Overall Contribution to Sustainable Development Goals", x = "SDG", y = "Number of Publications") + 
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
      scale_fill_viridis_d()
  })
  
  output$tableSDG <- DT::renderDataTable({ # or use renderTable for a basic table
    sdg_summary <- publications_sdg_df %>% 
      arrange(desc(count))
    DT::datatable(sdg_summary) # or just return sdg_summary for a basic table
  })
  
  # Output for Benchmarking Universities
  output$tableBenchmark <- renderTable({
    # Selected Universities
    selected_universities <- c("University of Bradford", "University of Leeds", "University of Manchester", "University of Sheffield")
    
    # Prepare data for comparison
    comparison_df <- total_citations_df %>% 
      filter(name %in% selected_universities) %>% 
      select(name, citations_total) %>% 
      left_join(recent_citations_df %>% select(name, recent_citations_total), by = "name") %>% 
      left_join(altmetric_median_df %>% select(name, altmetric_median), by = "name") %>% 
      left_join(publications_for_df %>% select(name, count), by = "name") %>% 
      left_join(publications_sdg_df %>% select(name, count), by = "name")
    
    # Return the comparison dataframe for rendering as a table
    comparison_df
  })
}
# Run the application 
shinyApp(ui = ui, server = server)
