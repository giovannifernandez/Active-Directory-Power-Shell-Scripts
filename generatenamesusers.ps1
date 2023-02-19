# Set the password for new user accounts
$Password = ConvertTo-SecureString "Password1" -AsPlainText -Force

# Define a function to generate a random name
function Get-RandomName {
    $consonants = 'b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','z'
    $vowels = 'a','e','i','o','u','y'
    $nameLength = Get-Random -Minimum 3 -Maximum 7
    $name = ''

    for ($i = 0; $i -lt $nameLength; $i++) {
        $name += $(if ($i % 2 -eq 0) { $consonants } else { $vowels })[Get-Random -Count 1]
    }

    return $name
}

# Loop to create new user accounts
for ($i = 1; $i -le 10000; $i++) {
    $firstName = Get-RandomName
    $lastName = Get-RandomName
    $username = "$firstName.$lastName".ToLower()
    Write-Host "Creating user: $username"
    New-ADUser -Name $username -GivenName $firstName -Surname $lastName `
        -AccountPassword $Password -Enabled $true -PasswordNeverExpires $true `
        -Path "ou=_EMPLOYEES,$((Get-ADDomain).DistinguishedName)"
}
