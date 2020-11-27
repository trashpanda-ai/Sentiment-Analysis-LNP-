# Factsheet Automation: Wine Catalogue
We are going to generate color themed Factsheets based on a database/dataset with several visualisations, pictures and texts.
While it's easier to produce single factsheets within a manageable number of entries, this will be a more future-proof approach, if either the number grows significantly or there is a change to the layout.


### Motivation
This is going to be the most versatile approach to document sampled wines. You have the clear presentation of factsheets and the powerful abilities of a database. So you can read again where favourite wines come from, learn more about the winery or show it your guests while they sample it. But you can also analyse the data and for example find correlations between the rating and the grapes used grouped by a price range. Especially beyond a few hundred samples, it can only be managed within a database. Vivino already has this feature included, but you can't access the raw data. Therefore this will be the most beautiful and insightful way to document the wines.


### Approach
First we need an empty LaTex Template and generate our visualisations with the Tikz package. The values will be variables.
Then we are going to create a database with all the information needed to fill our template. For this task we will use Excel because its easy to use, available on all platforms and very friendly for editing texts. (--> exported as .csv)
Finally we can automate the filling in of variables.
To complement the final set of Factsheets, we will add a few introductory pages at the beginning (including a cover) and add an appendix or back cover in the end.


### Preliminary Variables
Name; Year; Rating; Price Range; Winery; Winery Description; Country; Region; Category; Light-to-Bold; Smooth-to-Tannic; Dry-to-Sweet; Soft-to-Acidic; Grapes; Wine Style; Wine Style Description; Alcohol; Main Impressions A; Main Impressions B; Main Impressions C; Food Pairing; Notes; Color (based on country);

"Light-to-Bold; Smooth-to-Tannic; Dry-to-Sweet; Soft-to-Acidic;" are for the taste profile analogous to Vivino.
*Update: Obviously only Red Wine has a Smooth to Tannic Profile! Therefore we introduce "Gentle to Fizzy" for Sparkling Wines and "lean to creamy" for White and Rosé Wines. The Matching is done by Excel (VLOOKUP).*

"Winery; Country; Region; Grapes; Wine Style;" are the "Fundamentals" - not really important for each sample, but very useful for upcoming analysis to find clusters of preferences.

