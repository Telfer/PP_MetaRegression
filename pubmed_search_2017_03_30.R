# This vignette is a useful guide:
# http://amunategui.github.io/pubmed-query/
# Search run 2017/03/30 - "plantar pressure measurement"


# ============================================================================

# load required packages
library(RISmed)

# define search string
search_topic <- '"plantar pressure" OR "plantar pressures" OR pedobarography'

# check number of results that will be returned from a full search
search_query <- EUtilsSummary(search_topic, retmax = 3000)
summary(search_query)

# get actual data from PubMed
records <- EUtilsGet(search_query)

# store it
pubmed_data_authors <- Author(records)
pubmed_data <- data.frame("Title" = ArticleTitle(records),
                          "Journal" = ISOAbbreviation(records),
                          "Abstract" = AbstractText(records),
                          "Year" = YearPubmed(records),
                          "Volume" = Volume(records),
                          "Pages" = MedlinePgn(records),
                          "PMID" = PMID(records),
                          "LastName" = NA, "ForeName" = NA, "Initials" = NA)

# Format first author
for (i in 1:nrow(pubmed_data)) {
  pubmed_data[i, 8] = pubmed_data_authors[[i]][1, 1]
  pubmed_data[i, 9] = pubmed_data_authors[[i]][1, 2]
  pubmed_data[i, 10] = pubmed_data_authors[[i]][1, 3]
}


# Format for neat output to review
single_paper <- list()
formatted_doc = list()
for (i in 1:nrow(pubmed_data)) {
  single_paper[[1]] <- paste0("PAPER NUMBER: ", i)
  single_paper[[2]] <- paste0("TITLE: ", pubmed_data[i, 1])
  single_paper[[3]] <- paste0("FIRST AUTHOR : ", pubmed_data[i, 8],
                              ", ", pubmed_data[i, 9], ", ", pubmed_data[i, 10])
  single_paper[[4]] <- paste0("JOURNAL: ", pubmed_data[i, 2] )
  single_paper[[5]] <- paste0("YEAR : ", pubmed_data[i, 4])
  single_paper[[6]] <- paste0("VOLUME : ", pubmed_data[i, 5])
  single_paper[[7]] <- paste0("PAGES : ", pubmed_data[i, 6])
  single_paper[[8]] <- paste0("PMID : ", "https://www.ncbi.nlm.nih.gov/pubmed/", pubmed_data[i, 7])
  single_paper[[9]] <- paste0("ABSTRACT: ", pubmed_data[i, 3])
  single_paper[[10]] <- ""
  
  formatted_doc = append(formatted_doc, single_paper)
}

# Write output
writeLines(unlist(formatted_doc), "abstracts_for_review.txt")
pubmed2 <- pubmed_data
pubmed2 <- pubmed2[, c(8, 4, 2)]
write.table(pubmed2, "pubmed_data.csv", sep = ",", row.names = FALSE)
