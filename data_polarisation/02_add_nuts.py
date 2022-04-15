################
"""
Add nuts2 regions to dataset.

Change values DATAPATH, CON2NUTSPATH to location of dataset, constituency2nuts2 conversion table and output file, respectively.

Note: this overwrites the dataset created previously.

Tested working with:
  python 3.10.4
  pandas 1.4.2
"""
################

import pandas as pd

# Set import variables
datapath = r'DATAPATH'
nutspath = r'CON2NUTSPATH'
datadt = {'speech': 'string', 'party': 'string', 'constituency': 'string', 'year': int, 'month': int}
nutsdt = {'constituency': 'string', 'nuts2': 'string'}

# Import dataset and conversion table
datadf = pd.read_csv(datapath, dtype=datadt)
cons2nuts = pd.read_csv(nutspath, dtype=nutsdt)

# Get length of dataset
datalen = len(datadf)

# Pre-construct list of nuts regions
nutslist = ['']*datalen

# Add region to list if there is a corresponding value in the conversion table (only for England and Wales)
for i in range(datalen):

    constituency = datadf.iloc[i]['constituency']
    try:
        nutsregion = cons2nuts.query('constituency == @constituency').iloc[0]['nuts2']
    except:
        nutsregion = ''

    nutslist[i] = nutsregion

# Insert the list into the dataset as a column and replace original file
datadf.insert(2, 'nuts2', nutslist)
datadf.to_csv(datapath, index=False)