import socket
import requests
import argparse


arg_parse = argparse.ArgumentParser(usage=help)
arg_parse.add_argument('-d','--domain',required=True)
args = arg_parse.parse_args()

domainName = (args.domain)

try:
        domainName = socket.gethostbyname(domainName)
except:
        print('[-] No such host found!!')
        sys.exit()
        
search = requests.get('https://ipinfo.io/'+domainName+'/org?token=c8bb8b5ed87127')

asn = (search.text)
print(asn)


