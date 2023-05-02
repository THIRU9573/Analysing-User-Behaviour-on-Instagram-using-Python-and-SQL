import pandas as pd
import numpy as np
import warnings
warnings.filterwarnings("ignore")

def read_data_from_csv():
    follows=pd.read_csv('follows.csv')
    return follows


def data_cleaning():
    #DO NOT REMOVE FOLLOWING LINE
    #call remove_unwanted_columns() function to get dataframe
    follows=read_data_from_csv()

    #Remove Unwanted columns
    unwanted_columns = ['is follower active','followee Acc status']
    follows = follows.drop(unwanted_columns,axis = 1)
    
    
    
    #rename columns, only these columns are allowed in the dataset
    # 1.	follower_id
    # 2.	followee_id
    # 3.	created_at
    columns_name = {'follower':'follower_id',
                   'followee ':'followee_id',
                    'created time':'created_at'
                   }
    follows = follows.rename(columns = columns_name)
    
    #export cleaned Dataset to newcsv file named "follows_cleaned.csv"
    follows.to_csv('follows_cleaned.csv')
    return follows


#Do not Delete the Following function
def task_runner():
    data_cleaning()

task_runner()