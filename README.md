#CABS-University Benchmarking Dashboard-Report
This project is a Shiny application that provides a comprehensive benchmarking analysis for selected universities. The application visualizes various metrics such as total and recent citations, altmetric scores, research output in specific fields, and contributions to Sustainable Development Goals (SDGs).

##Features:

Total vs Recent Citations: Compare the total and recent citations of selected universities.
Altmetric Score Comparison: Visualize the median altmetric scores to gauge the attention received by publications.
Research Output in Fields: Analyze research output categorized by Fields of Research (FOR) at different levels.
SDG Contributions: Review the number of publications contributing to various Sustainable Development Goals.
Benchmarking Universities: Compare selected universities across various metrics in a tabular format.

###Technologies Used:

R and Shiny: For building the interactive web application.
ggplot2 and plotly: For creating interactive plots.
DT: For displaying interactive data tables.
dplyr, tidyr, stringr: For data manipulation and cleaning.
jsonlite, readr, knitr, here: For data import and handling.

####Usage:

To run the application, ensure you have the necessary libraries installed and use the command shinyApp(ui = ui, server = server).

#####Data:

The data used in this dashboard includes:

Total citations
Recent citations
Altmetric scores
Research output by fields of research
Publications contributing to SDGs

#######Code Explanation
This Shiny application provides a comprehensive benchmarking analysis for selected universities. Here's a brief explanation of the code:

#######Libraries and Data Loading:

The necessary libraries for data manipulation (dplyr, tidyr, stringr), visualization (ggplot2, plotly), and app development (shiny, DT) are loaded.
Data is imported using the readr and here libraries.
UI Layout:

A fluidPage layout is created with a sidebarLayout.
The sidebar allows users to select universities for comparison.
The main panel contains tabbed sections for different analyses: Total vs Recent Citations, Altmetric Score Comparison, Research Output in Fields, SDG Contributions, and Benchmarking Universities.
Server Logic:

Data is processed and filtered based on user inputs.
Various plots and data tables are rendered using ggplot2 and plotly for visualization, and DT for tables.
Plot and Table Outputs:

Total vs Recent Citations: Bar plots comparing total and recent citations.
Altmetric Score Comparison: Bar plots showing median altmetric scores.
Research Output in Fields: Bar plots for research output categorized by FOR levels.
SDG Contributions: Bar plots showing contributions to SDGs.
Benchmarking Universities: A comparative table showing selected metrics for each university.
This dashboard helps stakeholders understand and compare the research outputs and impacts of various universities, providing valuable insights for strategic planning.
