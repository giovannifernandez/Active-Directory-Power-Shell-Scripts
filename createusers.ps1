# Set the password for new user accounts
$Password = ConvertTo-SecureString "Password1" -AsPlainText -Force

# Create the AD organizational unit for the new user accounts
New-ADOrganizationalUnit -Name "_USERS" -ProtectedFromAccidentalDeletion $false

# Loop through each name in the list and create a new user account
Get-Content -Path ".\names.txt" | ForEach-Object {
    $NameParts = $_.Split(' ', 2)
    $Username = "$($NameParts[0].ToLower().Substring(0,1))$($NameParts[1].ToLower())"
    Write-Host "Creating user: $Username"
    New-ADUser -Name $Username -GivenName $NameParts[0] -Surname $NameParts[1] `
        -AccountPassword $Password -Enabled $true -PasswordNeverExpires $true `
        -Path "ou=_USERS,$((Get-ADDomain).DistinguishedName)"
}
