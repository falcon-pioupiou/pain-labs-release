# Pain Lab Installer Script

## How to Use

1. Save this script as `download-pain-labs.sh`

2. Make it executable:
   ```bash
   chmod +x download-pain-labs.sh
   ```

3. Run it:
   ```bash
   ./download-pain-labs.sh
   ```

4. Options:
   - To specify an output directory:
     ```bash
     ./download-pain-labs.sh --output ~/bin
     ```
   - To see help:
     ```bash
     ./download-pain-labs.sh --help
     ```

## Features

- ✅ Automatically detects OS (macOS/Linux) and architecture (arm64/amd64)
- ✅ Downloads the appropriate binary
- ✅ Makes the binary executable
- ✅ Supports both curl and wget for downloading
- ✅ Includes progress display during download
- ✅ Provides helpful usage instructions
- ✅ Suggests adding to PATH if appropriate
- ✅ Color-coded output for better readability

The script will install the Pain Lab binary in the current directory by default, or in a specified output directory if provided.

