## CO2 Data preparation 
The data comes with some redundant columns (Date and Decimal.Date) so we remove the latter.
We also renamed the Numbers.of.days coloumn to Days for simplicity and usability

### Data manipulation 
Once we get here we can start mangling the data and remove the outliers, since in the Average coloumn there are only 7 observation with -99.99 (which indicates it was not read).
At this point we can start working with the variable correlation
It is clear that the three variables are **highly correlated** so we decide to use only one of the dropping the rest, so we decided to use the Trend one as it has the least Variance.

### Question 2:  What was (in terms of climate change) the 'worst year' for our planet? (more polluted year, higher temperature...)
By worst year here we mean that we are looking for the highest CO2 level in the data 
**pre-testing assumption**: 
we expect that the worst year will be towards the end as it is constantly increasing.
### Question 2: Results 
The results indeed confirm what we were thinking already, by seeing the graph it is clear that the increase of CO2 levels is increasing each year, and the worst year for that is the last recorded which is 2018

