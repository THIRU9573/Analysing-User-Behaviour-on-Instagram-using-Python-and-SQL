import pandas as pd
import numpy as np
import warnings
warnings.filterwarnings("ignore")

def read_data_from_csv():
    users=pd.read_csv('users.csv')
    return users


def data_cleaning():
    #DO NOT REMOVE FOLLOWING LINE
    #call remove_unwanted_columns() function to get dataframe
    users=read_data_from_csv()

    #Remove Unwanted columns
    unwanted_columns = ['private/public', 'post count','Verified status']
    users = users.drop(unwanted_columns, axis = 1)
    
    
    
    #rename columns, only these columns are allowed in the dataset
    # 1.	id
    # 2.	username
    # 3.	created_at
    columns_name = {'id':'id', 
                    'name':'username',
                    'created time':'created_at'
                   }
    users = users.rename(columns = columns_name)
    
    #export cleaned Dataset to newcsv file named "users_cleaned.csv"
    users.to_csv('users_cleaned.csv')
    return users


#Do not Delete the Following function
def task_runner():
    data_cleaning()

task_runner()