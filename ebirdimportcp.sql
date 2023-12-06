-- we need to create tables in this dbase so we can import our data. This table was created for Nevada, Idaho, Utah, BC, Oregon,
-- Washington, Arizona, and California.

CREATE TABLE "wyoming"
(
    GLOBAL_UNIQUE_IDENTIFIER     varchar(70),        
	LAST_EDITED_DATE			 varchar(50),	   -- YYYY-MM-DD determines if locally stored data must be updated
	TAXONOMIC_ORDER				 varchar(70),      -- numeric, but used to arrange the species in the latest taxonomic sequence
    CATEGORY                     varchar(20),      -- Assigned to this taxon in the eBird/Clements taxonomy
	TAXON_CONCEPT_ID			 varchar(70),      -- a population with shared characteristics and a specific range circumscription 
    COMMON_NAME                  varchar(70),      -- in English
	SCIENTIFIC_NAME				 varchar(70),      -- universal latin name
    SUBSPECIES_COMMON_NAME       varchar(70),      -- in English
	SUBSPECIES_SCIENTIFIC_NAME   varchar(70),	   -- universal latin name
	EXOTIC_CODE					 varchar(70),	   -- N (Naturalized), P (Provisional), and X (Escapee)
    OBSERVATION_COUNT            varchar(70),       -- 'X' indicates presence with no count, so must be imported as string
    BREEDING_CODE                varchar(20),	   -- used in breeding bird atlas, appendix in ebird metadata
    BREEDING_CATEGORY 			 varchar(20),       -- used in breeding bird atlas, C1=Observed; C2=Possible; C3=Probable; C4=Confirmed
	BEHAVIOR_CODE				 varchar(20),	   -- used to correct breeding category based on expert opinion
	AGE_SEX						 text,	  		   -- count by adult, immature, or juvenile and male, female, or unknown
    COUNTRY                      varchar(50),      -- long enough for "Independent And The Sovereign Republic Of Kiribati"
    COUNTRY_CODE                 varchar(50),          -- alpha-2 codes, e. Follows ISO 3166-2.
    STATE                        varchar(50),      -- 
    STATE_CODE                   varchar(50),
    COUNTY                       varchar(50),      -- 
    COUNTY_CODE                  varchar(50),
	IBA_CODE					 varchar(70),	   -- alphanumeric id of Important Bird Area, multiple delimited by '|'
	BCR_CODE					 varchar(50),	   -- alphanumeric code for a Bird Conservation Region
	USFWS_CODE					 varchar(50),	   -- alphanumeric code for a USFWS land holding
    ATLAS_BLOCK                  varchar(50),      -- sampling block encompassing about 23 sq km (9 sq mi)
    LOCALITY                     text,             -- unstructured/potentially long
    LOCALITY_ID                  varchar(30),         -- maximum observed so far is 8
    LOCALITY_TYPE                varchar(50),          -- State (S) County (C) Postal/Zip Code (PC) Town (T) Hotspot (H) Personal (P)
    LATITUDE                     varchar(30),     		-- 
    LONGITUDE                    varchar(30),    		   --    
    OBSERVATION_DATE             varchar(20),      -- YYYY-MM-DD
    TIME_OBSERVATIONS_STARTED    varchar(50),      -- hh:mm:ss
    OBSERVER_ID                  char(50),         -- max of 9 in the data
    SAMPLING_EVENT_IDENTIFIER    char(70),         -- Each sampling event has unique combo of location, date, observer, and start time
	PROTOCOL_TYPE				 varchar(50),	   -- Traveling Count, Stationary Count, Casual Observation, banding, etc.
    PROTOCOL_CODE                varchar(50),	   -- used internally to identify the protocol
    PROJECT_CODE                 varchar(50),      -- designate which portal the data came through
    DURATION_MINUTES             varchar(70),              -- 
    EFFORT_DISTANCE_KM           varchar(70),             -- 
    EFFORT_AREA_HA               varchar(70),             -- 
    NUMBER_OBSERVERS             varchar(70),              -- 
    ALL_SPECIES_REPORTED         varchar(70),          -- (1 = yes; 0 = no)
    GROUP_IDENTIFIER             varchar(50),      -- Use this number to eliminate duplicate data when multiple observers are sharing data
    HAS_MEDIA                    varchar(70),
    APPROVED                     varchar(70),          -- Can be Boolean?
    REVIEWED                     varchar(70),          -- Can be Boolean?
    REASON                       text,             -- May need to be longer if data set includes unvetted data
    TRIP_COMMENTS                text,             -- Comments are long, unstructured,
    SPECIES_COMMENTS             text,
	BLANK						 varchar(70)
);

-- now, lets input our data that we downloaded from ebird. last updated sept 15 2023.
-- These are VERY large datasets, and were very problematic to upload. I did run each dataset through a filtering script in
-- jupyter using python before trying to import in order to delete "\\." and "\\" values that were causing problems.
-- Dataset sizes ranged from 1.46G at the smallest (nevada) to 44.5G at the largest (California).

COPY US_WYSep2023(GLOBAL UNIQUE IDENTIFIER,LAST EDITED DATE,TAXONOMIC ORDER,CATEGORY,TAXON CONCEPT ID,COMMON NAME,SCIENTIFIC NAME,
	SUBSPECIES COMMON NAME,SUBSPECIES SCIENTIFIC NAME,EXOTIC CODE,OBSERVATION COUNT,BREEDING CODE,BREEDING CATEGORY,BEHAVIOR CODE,
	AGE/SEX,COUNTRY,COUNTRY CODE,STATE,STATE CODE,COUNTY,COUNTY CODE,BCR CODE,IBA CODE,USFWS CODE,ATLAS BLOCK,LOCALITY,LOCALITY ID,
	LOCALITY TYPE,LATITUDE,LONGITUDE,OBSERVATION DATE,TIME OBSERVATIONS STARTED,OBSERVER ID,SAMPLING EVENT IDENTIFIER,PROTOCOL TYPE,
	PROTOCOL CODE,PROJECT CODE,DURATION MINUTES,EFFORT DISTANCE KM,EFFORT AREA HA,NUMBER OBSERVERS,ALL SPECIES REPORTED,GROUP IDENTIFIER,
	HAS MEDIA,APPROVED,REVIEWED,REASON,TRIP COMMENTS,SPECIES COMMENTS)
FROM 'C:\Users\Public\Documents\US_WYSep2023.txt'
DELIMITER '	' 
CSV HEADER;

-- now, let's check to make sure our import was successful.

select common_name from washington

-- amazing! We have 50 variables imported. Let's drop the columns that we are not going to use, because this is a lot of data.

ALTER TABLE arizona 
DROP COLUMN IF EXISTS last_edited_date,
DROP COLUMN IF EXISTS category,
DROP COLUMN IF EXISTS taxon_concept_id,
DROP COLUMN IF EXISTS subspecies_common_name,
DROP COLUMN IF EXISTS subspecies_scientific_name,
DROP COLUMN IF EXISTS breeding_code,
DROP COLUMN IF EXISTS breeding_category,
DROP COLUMN IF EXISTS exotic_code,
DROP COLUMN IF EXISTS age_sex,
DROP COLUMN IF EXISTS country,
DROP COLUMN IF EXISTS iba_code,
DROP COLUMN IF EXISTS bcr_code,
DROP COLUMN IF EXISTS usfws_code,
DROP COlUMN IF EXISTS atlas_block,
DROP COLUMN IF EXISTS locality,
DROP COLUMN IF EXISTS locality_id,
DROP COLUMN IF EXISTS locality_type,
DROP COLUMN IF EXISTS time_observations_started,
DROP COLUMN IF EXISTS observer_id,
DROP COLUMN IF EXISTS sampling_event_identifier,
DROP COLUMN IF EXISTS protocol_type,
DROP COLUMN IF EXISTS protocol_code,
DROP COLUMN IF EXISTS project_code,
DROP COLUMN IF EXISTS duration_minutes,
DROP COLUMN IF EXISTS effort_distance_km,
DROP COLUMN IF EXISTS effort_area_ha,
DROP COLUMN IF EXISTS number_observers,
DROP COLUMN IF EXISTS group_identifier,
DROP COLUMN IF EXISTS has_media,
DROP COLUMN IF EXISTS reviewed,
DROP COLUMN IF EXISTS reason,
DROP COLUMN IF EXISTS trip_comments,
DROP COLUMN IF EXISTS species_comments,
DROP COLUMN IF EXISTS blank

-- now, let's try to get an idea of the size of each of these sets after import.

select *
from INFORMATION_SCHEMA.COLUMNS where table_name = 'california'

SELECT count(*) FROM california

-- we now have 15 variables, which is more manageable. 
-- now we have to get rid of the header import, which is annoying but must be done or it'll mess up the numeric columns

DELETE from california
WHERE global_unique_identifier = 'GLOBAL UNIQUE IDENTIFIER'

-- This import was coded from scratch because everyone uses ebird's custom db import tool in 'R'. Because this data is still so big, 
-- I need to make a judgement call to pare down species (some of these sets have over 500 species of birds recorded), or trim the 
-- dates that are used, or both. I'm going to pare the data down to 42 species, as below, and see how big the data is afterwards.

DELETE from arizona
WHERE common_name NOT IN (
	'Mourning Dove', 'White-winged Dove', 'Eurasian Collared-Dove', 'Inca Dove', 'Common Ground-Dove', 'Common Poorwill', 'Common Nighthawk', 
	'Vaux''s Swift', 'White-throated Swift', 'Broad-billed Hummingbird', 'Costa''s Hummingbird', 'Black-chinned Hummingbird', 
	'Calliope Hummingbird', 'Rufous Hummingbird', 'Olive-sided Flycatcher', 'Western Wood-Pewee', 'Gray Flycatcher', 'Say''s Phoebe', 
	'Vermillion Flycatcher', 'Horned Lark', 'Tree Swallow', 'Barn Swallow', 'Western Bluebird', 'American Robin', 'Varied Thrush', 
	'Veery', 'Swainson''s Thrush', 'Orange-crowned Warbler', 'Virginia''s Warbler', 'Lucy''s Warbler', 'Yellow Warbler', 
	'Yellow-rumped Warbler', 'Hermit Warbler', 'American Redstart', 'Painted Redstart', 'Wilson''s Warbler', 'American Tree Sparrow', 
	'Black-throated Sparrow', 'Chipping Sparrow', 'Savannah Sparrow', 'Lark Sparrow', 'Song Sparrow'
	)
	
-- Now that all the tables are imported and trimmed to useful variables and 42 species, let's recode the variables into the data
-- types we need. We'll start with date. I'll create a space for the date variable to go.

ALTER TABLE california ADD COLUMN observed_date date

-- Now, I'll update that variable with the correct date, now formatted to 'date'.

UPDATE california
SET observed_date = to_date(observation_date, 'YYYY-MM-DD')

-- Let's check to see that it makes sense... 

select observation_date, observed_date from california

-- and if it does lets drop the old variable as well as another useless variable that wasn't dropped earlier
-- (at this point, all values of approved are 'true')

ALTER TABLE california
DROP COLUMN IF EXISTS observation_date,
DROP COLUMN IF EXISTS approved

-- Now I'll recast observation_count to type integer

ALTER TABLE california
ALTER COLUMN observation_count TYPE INTEGER
USING observation_count::integer

-- I've discovered that there are many rows of null counts in this data, which bodes well for paring down the other tables as well.
-- I'm going to eliminate all rows where count = 'X', which is 'not present'.

DELETE from california
WHERE observation_count = 'X'

-- Now I'll try to recast the variable again... (using the code above)
-- SUCCESS!! Yes!

select common_name, observation_count, latitude, longitude, observed_date 
from utah

-- Okay, now for latitude and longitude. Those are supposed to be coded as double precision.

ALTER TABLE california
ALTER COLUMN latitude TYPE double precision
USING latitude::double precision

ALTER TABLE california
ALTER COLUMN longitude TYPE double precision
USING longitude::double precision

-- For the sake of space, we're going to code the all numeric taxonomic_order to integer. Even though it's not really an integer, 
-- I would like to be able to sort it by one, and in some ways it behaves like one. Taxonomic values closer to each other 
-- numerically are also closer on the phylogenetic tree.

ALTER TABLE california
ALTER COLUMN taxonomic_order TYPE integer
USING taxonomic_order::integer

-- now, we do have two boolean values in the datasets.

ALTER TABLE california
ALTER COLUMN all_species_reported TYPE boolean
USING all_species_reported::boolean

-- I just checked the resultant table, and it looks perfect. I'll repeat the procedure above for all the tables: nevada, idaho, utah,
-- bc, oregon, washington, arizona, and california.

SELECT taxonomic_order, common_name, sum(observation_count) as total_count, country_code, state, state_code, county, county_code, 
		avg(latitude) as mean_latitude, avg(longitude) as mean_longitude, observed_date 
FROM arizona
GROUP BY taxonomic_order, common_name, country_code, state, state_code, county, county_code, observed_date 

-- Now, for the actual analysis, I'm only interested in total counts of each bird species per day per county. So, let's sum them.
-- Hopefully that will reduce the dataset even more!

-- I'm going to save this aggregation for each state!

COPY (
	SELECT taxonomic_order, common_name, sum(observation_count) as total_count, country_code, state, state_code, county, county_code, 
			avg(latitude) as mean_latitude, avg(longitude) as mean_longitude, observed_date 
	FROM oregon
	GROUP BY taxonomic_order, common_name, country_code, state, state_code, county, county_code, observed_date ) 
	
	TO 'C:\\Users\\Public\\Documents\\oregon_agg_final.csv' DELIMITER ',' CSV HEADER;

-- Because it's so easy to work with this big dataset in postgres, I might try to pull all those tables in here and then 
-- concat them before I spit them back out again... but maybe I'll just try to import the california set into jupyter
-- first and see if it's really slow or not...