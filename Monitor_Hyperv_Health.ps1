# Set the SMTP server and port for sending emails
$SMTPServer = "smtp-relay.gmail.com"
$SMTPPort = "25"

 

# Set the from and to email addresses and the subject of the email
$From = "Sender@example.com"
$To = "recieve@example.com"
$Subject = "Hyper-V Replication Failure"



# Set List of Hyper-V Hosts
$hypervhosts = "server-01","server-02"

Foreach ($server in $hypervhosts)
    {
        # Get a list of all virtual machines on the host
        Invoke-Command -ComputerName $Server {$VMs = Get-VM}

 

            # Loop through each virtual machine
            foreach ($VM in $VMs) {
           
            # Check if the virtual machine has replication enabled
            if ($VM.ReplicationState -eq "ReplicationEnabled") {
            
                # Get the replication status of the virtual machine
                 $ReplicationStatus = Get-VMReplication $VM

 

                    # Check if the replication health is not "Normal"
                    if ($ReplicationStatus.ReplicationHealth -ne "Normal") {
     
                # Set the body of the email
                $Body = "The replication health for VM '$($VM.Name)' is '$($ReplicationStatus.ReplicationHealth)'."

 

      # Send the email
      Send-MailMessage -SmtpServer $SMTPServer -Port $SMTPPort -From $From -To $To -Subject $Subject -Body $Body
    }
  }
}
    }