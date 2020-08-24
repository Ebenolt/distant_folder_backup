import time, smtplib, datetime, sys
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

file_attached = sys.argv[1]


#Sender Mail Credentials
mailusername = "#mail_username#"
mailpassword = "#mail_pass#"
mailserver = "#mail_serv#"
mailport = #mail_port#

#Alerts
email_receiver = "#mail_receiver#"
email_subject = "Backup Status"
email_masquerade = "Status Bot <#mail_username#>"

msg=MIMEMultipart()
msg['From'] = email_masquerade
msg['To'] = email_receiver
msg['Subject'] = email_subject


mailbody = ''.join(open(file_attached).readlines())
msg.attach(MIMEText(mailbody,'text'))

mailcontent=msg.as_string()

server = smtplib.SMTP(mailserver, mailport)
server.starttls()
server.login(mailusername, mailpassword)
server.sendmail(mailusername,email_receiver, mailcontent)
server.quit()
