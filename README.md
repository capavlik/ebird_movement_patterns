# Movement Patterns of Migrant Birds in the Western U.S. and Canada: an exercise using ebird data¶

This is an exercise using ebird data. My goal was to import this large amount of data to PostgreSQL from the UTF-8 encoding it was in, with PGAdmin4. The data was run through a filtering script using Python in a Jupyter Notebook before import. When in Jupyter, I was able to perform two analyses on the data utilizing GeoPandas and Shapely. The size of range polygons was compared among years through a subsample of 42 species of birds. Then, the data was clustered using K-means. 

## Data Collection / Import

### ebird data download

Data were downloaded from ebird https://science.ebird.org/en/use-ebird-data/download-ebird-data-products for 7 US States and 1 Canadian Province. They are (in order of data volume): Nevada, Idaho, Utah, British Columbia, Oregon, Arizona, Washington, and California. All records of all species were downloaded.

### import to PostgreSQL using PGAdmin4

Data files were large, so I decided to first import them into PostgreSQL using PGAdmin4. I first created tables within which to put the data (this code can be seen in the SQL code file located within the github repo). I then used the import GUI to import the data which came from the website as tab deliminated UTF-8 text. The import of data from Nevada (the smallest set of data at 1.4GB), was uneventful but I got an import error on the Idaho file which required much troubleshooting to fix. It became apparent that the raw data would have to be first filtered through a script in python to eliminate likely sources of import error such as lone backslashes within a cell, and backslash followed by periods at the end of strings. See below for the script that was used to 'clean' the rest of the datasets before import.

## EDA

### Tables were cleaned and aggregated in PostgreSQL

See the SQL code saved within this repo for the code used to clean and aggregate the data.50 Variables were imported in each table of the data, but most were not going to be used, so all but 15 were dropped in PostgreSQL.The variables were imported as varchar(n) or text, and needed to be reclassified into appropriate data types to be used. Taxonomic_order and observation_count were converted to integers, latitude and longitude were converted to double precision, observation_date was converted to 'date', all_species_reported was converted to boolean. To convert observation_count to integer, all null values of 'X' needed to be dropped from the tables.

After data conversion, 42 species were selected from more than 500 identified within the dataset. This was necessary because of the size of the data and the limitations of my local computing power. I knew I needed to get the final working data table down to less than 3GB, and ideally less than 1GB. Bird species were selected based on their migration pattern (I chose those only with obvious seasonal movement patterns) and were further refined to include a good variety of birds that migrate at different times during the spring (early and late arrivers), whose northernmost range varied from central Arizona to the Yukon, and whose habitats were varied (grassland, desert, forest, taiga obligate species).

Finally, an aggregation was performed in PostgreSQL that summed all counted birds grouped by date (YYYY-MM-DD) within each county to give a measurement of each species present in each county within the study region (US and Canada west of the continental divide) on any given day throughout the history of the ebird project. Now, this is only for the 42 species selected, to serve as a 'proof-of-concept' - but this would be wildly interesting if all species could be included. I was able to distill about 60G of data down to 780M in this way. This still represents about 7.5 million rows of data.

## Geospatial Analysis

Data tables were converted to GeoPandas in Python, then points were aggregated by year and bird species to make polygons containing observations. The area of those polygons were calculated, then used in a time series analysis to determine if their sizes were stable over time. 

Every bird species exhibited significant time-dependant polygon area, with all showing signs of expanding their range over time. This is very likely a relic of the evolution of the ebird data, but I was not able to investigate that here. Instead, I was able to show that when only the last 10 years are considered, and especially the last 5 years, the birds diverged in their consistent pattern of growth. Indeed some even exhibit a downward trend in range size over the last 5 years.

The K-means Cluster analysis grouped birds into two groups based on the amount of variation in the polygon areas year over year. Those groups also tended to contain either birds with large ranges or birds with small ranges, but there were some exceptions on either side.

## Conclusions

Geospatial analysis using python and ebird data is possible. Time series analyses are very sensitive to the time being sampled. And, using unsupervised machine learning on geospatial data for birds could potentially be a very useful tool to group very different species together to strenthen analyses and improve conservation measures.

