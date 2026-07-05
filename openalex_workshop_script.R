install.packages("openalexR")
install.packages("tidyverse")

library(openalexR)
library(tidyverse)


# Extracting works ----------------------------------------------------------

# Searching for works based on title

# search for and extract publications from 
# September through December 2024 with "sustainability" in title
# resulting data frame assigned to "works_search_sustainability"
works_search_sustainability<-
  oa_fetch(
    entity = "works",
    title.search = c("sustainability"),
    cited_by_count = ">10",
    from_publication_date = "2024-09-01",
    to_publication_date = "2024-12-31",
    verbose=TRUE
  )

# prints class of "works_search_sustainability"
works_search_sustainability

# views "works_search_sustainability" in viewer
View(works_search_sustainability)

# search for and extract articles published from 
# September through December 2024 with "sustainability" OR "Colorado" in title
# and have been cited more than 35 times; resulting data frame assigned 
# to "works_search_sustainability"
works_search_sustainability_OR_Colorado<-
  oa_fetch(
    entity = "works",
    title.search = c("sustainability", "Colorado"),
    cited_by_count = ">35",
    from_publication_date = "2024-09-01",
    to_publication_date = "2024-12-31",
    verbose=TRUE
  )

# search for and extract articles published from 
# 2015 through 2024 with "sustainability" AND "Colorado" in title
# resulting data frame assigned to "works_search_sustainability"
works_search_sustainability_AND_Colorado<-
  oa_fetch(
    entity = "works",
    title.search = "sustainability + Colorado",
    cited_by_count = ">1",
    from_publication_date = "2015-01-01",
    to_publication_date = "2024-12-31",
    verbose=TRUE
  )

# Views "works_search_sustainability_AND_Colorado"
View(works_search_sustainability_AND_Colorado)

# search for and extract articles published  
# in 2024 with phrase "sustainable development" in title
# that have been cited more than once
works_search_sustainable_development<-
  oa_fetch(
    entity = "works",
    title.search = '"sustainable development"',
    cited_by_count = ">1",
    from_publication_date = "2024-01-01",
    to_publication_date = "2025-12-31",
    verbose=TRUE
  )

# View "works_search_sustainable_development"
View(works_search_sustainable_development)

# search for and extract articles published from 
# 1990 through 2024 with phrase "sustainable development" and 
# "Colorado in title
works_search_sustainable_development_CO<-
  oa_fetch(
    entity = "works",
    title.search = '"sustainable development" + Colorado',
    cited_by_count = ">1",
    from_publication_date = "1990-01-01",
    to_publication_date = "2024-12-31",
    verbose=TRUE
  )


# searches for works with "sustainability" in text of abstract
# published from September through December 2024, with more than 100 cites
works_search_sustainability_abstracts<-
  oa_fetch(
    entity = "works",
    abstract.search = c("sustainability"),
    cited_by_count = ">100",
    from_publication_date = "2024-09-01",
    to_publication_date = "2024-12-31",
    verbose=TRUE
  )

# Searching for works based on DOI

# extracts article metadata based on a single 
# DOI (10.1038/s41597-021-00892-0)
CARE_principles<-
  oa_fetch(
    doi = "10.1038/s41597-021-00892-0", 
    entity = "works",
    verbose=TRUE)

# extracts articles metadata for multiple articles with multiple DOIs
# (10.1038/s41597-021-00892-0 and 10.5334/dsj-2020-043)
CARE_principles_multiple<-
  oa_fetch(
  doi = c("10.1038/s41597-021-00892-0", "10.5334/dsj-2020-043"),
  entity = "works",
  verbose=TRUE)
  
# Searching for works based on ORCID/Author

# extracts works for a single author by ORCID ID
# (0000-0001-9801-2277)
kouper_publications<-
  oa_fetch(
  entity = "works",
  author.orcid = "0000-0001-9801-2277",
  verbose = TRUE)

# extracts works for multiple authors by ORCID ID
# (0000-0001-9801-2277 and 0000-0002-4122-0910)
kouper_mayernik_publications<-
  oa_fetch(
    entity = "works",
    author.orcid = c("0000-0001-9801-2277", "0000-0002-4122-0910"),
    verbose = TRUE)

# extracts datasets with "sustainability" in their titles or abstracts,
# that have been cited more than ten times
sustainability_datasets <- 
oa_fetch(
  entity = "works",
  search = "sustainability",
  type = "dataset",
  cited_by_count = ">10",
  verbose = TRUE
)

# searching for work by citation

# extracts CARE paper Open Alex (OA) ID
CARE_id<-CARE_principles$id

# extracts papers citing CARE paper
works_citing_CARE<-
  oa_fetch(
    entity = "works",
    cites = CARE_id,
    verbose = TRUE
  )

# extracts papers cited by CARE paper
works_cited_by_CARE<-
  oa_fetch(
    entity = "works",
    cited_by = CARE_id,
    verbose = TRUE
  )


# Extracting journal metadata --------------------------------------------------

# extracts metadata for journal "Nature"
nature_source <- oa_fetch(
  entity = "sources",
  display_name = "Nature"
)

# views nature_source
View(nature_source)

# extracts metadata for journals "Nature" and "Science"
nature_science_source <- oa_fetch(
  entity = "sources",
  display_name = c("Nature", "Science")
)

# views nature_science_source
View(nature_science_source)


# Extracting author metadata -------------------------------------------------

# extracts author metadata for Kouper (0000-0001-9801-2277)
author_metadata_kouper<-
  oa_fetch(
    entity = "authors",
    orcid = "0000-0001-9801-2277"
  )

# extracts author metadata for Kouper and Mayernik
# (0000-0001-9801-2277 and 0000-0002-4122-091)
author_metadata_kouper_mayernik<-
  oa_fetch(
    entity = "authors",
    orcid = c("0000-0001-9801-2277","0000-0002-4122-0910")
  )
  
# Extracting Institution Metadata -----------------------------------------

# extracts institution metadata for CU Boulder
cu_boulder_metadata <- 
oa_fetch(
  entity = "institutions",
  search = "University of Colorado Boulder"
)


# More complex queries ----------------------------------------------------

# extracts CU Boulder institutional ID
cu_inst_id <-cu_boulder_metadata$id[1]

# extracts works by CU authors in which "sustainability" appears in the title
# or abstract, from 2022 through 2025
cu_sustainability_works <- 
oa_fetch(
  entity = "works",
  "authorships.institutions.id" = cu_inst_id,
   search = "sustainability",
   from_publication_date = "2022-01-01",
   to_publication_date = "2025-12-31",
   verbose = TRUE
)

# Views "cu_sustainability_works"
View(cu_sustainability_works)

# extracts datasets published by CU authors with "sustainability" in title/abstract
cu_sustainability_datasets<-
  oa_fetch(
    entity = "works",
    "authorships.institutions.id" = cu_inst_id,
    type="dataset",
    search = "sustainability",
    verbose = TRUE
  )

# Extracts OA ID for journal "nature" and assigns to "nature_id"
nature_id<-nature_science_source[1,1]

# extracts works from the journal Nature with "sustainability" in the title
nature_works_sustainability <- 
  oa_fetch(
    entity = "works",
    primary_location.source.id = nature_id, 
    title.search = "sustainability",
    verbose = TRUE
  )

# find all works citing Inna Kouper

# extract kouper publication IDs from "kouper_publications" (defined above)
kouper_work_ids<-kouper_publications$id

# extract all works that cite Kouper
works_citing_kouper<-
  oa_fetch(
    entity="works",
    cites=paste(kouper_work_ids, collapse="|"),
    verbose=TRUE
  )

# extract all work cited by kouper
works_cited_by_kouper<-
  oa_fetch(
    entity="works",
    cited_by=paste(kouper_work_ids, collapse="|"),
    verbose=TRUE
  )

# Basic analysis and visualization ----------------------------------------

# creates table showing CU sustainability pubs by OA status
CU_sustainability_OA<-
cu_sustainability_works %>% 
  group_by(oa_status) %>% 
  count()

# graphs distribution of CU Sustainability pubs by OA status (sideways bar chart)
ggplot(CU_sustainability_OA, aes(x = reorder(oa_status, n), y = n))+
  geom_col(fill = "steelblue") +
  coord_flip()+
  labs(
    title = "Open Access Status of Publications on Sustainability by CU Authors, 2022-2025",
    subtitle = "Sorted from most to least frequent",
    x = "Open Access Status",
    y = "Number of Publications"
  ) +
  theme_minimal()

# creates table showing CU Sustainability pubs by year
CU_sustainability_year<-
  cu_sustainability_works %>% 
  group_by(publication_year) %>% 
  count()

# creates line graph of sustainability publications over time
ggplot(CU_sustainability_year, aes(x = publication_year, y = n)) +
  geom_line(color = "steelblue", size = 1) +
  geom_point(color = "steelblue", size = 3) +
  scale_x_continuous(breaks = CU_sustainability_year$publication_year) +
  labs(
    title = "Evolution of CU Sustainability Publications Over Time",
    subtitle = "Data source: OpenAlex",
    x = "Publication Year",
    y = "Number of Publications"
  ) +
  theme_minimal()



