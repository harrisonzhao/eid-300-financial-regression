Running the code
=================
run main.m

What features are used
=================
Nasdaq data is aggregated to an Q x D matrix where Q is the number of quarters and D is number of features. The features are, in units of % change from last quarter:
- quarter open
- quarter high
- quarter minimum
- quarter close
- swing
- momentum (+1 from previous quarter if swing is positive, -1 from previous quarter if swing is negative)

The pwc data is formatted int a Q X 2 matrix where Q is the number of quarters and the columns are % change in number of deals and % change in total money in deals. The % change in number of deals is used as a dependent variable in the regression analysis