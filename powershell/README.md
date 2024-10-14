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
2. Navigate to the correct folder based on the script you want (in this example we will use powershell).

   ```bash
   cd get_v1_accounts/powershell
   ``

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

accounts.json if the -json flag is provided.
accounts.csv if the -csv flag is provided.

### API Documentation

For detailed API documentation, please refer to the official API documentation:

[Trend Micro API Documentation](https://automation.trendmicro.com/xdr/api-v3#tag/Accounts-(Foundation-Services-release)/paths/~1v3.0~1iam~1accounts/get)


./get_iam_accounts.ps1 -t "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJjaWQiOiJiYTcwNmY1Zi01ODdkLTQ5YjctODFmYy05MTA0Y2NmN2ZiZWIiLCJjcGlkIjoic3ZwIiwicHBpZCI6ImN1cyIsIml0IjoxNzI4NTc3NTQzLCJldCI6MTc2MDExMzU0MywiaWQiOiJmNjA4MWU3NS0wYjNmLTQ1NzMtODY4Yi02OWI0NGI0MWZmMDAiLCJ0b2tlblVzZSI6ImN1c3RvbWVyIn0.dQHitgpk7Z8umMsIMAbRzNr0EnhKVRy6orHjUUUf5cM6YV9o5KnHjOk00C_0NXW2aOkA6URXXbLpEgQl96Alt9H6GlluKFzzg72-X57j9HegK_S5quxmdkC-xv614lwKpxPEDOAUZa4dW59l1moW2rN2nJz9shYR8a5UMKzxWoUmsDD1VdU9YRCb9jmANQ7XUKUj4zuEozNJo4asp-_xKSGVpihgcB-UVUM0MIp9kWiz8DGuKCRB4fDG-yYgdJpsu1u0Amga8ZJRTJtJ2wj_qfEjRDNsBE1sC4SuKr0LKcWTlV_3wzAhfLly5h6-x-u5u_xLP146fcswgl4DLo84HA0anc-L5w-E1ZSl-jXtjVKC7uLqFhVFIaTDFAcLKsbQ9npUc_3Dk_znf_ol4GQRLUtiquj6tZgkII6DMvbyPPv2s8_Cc6Cgyxg3V2t23BZ3046lqtYuzULYyLr0eZmV5hvenokCOsdDqPbKxl3-6nmjPkOoEXDy_OHAR9vnk_cfCj2eWOZ83fpHdCCu-1da8ZavBvtQ8nCU0cW3MAJA_sdirYGAnSF3IUvqBSAvI_Bk5oSqDSb-UQOzjitZQ0JxkDllzySr_mKnlPFoySDbZRKDA8G6X5RMBHAKhcXzCDSms6JjFa5d_9QEG5A7MvkSTaOhv9QLw9nUUM-go1Q_82g" -csv