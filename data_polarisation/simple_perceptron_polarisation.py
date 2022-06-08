# Python 3.10

import pandas as pd
import numpy as np

from sklearn import metrics
from sklearn.linear_model import Perceptron
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer

######## Import data

datapath = r"PATH"

df = pd.read_csv(datapath)

########

######## Perceptron

def perceptron_model(year, region, df=df):

    try:
        # Get national and regional sections
        dfyearreg = df.query('year in @year & nuts2 == @region')

        # Split into speeches and target values (Conservative)
        speechesreg = dfyearreg['speech'].values.tolist()
        targetsreg = dfyearreg['conservative'].values.tolist()

        # Split into training and testing sets
        train_features_reg, test_features_reg, train_targets_reg, test_targets_reg = train_test_split(speechesreg, targetsreg, test_size=0.1, random_state=7324)

        # Initialise vectorizer
        vectorizer = TfidfVectorizer(stop_words='english', lowercase=True, norm='l1')

        # Vectorize sets
        train_features = vectorizer.fit_transform(train_features_reg)
        # test_features = vectorizer.transform(test_features_reg)
        test_features_reg = vectorizer.transform(test_features_reg)

        # Train model
        classifier = Perceptron(random_state=4117)
        classifier.fit(train_features, train_targets_reg)

        # Predict regional test set and store accuracy
        predictionsreg = classifier.predict(test_features_reg)
        scorereg = np.round(metrics.accuracy_score(test_targets_reg, predictionsreg), 4)

        score = scorereg

    except:

        # Set accuracy to 1 if all speeches are from the same target (Conservative or not)
        score = 1

    return(score)

#######

####### Store data
# I was experimenting with national and regional polarisation which is why some variable have nat*.
# I haven't tidied this up yet

# Set region and year lists
regions = sorted(df['nuts2'].unique().tolist())
years = [[2005,2006],[2007,2008],[2009,2010],[2011,2012],[2013,2014],[2015,2016],[2017,2018]]
yearstrs = [str(str(year[0]) + "-" + str(year[1])) for year in years]
# Create dataframe
dfnatresults = pd.DataFrame(index=regions, columns=yearstrs)

# This is for a progress tracker

for year in years:

    yearstr = str(str(year[0]) + "-" + str(year[1]))
    # This is for a progress tracker
    print(yearstr, "started")

    for region in regions:

        # Run the function above
        polarisation = perceptron_model(year, region)
        # Store the results in the dataframe
        dfnatresults.loc[region][yearstr] = polarisation
    
    print("\n*****")
    print(yearstr, "done")
    print("\n*****")

# Export results to csv file
dfnatresults.to_csv(r"PATHOUT") # this is reg

##########