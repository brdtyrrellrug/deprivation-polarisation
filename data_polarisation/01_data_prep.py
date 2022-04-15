################
"""
Construct initial dataset.

Change values PATH and PATHOUT to location of Hansard dataset and output file, respectively.

Tested working with:
  python 3.10.4
  pandas 1.4.2
"""
################

import pandas as pd

######## Import data
print("Importing data...")

# Import required data and set datatypes
datapath = r'PATH'
cols = ['speech', 'party', 'constituency', 'year', 'date']
datatypes = {'speech': 'string', 'party': 'string', 'constituency': 'string', 'year': int}
df = pd.read_csv(datapath, usecols=cols, dtype=datatypes, parse_dates=['date'])

print("Data imported.\n")
########

######## Add new variables
print("Adding new variables...")

# Add month variable from the data variable
df['month'] = df['date'].dt.month

# Add conservative dummy variable
dummies = pd.get_dummies(df['party'])
df.insert(1, 'conservative', dummies['Conservative'])

print("Variables added.\n")
########

######## Drop unwanted variables and records
print("Dropping unwanted variables and records...")

# Drop unwanted variables
df = df.drop(columns=['date', 'party'])

# Drop all records with unwanted years
df = df.query('year >= 2005 & year <= 2018')

# Drop all records with null values
df = df.dropna()

print("Variables and records dropped.\n")
#########

######### Clean variables
print("Cleaning variables...")

# Strip all uncommon characters and numbers from variable var
def denumerise(var):

    df[var] = df[var].str.replace('[^a-zA-Z,.!? ]', '', regex=True)

# Set variable var to lower case and remove all non-alphanumeric characters
def declutter(var):

    df[var] = df[var].str.replace('[^a-zA-Z ]', '', regex=True)
    df[var] = df[var].str.lower()

denumerise('speech')
declutter('constituency')

# Drop speeches with less than 40 characters
df['speechlen'] = df.speech.str.len()
df = df.query('speechlen >= 40')
df = df.drop(columns=['speechlen'])

print("Variables cleaned.\n")
#########

######### Export data to csv
print("Exporting data...")

df.to_csv(r'PATHOUT', index=False)

print("Data exported.\n")
#########

input("Done! Press enter to exit.")
