# Hash Cracker Tool

## Overview

This tool is a command-line script designed to crack NT, LM, and SHA256 hashes by leveraging the `https://ntlm.pw` API. The script can process either individual or bulk hash lookups, providing results on cracked passwords along with summary statistics on success rates. Users can specify the hash type and provide a file containing hashes for bulk lookup.

## Features

- **Single and Bulk Hash Lookup**: Supports individual hash lookup and bulk lookup for faster processing.
- **Supports Multiple Hash Types**: NT, LM, and SHA256.
- **Automatic Statistics Summary**: Displays a summary of cracked, not found, and invalid hashes.
- **Error Handling**: Identifies invalid hash formats and reports API errors or rate-limit issues.

## Requirements

- **Bash**: The script is written in Bash, so it requires a Linux, macOS, or Windows environment with Bash support.
- **Curl**: Used to communicate with the `https://ntlm.pw` API for hash lookups.

## Usage

### Command Syntax

```bash
./cracker.sh <hash_type> <hash_file>
```

### Parameters

- `<hash_type>`: Type of hash to crack. Acceptable values are:
  - `nt` - for NT hashes
  - `lm` - for LM hashes
  - `sha256` - for SHA256 hashes
- `<hash_file>`: Path to the file containing the hashes. Each hash should be on a new line.

### Example

```bash
./cracker.sh sha256 hash_file.txt
```

This command will perform a bulk lookup for SHA256 hashes listed in `hash_file.txt`.

### Sample Output

```plaintext
Performing bulk lookup...
Results from bulk lookup:
d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2d2:[not found]
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855:[not found]
5d41402abc4b2a76b9719d911017c592bfbe00b098f3c2c8a57fc6fae6ae05d7:password123
...

--- Summary ---
Total hashes processed: 20
Hashes cracked: 1
Hashes not found: 19
Invalid hashes: 0
```

## Limitations

- **API Rate Limit**: The `https://ntlm.pw` API imposes a quota of 10,000 points every 15 minutes.
- **Invalid Hashes**: Any hash that does not conform to valid formats for NT, LM, or SHA256 will be marked as invalid and skipped in the final count.
- **Maximum Hashes per Bulk Lookup**: The API allows a maximum of 500 hashes per request in bulk lookup mode.


