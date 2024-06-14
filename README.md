# CABS-Report-for-the-School-of-Management
This project is a Shiny application that provides a comprehensive benchmarking analysis for selected universities. The application visualizes various metrics such as total and recent citations, altimetric scores, research output in specific fields, and contributions to Sustainable Development Goals (SDGs).
# Features:

Total vs Recent Citations: Compare the total and recent citations of selected universities.
Altmetric Score Comparison: Visualize the median altmetric scores to gauge the attention received by publications.
Research Output in Fields: Analyze research output categorized by Fields of Research (FOR) at different levels.
SDG Contributions: Review the number of publications contributing to various Sustainable Development Goals.
Benchmarking Universities: Compare selected universities across various metrics in a tabular format.

#Technologies Used:

R and Shiny: For building the interactive web application.
ggplot2 and plotly: For creating interactive plots.
DT: For displaying interactive data tables.
dplyr, tidyr, stringr: For data manipulation and cleaning.
jsonlite, readr, knitr, here: For data import and handling.

#Usage:

To run the application, ensure you have the necessary libraries installed and use the command shinyApp(ui = ui, server = server).

#Data:

The data used in this dashboard includes:

Total citations
Recent citations
Altmetric scores
Research output by fields of research
Publications Contributing to SDGs
