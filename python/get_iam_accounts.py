import argparse
import requests
import json
import csv
import os

#set up argument parser
parser = argparse.ArgumentParser(description='Get IAM accounts from Trend Micro API')
parser.add_argument('-t', '--token', required=True, help='Bearer token for authentication')
parser.add_argument('-j', '--json', action='store_true', help='Save output as JSON')
parser.add_argument('-c', '--csv', action='store_true', help='Save output as CSV')

#parse arguments
args = parser.parse_args()

#ensure that either -j or -c is provided
if not args.json and not args.csv:
    parser.error('You must specify either -j (JSON) or -c (CSV)')

url_base = 'https://api.xdr.trendmicro.com'
url_path = '/v3.0/iam/accounts'

headers = {
    'Authorization': 'Bearer ' + args.token
}

# Make the GET request without specifying any 'top' or 'skip' parameters
response = requests.get(url_base + url_path, headers=headers)

# Check if the response is JSON and parse it
if response.status_code == 200 and 'application/json' in response.headers.get('Content-Type', ''):
    response_json = response.json()

    if 'items' in response_json and len(response_json['items']) > 0:
        accounts = response_json['items']
        print(f"Fetched {len(accounts)} records.")
    else:
        print("No accounts were found.")
        exit(0)
else:
    print(f"Error fetching data: {response.status_code} - {response.text}")
    exit(1)

# Save the output based on the provided flag
if args.json:
    json_file = os.path.join(os.getcwd(), 'all_accounts.json')
    with open(json_file, 'w') as f:
        json.dump(accounts, f, indent=4)
    print(f"JSON file saved at: {json_file}")

elif args.csv:
    if len(accounts) > 0:
        csv_file = os.path.join(os.getcwd(), 'all_accounts.csv')
        with open(csv_file, 'w', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=accounts[0].keys())
            writer.writeheader()
            writer.writerows(accounts)
        print(f"CSV file saved at: {csv_file}")
    else:
        print("No accounts were retrieved that can be exported to CSV.")

