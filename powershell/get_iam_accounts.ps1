param (
    [string]$token,
    [switch]$json,  #flag for json output
    [switch]$csv    #flag for csv output
)

#ensure the token is provided
if (-not $token) {
    Write-Error "Token is required. Please provide a valid token."
    exit 1
}

#validate output format (must provide either -json or -csv)
if (-not $json -and -not $csv) {
    Write-Error "You must specify either -json or -csv."
    exit 1
}

#define the url base and path
$url_base = "https://api.xdr.trendmicro.com"
$url_path = "/v3.0/iam/accounts"

#define headers
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type"  = "application/json"
}

#initialize variables
$allAccounts = @()
$top = "?top=50"
$next_url = "$url_base$url_path$top"  #s properly formatted initial request with 'top=50'

#log the initial url for debugging purposes
Write-Host "Initial Requesting URL: $next_url" -ForegroundColor Yellow

#loop until there are no more accounts to retrieve
while ($next_url) {
    #make the get request
    try {
        $response = Invoke-RestMethod -Uri $next_url -Headers $headers -Method Get
    } catch {
        Write-Error "Failed to make the GET request: $_"
        exit 1
    }

    #log the status of the request
    Write-Host "Request successful. Status: 200 OK" -ForegroundColor Green

    #process the response
    if ($response -ne $null -and $response.items) {
        #add the retrieved accounts to the list
        $allAccounts += $response.items

        #log the number of accounts retrieved in this batch
        Write-Host "Accounts retrieved in this batch: $($response.items.Count)" -ForegroundColor Yellow

        #check if the response contains the "nextLink" or similar field for pagination
        if ($response.PSObject.Properties["nextLink"]) {
            $next_url = $response.nextLink
        } elseif ($response.PSObject.Properties["@odata.nextLink"]) {
            $next_url = $response."@odata.nextLink"
        } else {
            Write-Host "No more pages to retrieve." -ForegroundColor Yellow
            break
        }
    } else {
        Write-Warning "No more accounts to retrieve or invalid response."
        break
    }
}

#print the response summary with the label in green and the count in white
Write-Host "Total accounts retrieved: " -ForegroundColor Green -NoNewline
Write-Host "$($allAccounts.Count)" -ForegroundColor White

#save the response based on the user's choice
try {
    if ($json) {
        #save as json in the current directory
        $jsonPath = ".\accounts.json"
        $allAccounts | ConvertTo-Json -Depth 4 | Out-File -FilePath $jsonPath
        $fullJsonPath = (Get-Item $jsonPath).FullName
        Write-Host -ForegroundColor Green "JSON file saved at: " -NoNewline
        Write-Host -ForegroundColor White "$fullJsonPath"
    } elseif ($csv) {
        #save as csv in the current directory
        $csvPath = ".\accounts.csv"
        $allAccounts | Export-Csv -Path $csvPath -NoTypeInformation
        $fullCsvPath = (Get-Item $csvPath).FullName
        Write-Host -ForegroundColor Green "CSV file saved at: " -NoNewline
        Write-Host -ForegroundColor White "$fullCsvPath"
    }
} catch {
    Write-Error "Failed to save the response to the selected format: $_"
}


