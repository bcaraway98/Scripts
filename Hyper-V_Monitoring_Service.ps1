# Get a list of all virtual machines on the host
$VMs = Measure-VMreplication | where {$_.Health -eq 'Warning' -or $_.Health -eq 'Critical'} | Select-Object Name,State,Health,LastReplicationTime


# Set the SMTP server and port for sending emails
$SMTPServer = "smtp-server.com"


# Set the from and to email addresses and the subject of the email
$From = "Hyper-V Monitoring Service <monitor@domain.com>"
$To = "System Admin 1 <sysadmin1@domain.com>", "System Admin 2 <sysadmin2@domain.com>"
$Subject = "Hyper-V Replication Failure"




                 #Variables#
#################################################
                  #Script#



# Loop through each virtual machine
foreach ($VM in $VMs) {
      
      #Create body variable with information of Failed Replication
         $Body = "The replication health of Virtual Machine $($VM.Name) is reporting as: $($VM.Health). $($VM.Name) has not replicated since $($VM.LastReplicationTime)"
            
            # Send the email
            Send-MailMessage -From $From -To $To -Subject $Subject -SmtpServer $SMTPServer -Body $Body
}