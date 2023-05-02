import pandas as pd
import numpy as np
import warnings
warnings.filterwarnings("ignore")

def read_data_from_csv():
    photo_tags=pd.read_csv('photo_tags.csv')
    return photo_tags


def data_cleaning():
    #DO NOT REMOVE FOLLOWING LINE
    #call remove_unwanted_columns() function to get dataframe
    photo_tags=read_data_from_csv()

    #Remove Unwanted columns
    photo_tags = photo_tags.drop('user id',axis = 1)
    
    
    
    #rename columns, only these columns are allowed in the dataset
    # 1.	photo_id
    # 2.	tag_id
    columns_name = {'photo':'photo_id',
                   'tag ID':'tag_id'
                   }
    photo_tags = photo_tags.rename(columns = columns_name)
    
    
    #export cleaned Dataset to newcsv file named "photo_tags_cleaned.csv"
    photo_tags.to_csv('photo_tags_cleaned.csv')
    return photo_tags


#Do not Delete the Following function
def task_runner():
    data_cleaning()

task_runner()