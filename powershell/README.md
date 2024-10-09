# Vision One IAM Accounts Retrieval Script

This PowerShell script retrieves IAM accounts from [Trend Micro's Vision One API](https://automation.trendmicro.com/xdr/api-v3). You can save the output as either a JSON or CSV file based on a simple flag.

## Prerequisites

- PowerShell installed on your system.
- A valid Vision One API token. Please see [authentication](https://automation.trendmicro.com/xdr/Guides/Authentication) documentation for more info.

## Installation

Before running the script, make sure you have Powershell installed/enabled on your machine.

1. Clone or download this repository.

   ```bash
   git clone https://github.com/jmlake569/get_v1_accounts.git
   ```

## Usage

To use the script, you'll need a Bearer token for authentication with Vision One's API.

### Basic Command Structure

To use the script, you need to specify:

- The `-token` parameter with a valid API token.
- One of the following output flags:
  - `-json`: To save the output as a JSON file.
  - `-csv`: To save the output as a CSV file.

### Example Commands

#### Save as JSON

```bash
./get_iam_accounts.ps1 -token "your_token" -json
```

#### Save as CSV

```bash
./get_iam_accounts.ps1 -token "your_token" -json
```

### Output

The script always saves the file in the directory where it is run. The file names will be:

v1accounts.json if the -json flag is provided.
v1accounts.csv if the -csv flag is provided.

### API Documentation

For detailed API documentation, please refer to the official API documentation:

[Trend Micro API Documentation](https://automation.trendmicro.com/xdr/api-v3#tag/Accounts-(Foundation-Services-release)/paths/~1v3.0~1iam~1accounts/get)