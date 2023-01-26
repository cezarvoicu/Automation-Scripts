# Import the Active Directory module
Import-Module ActiveDirectory

# Define the path to the CSV file
$csvFile = "C:\path\to\file.csv"

# Read the CSV file
$users = Import-Csv -Path $csvFile

# Loop through each user in the CSV
foreach ($user in $users) {
    # Check if the user already exists in Active Directory
    $existingUser = Get-ADUser -Filter { SamAccountName -eq $user.User } -ErrorAction SilentlyContinue

    # If the user does not exist, create the user account
    if (!$existingUser) {
        $password = ConvertTo-SecureString -AsPlainText $user.Password -Force
        New-ADUser -SamAccountName $user.User -Name $user.Name -GivenName $user.GivenName -Surname $user.Surname -AccountPassword $password -ChangePasswordAtLogon $True -Enabled $True
    }

    # Get the user's distinguished name
    $userDN = (Get-ADUser -Identity $user.User -Properties DistinguishedName).DistinguishedName

    # Split the groups string into an array
    $groups = $user.Groups -split ","

    # Loop through each group
    foreach ($group in $groups) {
        # Get the group's distinguished name
        $groupDN = (Get-ADGroup -Identity $group).DistinguishedName

        # Add the user to the group
        Add-ADGroupMember -Identity $groupDN -Members $userDN
    }
}
