# Load required libraries
pacman::p_load(
  rio,            # Import/export data
  here,           # File paths management
  tidyverse,      # Data manipulation and visualisation
  ggplot2,        # Data visualisation
  data.table,     # Data manipulation
  dplyr,          # Data wrangling
  bibliometrix,   # Bibliometric analysis
  readxl,         # Read Excel files
  tidyr           # Data tidying
)

# Combine multiple .bib files into a single file
d <- list.files("path", pattern="\\.bib$", full.names=T)  # Set path for bibliographic files
Unlist_files <- d %>%
  lapply(readLines) %>%    # Read each .bib file
  unlist()                 # Combine all content into a single vector
write(Unlist_files, file = "path/Bib.bib") # Write combined .bib content to a new file

# Convert the combined .bib file into a data frame
file <- "path/Bib.bib"
M <- convert2df(file = file, dbsource = "scopus", format = "bibtex")
openxlsx::write.xlsx(M, "M.xlsx", rowNames=TRUE)

# Bibliometric Analysis
results <- biblioAnalysis(M, sep = ";")
S <- summary(object = results, k = 10, pause = FALSE)
openxlsx::write.xlsx(S, "S.xlsx", rowNames=TRUE)

## Extract and clean Author's Keywords (DE)
KW <- M %>% 
  mutate(DE1 = strsplit(as.character(DE), ";")) %>%    # Split keywords by ";"
  unnest(DE1)                                          # Unnest the list into rows

KW$DE1 <- KW$DE1 %>% 
  str_replace_all(KW$DE1, "[^a-zA-Z0-9]", " ") %>%    # Remove non-alphanumeric characters
  trimws("both")                                      # Trim leading and trailing spaces
  
openxlsx::write.xlsx(KW, "Keywords.xlsx", rowNames=TRUE)

## Extract and clean Author (AU) 
AU <- M %>% 
  mutate(Author = strsplit(as.character(AU), ";")) %>% 
  unnest(Author)

AU$Author <- AU$Author %>% 
  str_replace_all(AU$Author, "[^a-zA-Z0-9]", " ") %>% 
  trimws("both")

openxlsx::write.xlsx(AU, "AU author.xlsx", rowNames=TRUE)

## Extract and clean Authors’ Affiliations
C1 <- M %>% 
  mutate(Author_Affiliation = strsplit(as.character(C1), ";")) %>% 
  unnest(Author_Affiliation)

C1$Author_Affiliation <- trimws(C1$Author_Affiliation, "both")

C1 <- splitstackshape::cSplit(C1, "Author_Affiliation", ",")
C1 <- C1 %>% 
  mutate(across(Author_Affiliation_1:Author_Affiliation_7, ~ str_replace(., "THE UNIVERSITY OF GLASGOW", "UNIVERSITY OF GLASGOW")),
         across(Author_Affiliation_1:Author_Affiliation_7, as.character))

## split to row
C1 <- M %>% 
  mutate(Author_Affiliation = strsplit(as.character(C1), ";")) %>% 
  unnest(Author_Affiliation)

Affiliation <-C1  %>% 
  mutate(Author_Affiliation = strsplit(as.character(Author_Affiliation), ",")) %>% 
  unnest(Author_Affiliation)

Affiliation$Author_Affiliation <- Affiliation$Author_Affiliation %>% 
  str_replace_all("[^a-zA-Z0-9]", " ") %>% 
  trimws("both")

Affiliation <- Affiliation %>% 
  mutate(
    Author_Affiliation = case_when(
      str_detect(Author_Affiliation, "THE UNIVERSITY OF GLASGOW") ~ "UNIVERSITY OF GLASGOW",
      .default = as.character(Author_Affiliation)
    )
  )

openxlsx::write.xlsx(Affiliation, "Authors Affiliations.xlsx", rowNames=TRUE)

# Network analysis
## Country collaboration
M <- metaTagExtraction(M, Field = "AU_CO", sep = ";").  # collaboration network

NetMatrix <- biblioNetwork(M, 
                           analysis = "collaboration", 
                           network = "countries", 
                           sep = ";")

net=networkPlot(NetMatrix, 
                n = dim(NetMatrix)[1],
                Title = "Country Collaboration", 
                type = "sphere", 
                size=TRUE, 
                remove.multiple=FALSE,
                labelsize=0.8)

net=networkPlot(NetMatrix, 
                n = dim(NetMatrix)[1], 
                Title = "Country Collaboration", 
                type = "circle", 
                size=TRUE, 
                remove.multiple=FALSE,
                labelsize=0.8)

## Affiliation collaboration
AU_UN <- M %>% 
  mutate(university = strsplit(as.character(AU_UN), ";")) %>%   # string split 
  unnest(university)

AU_UN$university <- AU_UN$university %>% 
  str_replace_all("[^a-zA-Z0-9]", " ") %>% 
  trimws("both")

lookup <- AU_UN %>%                                             # word cleaning 
  mutate(
    university1 = case_when(
      str_detect(university, "THE UNIVERSITY OF GLASGOW") ~ "UNIVERSITY OF GLASGOW",
      str_detect(university, "GLASGOW") ~ "UNIVERSITY OF GLASGOW",
      str_detect(university, "SOCIAL POLICY AND CRIMINOLOGY UNIVERSITY OF STIRLING") ~ "NIVERSITY OF STIRLING",
      .default = as.character(university)
    )
  )

lookup <- lookup[ , c("university", "university1")]             # lookup table  

### clean data in original file  
M$AU_UN <- str_replace_all(M$AU_UN, "[^a-zA-Z0-9\\;]", " ").    # remove non regex except ;

M$AU_UN <- stringi::stri_replace_all_regex(
  str = M$AU_UN,
  pattern = paste0("\\b", lookup$university, "\\b")             # add word boundaries
  replacement = lookup$university1,
  vectorize_all = FALSE, 
  opts_regex = stringi::stri_opts_regex(case_insensitive = FALSE) # case_insensitive = FALSE <- ex: HEY  vs hey <-- capitalise / normal 
)

NetMatrix <- biblioNetwork(M,                                   # university collaboration network 
                           analysis = "collaboration", 
                           network = "universities", 
                           sep = ";") 

net=networkPlot(NetMatrix, 
                n = dim(NetMatrix)[1], 
                Title = "University Collaboration", 
                type = "circle",                                  
                size=TRUE,  
                remove.multiple=FALSE,
                labelsize=0.8)

## Author collaboration 
NetMatrix <- biblioNetwork(M, 
                           analysis = "collaboration", 
                           network = "authors", 
                           sep = ";")

net=networkPlot(NetMatrix, 
                n = dim(NetMatrix)[1], 
                Title = "Author Collaboration", 
                type = "sphere", 
                size=TRUE, 
                remove.multiple=FALSE,
                labelsize=0.8)

# Keywords co-occurrences
NetMatrix <- biblioNetwork(M, 
                           analysis = "co-occurrences", 
                           network = "author_keywords", 
                           sep = ";")  

net=networkPlot(NetMatrix, 
                normalize="association", 
                weighted=T, 
                n = 40, 
                Title = "Author Keyword Co-occurrences", 
                type = "sphere", 
                size=T,edgesize = 6,labelsize=0.7, remove.multiple = T)

net_groups_kw <- as.data.frame.table(net$cluster_res)

