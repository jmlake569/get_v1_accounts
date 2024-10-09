param (
    [string]$token,
    [switch]$json,  # flag for json output
    [switch]$csv    # flag for csv output
)

# Ensure the token is provided
if (-not $token) {
    Write-Error "Token is required. Please provide a valid token."
    exit 1
}

# Validate output format (must provide either -json or -csv)
if (-not $json -and -not $csv) {
    Write-Error "You must specify either -json or -csv."
    exit 1
}

# Define the URL base and path
$url_base = "https://api.xdr.trendmicro.com"
$url_path = "/v3.0/iam/accounts"

# Define headers
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type"  = "application/json"
}

# Initialize variables
$allAccounts = @()
$offset = 0
$batchSize = 100  # Use a batch size of 100 as per API limits

# Loop until there are no more accounts to retrieve
while ($true) {
    # Define query parameters with 'offset' and 'limit'
    $query_params = @{
        "offset" = $offset
        "limit" = $batchSize
    }

    # Convert query parameters to a query string
    $query_string = ($query_params.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"

    # Construct the full URL
    $full_url = "$url_base$url_path" + "?$query_string"

    # Make the GET request
    try {
        $response = Invoke-RestMethod -Uri $full_url -Headers $headers -Method Get
    } catch {
        Write-Error "Failed to make the GET request: $_"
        exit 1
    }

    # Process the response
    if ($response -ne $null -and $response.items) {
        # Add the retrieved accounts to the list
        $allAccounts += $response.items

        # If the number of items returned is less than the batch size, we've reached the end
        if ($response.items.Count -lt $batchSize) {
            break
        }

        # Increment the offset by the batch size for the next request
        $offset += $batchSize
    } else {
        Write-Warning "No more accounts to retrieve or invalid response."
        break
    }
}

# Print the response summary
Write-Output "Total accounts retrieved: $($allAccounts.Count)"

# Output and save the response based on the user's choice
try {
    if ($json) {
        # Save as JSON in the current directory
        $jsonPath = ".\accounts.json"
        $allAccounts | ConvertTo-Json -Depth 4 | Out-File -FilePath $jsonPath
        Write-Output "JSON file saved at: $jsonPath"
    } elseif ($csv) {
        # Save as CSV in the current directory
        $csvPath = ".\accounts.csv"
        $allAccounts | Export-Csv -Path $csvPath -NoTypeInformation
        Write-Output "CSV file saved at: $csvPath"
    }
} catch {
    Write-Error "Failed to save the response to the selected format: $_"
}