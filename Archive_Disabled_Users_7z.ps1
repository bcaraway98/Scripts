# Install NuGet package provider to allow import of "7Zip4Powershell" module
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# Install RSAT - Active Directory Powershell Module
Install-WindowsFeature RSAT-AD-Powershell

# Used to run AD Query
Import-Module ActiveDirectory

# Used to compress user folder
Install-Module -Name 7Zip4Powershell -Verbose -Force

# Query Active Directory for Disabled users, with staff email, output SAMaccountname
$File = Get-ADUser -Filter * -Property Enabled,LastLogonDate,mail | Where-Object {$_.Enabled -like "False"} | Where-Object {$_.mail -like "*@atlisd.net"} | Select-Object SamAccountName

# Current Home Directory Root
$Path = "\\data.server\Staff_data\"

# Path to archive to
$apath = "\\archive.server\Staff\"

# Set 7zip executable variable
$7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"

# Set filetype for archive directory query
$filetype=".7z"

# Set file path for transcript log
$Transcript = "C:\Your_Path"

###################
#                 #
# Variables Above #
#                 #
###################
#                 #
#  Script Below   #
#                 #
###################

# Start Transcript for logging
Start-Transcript -Path $Transcript -Append

foreach ($item in $File)
    {
        $name=$item.SamAccountName
        
        $directory=$Path+"$name"
        
        $newdir=$apath+"$name"

        $archived=$newdir+"$filetype"
        
        if(Test-Path $archived)
        
            {
        
        Write-Host "User $name has already been archived"
        
            } 
        
        elseif(Test-Path $directory) 
            
            {
         
         Write-Host "Archiving $name"
        
        Compress-7Zip -ArchiveFileName "$name.7z" -Path $directory -OutputPath $apath -Format SevenZip 
        
        Remove-Item $directory -Force -Recurse
        
        Write-Host "User $name has been archived"
            
            }
        
        Else 
            
            {

            Write-Host "There is no data to archive for user $name"

            }
    }
Stop-Transcript