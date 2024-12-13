#!/bin/bash

# Install necessary packages
sudo apt-get update

# Configure auditd for monitoring important files
echo "Configuring auditd..."
sudo auditctl -w /etc/passwd -p wa -k passwd_changes
sudo auditctl -w /etc/shadow -p wa -k shadow_changes
sudo auditctl -w /etc/group -p wa -k group_changes

# Restart auditd service to apply changes
echo "Restarting auditd service..."
sudo systemctl restart auditd

# Configure fail2ban to monitor for failed login attempts
echo "Configuring fail2ban..."
sudo bash -c 'cat << EOF > /etc/fail2ban/jail.local
[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 5
bantime = 3600
EOF'

# Restart fail2ban service to apply changes
echo "Restarting fail2ban service..."
sudo systemctl restart fail2ban

# Configure iptables to log and drop suspicious traffic
echo "Configuring iptables..."
sudo iptables -N LOGGING
sudo iptables -A INPUT -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
sudo iptables -A INPUT -j LOGGING
sudo iptables -A LOGGING -j DROP

# Save iptables rules
echo "Saving iptables rules..."
sudo sh -c 'iptables-save > /etc/iptables/rules.v4'

# Set up a daily log review cron job
echo "Setting up a daily log review cron job..."
sudo bash -c 'cat << EOF > /etc/cron.daily/log_review
#!/bin/bash
# Review audit logs
ausearch -k passwd_changes -ts today | mail -s "Daily Log Review - passwd changes" root
ausearch -k shadow_changes -ts today | mail -s "Daily Log Review - shadow changes" root
ausearch -k group_changes -ts today | mail -s "Daily Log Review - group changes" root
# Review fail2ban logs
cat /var/log/fail2ban.log | mail -s "Daily Log Review - Fail2Ban" root
# Review iptables logs
grep "IPTables-Dropped" /var/log/syslog | mail -s "Daily Log Review - IPTables" root
EOF'
sudo chmod +x /etc/cron.daily/log_review

echo "Intrusion detection setup complete!"
