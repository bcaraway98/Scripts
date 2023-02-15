# Set the name of the DNS server you want to test
$dnsServers = @("dns1", "dns2", "dns3")

# Set domain for the DNS you wish to test
$domainName = "yourdomain.com"

# Set DNS record type to test
$queryType = "A"

# Set number of times test are run in the script
$testCount = 3

# Set the from and to email addresses and the subject of the email
$From = "DNS Monitoring Service <monitor@yourdomain.com>"
$To = "support@yourdomain.com"
$Subject = "DNS Resolution Failure"

# Create array variable for each server in $dnsServers list
foreach ($dnsServer in $dnsServers) {
    
    #Alert host to current DNS server being tested
    Write-Host "Testing DNS server $dnsServer"
    
   
    for ($i=1; $i -le $testCount; $i++) {
        
        # Create variable for test
        $result = Resolve-DnsName -Server $dnsServer -Name $domainName -Type $queryType
        if ($result) {
            Write-Host "Test $i succeeded: $($result.IPAddress)"
        } else {
            #Create error message for email and send alert
            $Body = "The DNS Server $($dnsServer) has failed to resolve DNS records."
            Send-MailMessage -From $From -To $To -Subject $Subject -SmtpServer $SMTPServer -Body $Body
        }
        Start-Sleep -Seconds 1
    }
   
    Write-Host ""
}
