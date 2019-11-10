# Domain of interest
Our topic of interest is **climate change** and **global warming**.

## Why are we interested?
We think this climate change is one of the most important problems in our society; in the present and near future. As young people, we are very concerned about it.   
We believe that technology and specially data science can be very useful to identify the causes, the consequences and reduce global warming. As this is a wide topic, there are a lot of public and varied data available in the internet that we can explore: global temperatures, CO2 emissions, biodiversity, energy production, mobility, etc.   
Due to all of these reasons, we think that it is a really interesting domain to tackle with in this project.

## Examples of data driven projects
It is expectable that many people and organizations are working with data to address this issue. We can find some examples:
- [__Using data to increase the production of renewable energy__](https://deepmind.com/blog/article/machine-learning-can-boost-value-wind-energy): Renewable energy help combat climate change, but many of them have not reached their full potential. DeepMind and Google has been applying machine learning algorithms to increase the productivity of wind farms in US (predicing wind power output 36 hours ahead of actual generation).  
- [__Protecting the rainforests__](https://rfcx.org/): Rainforest Connection is a not-for-profit organization. They used old mobile phones, equipped with solar panels and placed in the branches of trees where they listen for sounds of logging trucks and chainsaws. The detection model behind this is driven by TensorFlow.  
- [__Cleaning Mexico City’s air with transformational climate policies through big data pattern analysis in traffic & social mobility__](http://www.dataforclimateaction.org/meet-the-winners/): Mexico City is the most congested city in the world. Traffic data from Waze, data from EPA MOVES-Mexico, and Google Places’ Popular Times are used to optimize transportation and reduce CO2 emissions by 3.4%.  

## Data driven questions we hope to answer
1. __Is the climate change affecting all areas of the Earth equally, or are there some regions suffering more?__  
2. __What was (in terms of climate change) the 'worst year' for our planet? (more polluted year, higher temperature...)__  
3. __What are the countries that pollute the most?__  

# Finding data
In this section we summarize information about the data we have found.  

## CO2 emissions
1. URL: https://datahub.io/core/co2-ppm
2. Data from this dataset is CO2 presence in air, measured as the mole fraction in dry air. Data are sourced from the US Government’s Earth System Research Laboratory, Global Monitoring Division. Data from March 1958 through April 1974 have been obtained by C. David Keeling of the Scripps Institution of Oceanography (SIO) and were obtained from the Scripps website (scrippsco2.ucsd.edu).  
3. It has 727 observations and 6 features.  
4. The first and third questions cannot be answered, because we only have the CO2 level data refer to one observatorium. With respect to the second one, we can obtain the year with more CO2 emissions.  

## Black-backed gulls movement
1. URL: https://www.datarepository.movebank.org/handle/10255/move.575  
2. Data is about the location of black-backed gulls along their trips. The project is addressed by the organization [Movebank](https://www.movebank.org/). Data is gathered by attaching GPS data loggers to eight incubating birds and collecting information on diet and habitat use. The loggers recorded data for 10–19 days to allow flight-path reconstruction.  
3. In this dataset can be found 49619 observations and 17 features.
4. We cannot find an answer to any of the questions. We could give a partial response for the first one, because we only have data in a zone of America. For the second one we only have one year, so we can't compare. We don't know the pollution level of each country, so the third question won't be answered too.  

## International comprehensive Ocean-Atmosphere (ICOADS-NOAA)
1. URL: https://rda.ucar.edu/datasets/ds548.0/  
2. This data was collected by the NOAA (U.S. National Oceanic and Atmospheric Administration).  
3. We can find 100000 observations and 76 features.  
4. We can answer the first and the second questions because we have data from different years and zones of the globe. We might say something about the zone that pollutes the most, but not the country.