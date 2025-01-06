# System Hardening Verification Script

This repository contains a Bash script designed to verify system hardening measures on Ubuntu servers. The script generates a comprehensive checklist in CSV format, detailing the status of various hardening steps.

## Features

- **System Update Check**: Ensures the system is up-to-date.
- **SSH Root Login Verification**: Confirms that root login over SSH is disabled.
- **Firewall Status Check**: Verifies if the UFW firewall is active.
- **Unnecessary Services Removal**: Checks if specific unused services (e.g., `xinetd`, `telnet`, `ftp`) are removed.
- **File Permissions Check**: Ensures critical system files have proper permissions.
- **Fail2ban Status**: Verifies if Fail2ban is installed and running.
- **Automatic Updates**: Confirms that unattended upgrades are configured.
- **Audit Logging**: Ensures audit logging is enabled.
- **Password Policies**: Checks for secure password requirements.
- **Network Protocols**: Verifies that unused protocols (e.g., `DCCP`, `SCTP`) are disabled.
- **File Integrity Monitoring**: Confirms if AIDE is installed for file integrity checks.
- **Secure Boot**: Verifies if Secure Boot is enabled.

## Prerequisites

- **Operating System**: Ubuntu (tested on recent LTS versions).
- **User Privileges**: Root or sudo access is required to execute the script.

## Usage

1. Clone this repository to your system:
   ```bash
   git clone https://github.com/yourusername/system-hardening-checklist.git
   cd system-hardening-checklist
   ```

2. Make the script executable:
   ```bash
   chmod +x system_hardening_checklist.sh
   ```

3. Run the script with sudo:
   ```bash
   sudo ./system_hardening_checklist.sh
   ```

4. After execution, a `system_hardening_checklist.csv` file will be generated in the current directory, containing the results of the verification.

## Example Output

Sample of the generated CSV file:

```csv
Step,Description,Status
1,System is updated,Pass
2,Root login over SSH is disabled,Pass
3,UFW firewall is active,Fail
...
```


