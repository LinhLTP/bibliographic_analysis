# Bibliometric Analysis Project

## Overview

This project aims to conduct a comprehensive **bibliometric analysis** using bibliographic data extracted from **Web of Science** and **Scopus** databases. The analysis focuses on identifying research trends, collaboration patterns, and thematic areas within the data. Key outcomes include the generation of summary metrics, collaboration networks, and keyword co-occurrence insights.

## Objectives

The primary objectives of this project are:
1. To integrate, clean, and transform bibliographic data from multiple `.bib` files.
2. To summarise key bibliometric indicators such as publication trends, authorship patterns, and affiliations.
3. To construct and visualise collaboration networks for countries, institutions, and authors.
4. To explore keyword co-occurrence networks to identify prominent research themes.

## Key Analyses

- **Data Cleaning and Integration**: 
  Consolidation of `.bib` files into a unified dataset and cleaning of fields such as authors, affiliations, and keywords.
- **Bibliometric Analysis**: 
  Calculation of metrics including publication trends, keyword frequency, and author contributions.
- **Network Analysis**: 
  Visualisation of collaboration networks (countries, universities, authors) and keyword co-occurrence networks.

## Tools and Packages

This project is implemented in R, leveraging the following packages:

- **`tidyverse`**: Data manipulation and visualisation.
- **`data.table`**: Efficient data handling.
- **`bibliometrix`**: Core package for bibliometric analysis.
- **`ggplot2`**: Visualisation of trends and insights.
- **`openxlsx`**: Exporting data to Excel files.
- **`splitstackshape`**: Handling complex data structures for affiliations.

## Data Sources

The bibliographic data used in this analysis was obtained from:
1. **Web of Science**  
2. **Scopus**

