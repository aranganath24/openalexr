library(openalexR)
library(tidyverse)

# extract all datasets in openalex system (>24000000 records)
all_datasets_openalex<-
  oa_fetch(
    entity = "works",
    type = "dataset",
    verbose = TRUE)

# extracts CU Scholar source information
cu_scholar_source<-oa_fetch(
  entity = "sources",
  search = "CU Scholar",
  verbose = TRUE)

# clean up id column
cu_scholar_source<-cu_scholar_source %>% 
                      mutate(clean_id=basename(id))

# extract id column
combined_ids<-cu_scholar_source$clean_id

# collapse ids into or string
combined_ids_string<-paste(combined_ids, collapse="|")

# extract cu scholar datasets
cu_scholar_datasets <- oa_fetch(
  entity = "works",
  "locations.source.id" = combined_ids_string,
  type = "dataset",
  verbose = TRUE)

# extract all cu scholar works
cu_scholar_works <- oa_fetch(
  entity = "works",
  "locations.source.id" = combined_ids_string,
  verbose = TRUE)


# extract cu scholar datasets by searching for "data" within the "landing_page_url" field,
# i.e. using a url parsing strategy
cu_scholar_datasets_alternate<-cu_scholar_works %>% 
                                filter(str_detect(landing_page_url, "data"))

# extracts CU Boulder institutional information
cu_boulder_metadata <- 
  oa_fetch(
    entity = "institutions",
    search = "University of Colorado Boulder")

# extracts CU Boulder openalex institutional ID
cu_inst_id <-basename(cu_boulder_metadata$id[1])

# extracts cu-authored datasets in any location
all_cu_datasets <- oa_fetch(
  entity = "works",
  "authorships.institutions.id" = cu_inst_id,
  type = "dataset",
  verbose = TRUE)


# extracts cu-authored datasets in repositories besides cu scholar
all_cu_datasets_sans_cuscholar<-
  all_cu_datasets %>% 
   filter(source_display_name!="CU Scholar (University of Colorado Boulder)")


# dataset of all cu-affiliated datasets in openalex system
cu_datasets_comprehensive<-bind_rows(cu_scholar_datasets_alternate, all_cu_datasets_sans_cuscholar)


# extract by last known institution ---------------------------------------

# fetch author profiles tied to cu boulder
cu_authors <- oa_fetch(
  entity = "authors",
  "last_known_institutions.id" = cu_inst_id,
  verbose = TRUE)

# Extract authors' unique OpenAlex Author IDs
cu_author_ids <- basename(cu_authors$id)

# chunk author list into groups of ~50
author_chunks <- split(cu_author_ids, ceiling(seq_along(cu_author_ids) / 50))


# write helper function; defines an explicit, named function to process a single chunk of IDs
fetch_dataset_chunk <- function(id_vector) {
  combined_author_string <- paste(id_vector, collapse = "|")
  
  oa_fetch(
    entity = "works",
    "authorships.author.id" = combined_author_string,
    type = "dataset",
    verbose = TRUE
  )
}

# use purrr to map over the chunks using "fetch_dataset_chunk"
cu_researcher_datasets_master <- author_chunks %>%
  map(fetch_dataset_chunk) %>%
  list_rbind() %>%
  distinct(id, .keep_all = TRUE)

