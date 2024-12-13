import subprocess
import logging
import smtplib
from email.mime.text import MIMEText
import schedule
import time

# Configure logging
logging.basicConfig(filename='/var/log/intrusion_detection.log', level=logging.INFO,
                    format='%(asctime)s %(message)s')

# Email notification function
def send_email(subject, body):
    sender = 'youremail@example.com'
    receivers = ['youremail@example.com']
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = sender
    msg['To'] = ', '.join(receivers)

    try:
        with smtplib.SMTP('localhost') as server:
            server.sendmail(sender, receivers, msg.as_string())
            logging.info('Email sent successfully')
    except Exception as e:
        logging.error(f'Failed to send email: {e}')

# Function to monitor file changes using auditd
def monitor_files():
    files_to_monitor = ['/etc/passwd', '/etc/shadow', '/etc/group']
    for file in files_to_monitor:
        audit_cmd = f'auditctl -w {file} -p wa -k {file}_changes'
        subprocess.run(audit_cmd.split())
        logging.info(f'Monitoring changes to {file}')
    subprocess.run(['systemctl', 'restart', 'auditd'])

# Function to monitor failed login attempts using fail2ban
def monitor_logins():
    fail2ban_config = """
[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 5
bantime = 3600
"""
    with open('/etc/fail2ban/jail.local', 'w') as f:
        f.write(fail2ban_config)
    subprocess.run(['systemctl', 'restart', 'fail2ban'])
    logging.info('Configured fail2ban for SSH monitoring')

# Function to configure iptables for logging suspicious traffic
def configure_iptables():
    iptables_cmds = [
        'iptables -N LOGGING',
        'iptables -A INPUT -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4',
        'iptables -A INPUT -j LOGGING',
        'iptables -A LOGGING -j DROP',
        'iptables-save > /etc/iptables/rules.v4'
    ]
    for cmd in iptables_cmds:
        subprocess.run(cmd.split())
    logging.info('Configured iptables for logging suspicious traffic')

# Function to review logs daily
def review_logs():
    logs = ''
    for key in ['passwd_changes', 'shadow_changes', 'group_changes']:
        cmd = f'ausearch -k {key} -ts today'
        result = subprocess.run(cmd.split(), capture_output=True, text=True)
        logs += result.stdout

    with open('/var/log/fail2ban.log', 'r') as f:
        logs += f.read()

    result = subprocess.run(['grep', 'IPTables-Dropped', '/var/log/syslog'], capture_output=True, text=True)
    logs += result.stdout

    send_email('Daily Log Review', logs)

# Main function to set up monitoring and schedule log reviews
def main():
    monitor_files()
    monitor_logins()
    configure_iptables()

    # Schedule daily log review at midnight
    schedule.every().day.at('00:00').do(review_logs)

    while True:
        schedule.run_pending()
        time.sleep(1)

if __name__ == '__main__':
    main()
