## Overview

This project aims to conduct a comprehensive bibliometric analysis using bibliographic data extracted from Web of Science and Scopus databases. The analysis focuses on identifying research trends, collaboration patterns, and thematic areas within the data. Key outcomes include the generation of summary metrics, collaboration networks, and keyword co-occurrence insights.

## Key Analyses

- **Data Cleaning and Integration**: 
  Consolidation of `.bib` files into a unified dataset and cleaning of fields such as authors, affiliations, and keywords.
- **Bibliometric Analysis**: 
  Calculation of metrics including publication trends, keyword frequency, and author contributions.
- **Network Analysis**: 
  Visualisation of collaboration networks (countries, universities, authors) and keyword co-occurrence networks.

## Packages

- **`tidyverse`**: Data manipulation and visualisation.
- **`data.table`**: Efficient data handling.
- **`bibliometrix`**: Core package for bibliometric analysis.
- **`ggplot2`**: Visualisation of trends and insights.
- **`openxlsx`**: Exporting data to Excel files.
- **`splitstackshape`**: Handling complex data structures for affiliations

## Search Expression

Search expressions were applied to Web of Science, Scopus, and Google Scholar:  

`UBDC OR Urban Big Data Centre AND [insert the name of the dataset provided by UBDC]`
