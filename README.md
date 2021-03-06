# GlobalArchiveLib

A library for interacting with the Global Archive repository

## Get the code

```bash
git clone https://github.com/UWAMEGFisheries/globalarchive-api.git
```

## Run the example
Example code is contained in: `R/examples/get_campaigns.R`. It is strongly
advised that you look at the source before running it as the comments explain
things and there are options for configuring it to do what you want to do.

To run the example code as is:
```bash
cd galib/R
Rscript examples/get_campaigns.R <USER_API_TOKEN>
```
Where `<USER_API_TOKEN>` is your API token for the GA API. This will download
all .csv and .txt files for all campaigns matching your query.

## Understanding the code

-----

### Example script: `R/examples/get_campaigns.R`
This is an example script that demonstrates how to get campaigns from the API.
The idea is that this script provides a starting point, and you can copy this
and take what you need out of it to make your own scripts / queries. It depends on `R/galib.R`, which is sourced at the top of the file: `source("galib.R")` and needs to be in the current working directory.

The main line which does all the work is:

```R
nresults <- ga.get.campaign.list(API_USER_TOKEN, process_campaign_object, q=q)
```

This function is contained in the `R/galib.R` library which retrieves all campaigns
out of the API matching query `q` accessible by `API_USER_TOKEN` and processes
them using the user defined function `process_campaign_object`


##### Setting  `USER_API_TOKEN`
You can either set this through command line argument as demonstrated above, or
configure it as a variable in the script.


##### Configuring `q`
The variable `q` is a JSON string that contains the search pattern for the API.
It is passed to the `ga.get.campaign.list()` function, which processes the
matched results. Some examples search queries:

```R
# EXAMPLE 1: search for all campaigns matching pattern ( % = wildcard)
q='{"filters":[{"name":"name","op":"like","val":"%_PointAddis_stereoBRUVs"}]}'
# EXAMPLE 2: search for specific campaign by name
q='{"filters":[{"name":"name","op":"eq","val":"2011-09_Barrow.PDS_stereoBRUVs"}]}'
# EXAMPLE 3: search for all campaigns by user's email
q='{"filters":[{"name":"user","op":"has","val":{"name":"email","op":"eq","val":"euan.harvey@curtin.edu.au"}}]}'
# EXAMPLE 4: search for all campaigns from Project (note + for spaces)
q='{"filters":[{"name":"project","op":"has","val":{"name":"name","op":"eq","val":"Pilbara+Marine+Conservation+Partnership"}}]}'
# EXAMPLE 5: search for all campaigns from Collaboration (note + for spaces)
q='{"filters":[{"name":"workgroups","op":"any","val":{"name":"name","op":"eq","val":"Australian+BRUV+synthesis"}}]}'
# EXAMPLE 6: search for all campaigns from Collaboration with wildcard search (%=wildcard, ilike=case insensitive)
q='{"filters":[{"name":"workgroups","op":"any","val":{"name":"name","op":"ilike","val":"nsw%bruvs"}}]}'
# EXAMPLE 7: get all campaigns that my user account has access to
q=""
```
NB: this is not an exhaustive list, there are many more searches that you can do

##### Configuring `DATA_DIR` and `MATCH_FILES`
The variables `DATA_DIR` and `MATCH_FILES` sets where and what to download.
```R
DATA_DIR <- "my_data"
```
This is a relative path in the working directory, but can be an absolute / relative path of where you want the query files to go.

```R
# Example 1: only download `.csv` and `.txt` files
MATCH_FILES <- ".csv$|.txt$"
# Example 2: only download files with `*_Metadata.*` in the filename
MATCH_FILES <- "_Metadata."
# Example 3: download all files
MATCH_FILES <- NULL
```
`MATCH_FILES` is passed to the `ga.download.campaign_files()`
function. That will filter the set of campaign files to download only the
matching ones. This is useful if you do not want to download all the .emobs
and/or .zip files. Some examples:

##### Setting up the `process_campaign_object()` function
The function `process_campaign_object()` is a user-defined function that is passed into
`ga.get.campaign.list()` and applied to every campaign object in the list.
In the example code, it is set up to perform the following operations:

```R
# Perform another request to the API to get more detailed campaign info
campaign <- ga.get.campaign(API_USER_TOKEN, object["id"])
# Print campaign_info to console
ga.print.campaign_details(campaign)
# Download/save campaign files matching `MATCH_FILES`
campaign_files = ga.download.campaign_files(API_USER_TOKEN, campaign$files, campaign_path, match=MATCH_FILES)
# Generate csv file containing all campaign info properties
ga.download.campaign_info(API_USER_TOKEN, campaign$info, campaign_path)
# Generate json file containing campaign record information
ga.download.campaign_record(API_USER_TOKEN, campaign, campaign_path)
```
All of the above convenience functions are contained in `R/galib.R` library.
You can add to this function to perform operations on each campaign at processing
time or alternatively you can run queries on all downloaded files at the end.

-----

### Library module: `R/galib.R`
This is a library containing convenience functions which abstract the GA API
interactions making it quick and easy to get data from the API.

```
TODO: documentation still to come
```

-----

# TODO

* Turn galib.R into an R package to make it easier
* Implement the many other API functions that are not yet included in galib.R
