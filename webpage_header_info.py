
import requests
from bs4 import BeautifulSoup

import win32com.client as w32

import sys
import json
import time

import pandas as pd

def scrape_webpage(linux_ip = "132.181.49.151"):
    url = f"http://{linux_ip}/cgi-bin/bncstat/"
    
    response = requests.get(url)
    if response.status_code == 200:
        
        soup = BeautifulSoup(response.text, 'html.parser')
        
        table = soup.find('table')
        
        if table:
            
            headers = []
            
            for i in range(len(table.find_all('th'))):
                headers.append(table.find_all('th')[i].get_text(strip=True))
            
            rows = []
            for row in table.find_all('tr'):
                cols = row.find_all('td')
                row_data = [col.get_text(strip=True) for col in cols]
                rows.append(row_data)
                
            df = pd.DataFrame([rows], columns = headers)
            df.drop(columns=['Object ID', 'Value'], inplace = True)
            df_final = df.map(lambda x : x[0] if isinstance(x, list) else x)
            
            diction = {'RA' : df_final['RA'].iloc[0], 'DEC' : df_final['Dec'].iloc[0], 
                       'EPOCH' : df_final['Epoch'].iloc[0], 'SIDTRACK' : df_final['Nonsid Track'].iloc[0], 
                       'ALTITUDE' : df_final['Alt'].iloc[0], 'AZIMUTH' : df_final['Azi'].iloc[0], 
                       'LST' : df_final['LST'].iloc[0], 'HA' : df_final['Hour Angle'].iloc[0], 
                       'AIRMASS' : df_final['Airmass'].iloc[0], 'FLAGS' : df_final['Flags'].iloc[0], 
                       'TELLIMIT' : df_final['Limits'].iloc[0],  'UTTIME' : df_final['UT Time'].iloc[0]}
            
            
        else:
            diction = {'RA' : '--', 'DEC' : '--', 'EPOCH' : '--', 'SIDTRACK' : '--', 
                       'ALTITUDE' : '--', 'AZIMUTH' : '--', 'LST' : '--', 'HA' : '--', 
                       'AIRMASS' : '--', 'FLAGS' : '', 'TELLIMIT' : None,  'UTTIME' : '--'}
            
    else:
        diction = {'RA' : '--', 'DEC' : '--', 'EPOCH' : '--', 'SIDTRACK' : '--', 
                   'ALTITUDE' : '--', 'AZIMUTH' : '--', 'LST' : '--', 'HA' : '--', 
                   'AIRMASS' : '--', 'FLAGS' : '', 'TELLIMIT' : None,  'UTTIME' : '--'}
        
    return diction


header_info = scrape_webpage()
# print(json.dumps(header_info))

for head in header_info:
    print(f"{head}={header_info[head]}")

#