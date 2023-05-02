import pandas as pd
import numpy as np
import warnings
warnings.filterwarnings("ignore")

def read_data_from_csv():
    tags=pd.read_csv('tags.csv')
    return tags


def data_cleaning():
    #DO NOT REMOVE FOLLOWING LINE
    #call remove_unwanted_columns() function to get dataframe
    tags=read_data_from_csv()

    #Remove Unwanted columns
    tags = tags.drop('location',axis = 1)
    
    
    
    #rename columns, only these columns are allowed in the dataset
    # 1.	id
    # 2.	tag_name
    # 3.	created_at
    columns_name = {'id':'id', 
                    'tag text':'tag_name', 
                    'created time':'created_at'
                   }
    tags = tags.rename(columns = columns_name)
    
    #export cleaned Dataset to newcsv file named "tags_cleaned.csv"
    tags.to_csv('tags_cleaned.csv')
    return tags


#Do not Delete the Following function
def task_runner():
    data_cleaning()

task_runner()