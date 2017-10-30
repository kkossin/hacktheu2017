
import requests
import json
import string
import random

headers = {
    'user-agent': 'jupyter notebook client',
    'response-content-type':'json'
}

payload = {'apiLogin':'bJ5GQn-9999','apiTransKey':'lL3CNUjWdn','providerId':'511','transactionId':'0','prodId':'5094'}
r = requests.post('https://sandbox-api.gpsrv.com/intserv/4.0/createAccount', headers=headers, data=payload, cert='galileo88.pem')

parsed = json.loads(r.text)
print (json.dumps(parsed, indent=4, sort_keys=True))
#statusCode = dom.getElementsByTagName('status_code')
#print('createAccount response code=' + statusCode[0].firstChild.nodeValue)

