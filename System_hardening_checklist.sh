#!/bin/bash

# Define the output CSV file
OUTPUT_FILE="system_hardening_checklist.csv"

# Initialize the CSV file with headers
echo "Step,Description,Status" > $OUTPUT_FILE

# Function to log step results
log_result() {
    local step="$1"
    local description="$2"
    local status="$3"
    echo "$step,$description,$status" >> $OUTPUT_FILE
}

# 1. Verify if the system is updated
echo "Verifying if the system is updated..."
if sudo apt update | grep -q 'All packages are up to date'; then
    log_result 1 "System is updated" "Pass"
else
    log_result 1 "System is updated" "Fail"
fi

# 2. Verify if root login over SSH is disabled
echo "Verifying if root login over SSH is disabled..."
if grep -q '^PermitRootLogin no' /etc/ssh/sshd_config; then
    log_result 2 "Root login over SSH is disabled" "Pass"
else
    log_result 2 "Root login over SSH is disabled" "Fail"
fi

# 3. Verify UFW firewall status
echo "Verifying UFW firewall status..."
if sudo ufw status | grep -q 'Status: active'; then
    log_result 3 "UFW firewall is active" "Pass"
else
    log_result 3 "UFW firewall is active" "Fail"
fi

# 4. Verify if unnecessary services are removed
echo "Verifying if unnecessary services are removed..."
UNNECESSARY_SERVICES=("xinetd" "telnet" "ftp")
for service in "${UNNECESSARY_SERVICES[@]}"; do
    if ! dpkg -l | grep -q "$service"; then
        log_result 4 "Service $service is removed" "Pass"
    else
        log_result 4 "Service $service is removed" "Fail"
    fi
done

# 5. Verify permissions on critical files
echo "Verifying permissions on critical files..."
PERMISSIONS=(
    "/etc/passwd:644"
    "/etc/shadow:600"
    "/etc/gshadow:600"
    "/etc/group:644"
)
for item in "${PERMISSIONS[@]}"; do
    file=$(echo "$item" | cut -d":" -f1)
    perm=$(echo "$item" | cut -d":" -f2)
    if [ "$(stat -c %a "$file")" == "$perm" ]; then
        log_result 5 "Permissions on $file are set correctly" "Pass"
    else
        log_result 5 "Permissions on $file are set correctly" "Fail"
    fi
done

# 6. Verify if Fail2ban is installed and active
echo "Verifying Fail2ban installation and status..."
if systemctl is-active --quiet fail2ban; then
    log_result 6 "Fail2ban is installed and active" "Pass"
else
    log_result 6 "Fail2ban is installed and active" "Fail"
fi

# 7. Verify if automatic updates are configured
echo "Verifying automatic updates configuration..."
if dpkg -l | grep -q unattended-upgrades; then
    log_result 7 "Automatic updates are configured" "Pass"
else
    log_result 7 "Automatic updates are configured" "Fail"
fi

# 8. Verify audit logging
echo "Verifying audit logging..."
if systemctl is-active --quiet auditd; then
    log_result 8 "Audit logging is enabled" "Pass"
else
    log_result 8 "Audit logging is enabled" "Fail"
fi

# 9. Verify secure password policies
echo "Verifying secure password policies..."
if grep -qE '^minlen = 12' /etc/security/pwquality.conf; then
    log_result 9 "Password minimum length is 12 characters" "Pass"
else
    log_result 9 "Password minimum length is 12 characters" "Fail"
fi

if grep -qE '^ucredit = -1' /etc/security/pwquality.conf; then
    log_result 10 "Password requires at least one uppercase letter" "Pass"
else
    log_result 10 "Password requires at least one uppercase letter" "Fail"
fi

# 10. Verify if unused network protocols are disabled
echo "Verifying if unused network protocols are disabled..."
if ! lsmod | grep -q "dccp"; then
    log_result 11 "DCCP protocol is disabled" "Pass"
else
    log_result 11 "DCCP protocol is disabled" "Fail"
fi

if ! lsmod | grep -q "sctp"; then
    log_result 12 "SCTP protocol is disabled" "Pass"
else
    log_result 12 "SCTP protocol is disabled" "Fail"
fi

# 11. Verify if file integrity monitoring is enabled
echo "Verifying file integrity monitoring..."
if dpkg -l | grep -q aide; then
    log_result 13 "File integrity monitoring is enabled (AIDE installed)" "Pass"
else
    log_result 13 "File integrity monitoring is enabled (AIDE installed)" "Fail"
fi

# 12. Verify if secure boot settings are enabled
echo "Verifying secure boot settings..."
if [ -d /sys/firmware/efi ]; then
    log_result 14 "Secure Boot is enabled" "Pass"
else
    log_result 14 "Secure Boot is enabled" "Fail"
fi

# Print completion message
echo "System hardening verification complete. Report saved to $OUTPUT_FILE."
