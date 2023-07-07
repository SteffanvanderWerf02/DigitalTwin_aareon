import sys
sys.path.append('../database')
import database 
import requests
import json
from sys import argv

import sys
sys.path.append('../')
from utility.utility import readYamlFile

config = readYamlFile("../config.yaml")
 
headers = {config[1]["facilitor"]["api_header"]: config[1]["facilitor"]["api_key"], 'Accept-Charset': 'UTF-8', 'Connection': 'keep-alive', 'Accept': 'application/json'}

def sendPostRequest(url, jsonData):
  r = requests.post(url, json=jsonData, headers=headers)
  return r

def sendGetRequest(url, jsonData):
  r = requests.get(url, json=jsonData, headers=headers)
  return r

def sendPutRequest(url, jsonData):
  r = requests.put(url, json=jsonData, headers=headers)
  

  print(f"status: {r.status_code} response: {r.json()}")
 
  return r
  

if __name__ == "__main__":
  database.getFormatedData()
 
with open('data.json') as json_file:
    data = json.load(json_file)

for id, item in data.items():
    url = f"https://sggr.facilitor-test.nl/API2/objects/{id}.json"
    jsonData = {
       "object" :{
          "state": str(item['state'])
       }
        
    }
    # print(f"URL: {url} jsondata: {jsonData} HEADERS: {headers}")

    # send the PUT request
    sendPutRequest(url, jsonData)

print(f"[*] Facilitor updated")
  
  


