import argparse
import requests
import json
import csv
import os

#setupargumentparser
parser = argparse.ArgumentParser(description='Get IAM accounts from Trend Micro API')
parser.add_argument('-t', '--token', required=True, help='Bearer token for authentication')
parser.add_argument('-j', '--json', action='store_true', help='Save output as JSON')
parser.add_argument('-c', '--csv', action='store_true', help='Save output as CSV')

#parsearguments
args = parser.parse_args()

#ensurethateither-jor-cisprovided
if not args.json and not args.csv:
    parser.error('You must specify either -j (JSON) or -c (CSV)')

#colordefinitionsusingansiescapecodes
GREEN = '\033[92m'
YELLOW = '\033[93m'
RESET = '\033[0m'

url_base = 'https://api.xdr.trendmicro.com'
url_path = '/v3.0/iam/accounts'
top = 50

headers = {
    'Authorization': 'Bearer ' + args.token,
    'Content-Type': 'application/json'
}

#initializevariables
accounts = []
next_url = f"{url_base}{url_path}?top={top}"

#loopuntiltherearenomoreaccountstoretrieve
while next_url:
    #makethegetrequest
    response = requests.get(next_url, headers=headers)
    
    #checkthestatusoftherequest
    if response.status_code == 200:
        print(f"{GREEN}Request successful. Status: 200 OK{RESET}")

        #parsetheresponseasjson
        if 'application/json' in response.headers.get('Content-Type', ''):
            response_json = response.json()

            #addtheretrievedaccountstothelist
            if 'items' in response_json:
                accounts.extend(response_json['items'])
                print(f"{YELLOW}Accounts retrieved in this batch: {len(response_json['items'])}{RESET}")
                print(f"{YELLOW}Total accounts retrieved so far: {len(accounts)}{RESET}")

            #checkifthereisanextlinkforpagination
            if 'nextLink' in response_json:
                next_url = response_json['nextLink']
            elif '@odata.nextLink' in response_json:
                next_url = response_json['@odata.nextLink']
            else:
                print(f"{YELLOW}No more pages to retrieve.{RESET}")
                next_url = None
        else:
            print("Response is not JSON or is empty.")
            break
    else:
        print(f"{YELLOW}Error fetching data: {response.status_code} - {response.text}{RESET}")
        exit(1)

#logthetotalaccountsretrieved
print(f"{YELLOW}Total accounts retrieved: {len(accounts)}{RESET}")

#savetheoutputbasedontheprovidedflag
if args.json:
    json_file = os.path.join(os.getcwd(), 'accounts.json')
    with open(json_file, 'w') as f:
        json.dump(accounts, f, indent=4)
    print(f"{GREEN}JSON file saved at: {os.path.abspath(json_file)}{RESET}")

elif args.csv:
    if len(accounts) > 0:
        csv_file = os.path.join(os.getcwd(), 'accounts.csv')
        with open(csv_file, 'w', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=accounts[0].keys())
            writer.writeheader()
            writer.writerows(accounts)
        print(f"{GREEN}CSV file saved at: {os.path.abspath(csv_file)}{RESET}")
    else:
        print(f"{YELLOW}No accounts were retrieved that can be exported to CSV.{RESET}")
