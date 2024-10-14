# Vision One IAM Accounts Retrieval Script

This Bash script retrieves IAM accounts from [Trend Micro's Vision One API](https://automation.trendmicro.com/xdr/api-v3). You can save the output as either a JSON or CSV file based on a simple flag.

## Prerequisites

- A Unix-like environment (Linux, macOS) with Bash installed.
- `jq` installed on your system (used for parsing JSON).
  - You can install `jq` using:
    - **macOS**: `brew install jq` (requires Homebrew)
    - **Debian/Ubuntu**: `sudo apt-get install jq`
    - **CentOS/RHEL**: `sudo yum install jq`
- A valid Vision One API token. Please see [authentication](https://automation.trendmicro.com/xdr/Guides/Authentication) documentation for more info.

## Installation

Before running the script, make sure you have Bash and `jq` installed/enabled on your machine.

1. Clone or download this repository.

   ```bash
   git clone https://github.com/jmlake569/get_v1_accounts.git
   ```
2. Navigate to the correct folder based on the script you want (in this example we will use bash).

   ```bash
   cd get_v1_accounts/bash
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
./get_iam_accounts.ps1 -t "your_token" -j
```

#### Save as CSV

```bash
./get_iam_accounts.ps1 -t "your_token" -c
```

### Output

The script always saves the file in the directory where it is run. The file names will be:

v1accounts.json if the -json flag is provided.
v1accounts.csv if the -csv flag is provided.

### API Documentation

For detailed API documentation, please refer to the official API documentation:

[Trend Micro API Documentation](https://automation.trendmicro.com/xdr/api-v3#tag/Accounts-(Foundation-Services-release)/paths/~1v3.0~1iam~1accounts/get)