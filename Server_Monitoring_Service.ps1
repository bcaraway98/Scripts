# Set the SMTP server and port for sending emails
$SMTPServer = "smtp.yourdomain.com"

# Set the from and to email addresses and the subject of the email
$From = "Server Monitoring Service <monitor@yourdomain.com>"
$To = "email@yourdomain.com"
$Subject = "Server Response Failure"

# Set the Active Directory domain name
$domainName = "yourdomain.com"

# Get the list of servers from Active Directory
$servers = Get-ADComputer -Filter { OperatingSystem -like "*Server*" } -Property Name -Server $domainName | Select-Object -ExpandProperty Name

# Set the number of times to loop through the servers
$loopCount = 1

# Loop through the servers $loopCount times
for ($i = 1; $i -le $loopCount; $i++) {

    # Loop through each server in the list
    foreach ($server in $servers) {

        # Set the initial failed ping count to 0 for each server
        $failedPings = 0

        # Loop until we have 3 failed pings
        while ($failedPings -lt 3) {

            # Ping the server
            $ping = Test-Connection -ComputerName $server -Count 1 -ErrorAction SilentlyContinue

            # Check if the ping was successful
            if ($ping) {
                Write-Host "$server is online."
                
                # Reset the failed ping count for this server
                $failedPings = 0
                
                # Break out of the loop for this server and move on to the next one
                break
            }
            else {
                $failedPings++
                
                # Check if we have reached 3 failed pings
                if ($failedPings -eq 3) {
                    
                    # Alert host to failed server ping
                    Write-Host "ALERT: $server has not responded to 3 consecutive pings!"
                    
                    # Create body of alert email
                    $body = "The server $server has not responded to 3 consecutive ping attempts.  Server may be offline."

                    # Send alert email
                    Send-MailMessage -From $From -To $To -Subject $Subject -SmtpServer $SMTPServer -Body $Body
                    
                }
                else {
                    Write-Host "Ping failed for $server. Failed pings: $failedPings/3."
                }
            }
        }
    }
    # Uncomment to create repeating loop at set time interval
    #Start-Sleep -Seconds (5 * 60)
}