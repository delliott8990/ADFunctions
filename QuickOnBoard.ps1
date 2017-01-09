import-module activedirectory
Function loadGUI {
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Move PC to OU"
$objForm.Size = New-Object System.Drawing.Size(300,240) 
$objForm.StartPosition = "CenterScreen"

$OUtb = New-Object System.Windows.Forms.TextBox 
$OUtb.Location = New-Object System.Drawing.Size(195,82) 
$OUtb.Size = New-Object System.Drawing.Size(20,20) 
$OUtb.focus()
$objForm.Controls.Add($OUtb) 

$objTextBox = New-Object System.Windows.Forms.TextBox 
$objTextBox.Location = New-Object System.Drawing.Size(135,110) 
$objTextBox.Size = New-Object System.Drawing.Size(80,20) 
$objForm.Controls.Add($objTextBox) 

$descTb = New-Object System.Windows.Forms.TextBox 
$descTb.Location = New-Object System.Drawing.Size(115,140) 
$descTb.Size = New-Object System.Drawing.Size(100,20) 
$objForm.Controls.Add($descTb) 

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
{
        
    [int]$choice = $OUtb.Text
    $x = $objTextBox.Text
    Switch ($choice)
    {
	    1 
	    {
            $OU = 'OU=Computers,OU=Location,OU=Region,OU=,DC=YourDomain,DC=com'
        
        }
        2
        {
            $OU = 'OU=Computers,OU=Location,OU=Region,OU=,DC=YourDomain,DC=com'
        
        }
        3
        {
            $OU = 'OU=Computers,OU=Location,OU=Region,OU=,DC=YourDomain,DC=com'
        
        }
    
    }
    
    $objForm.Close()}})
    $objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()}})

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(35,175)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click(
{
    [int]$choice = $OUtb.Text
    $x = $objTextBox.Text
    Switch ($choice)
    {
	    1 
	    {
            $OU = 'OU=Computers,OU=Location,OU=Region,OU=,DC=YourDomain,DC=com'
        
        }
        2
        {
            $OU = 'OU=Computers,OU=Location,OU=Region,OU=,DC=YourDomain,DC=com'
        
        }
        3
        {
            $OU = 'OU=Computers,OU=Location,OU=Region,OU=,DC=YourDomain,DC=com'
        
        }
    
    }
    $TARGETOU = Get-ADOrganizationalUnit -Identity $OU
    Get-ADComputer $x | Move-ADObject -TargetPath $TARGETOU.DistinguishedName
    write-host 'Moved to OU'
    $desc=$descTB.Text;
    Set-ADComputer $x -Description $desc
    write-host 'AD Description Updated'
    $objForm.Close() 
})
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(150,175)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm.Close()})

$objForm.Controls.Add($CancelButton)
$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(35,110) 
$objLabel.Size = New-Object System.Drawing.Size(100,20) 
$objLabel.Text = "Computer Name:"
$objForm.Controls.Add($objLabel) 

$objForm.Controls.Add($CancelButton)
$ouLabel = New-Object System.Windows.Forms.Label
$ouLabel.Location = New-Object System.Drawing.Size(35,10) 
$ouLabel.Size = New-Object System.Drawing.Size(145,90) 
$ouLabel.Text = '
-------Choose Location-------
1 = Building One
2 = Building Two
3 = Building Three
---------------------------
Please select office and OU'
$objForm.Controls.Add($ouLabel) 

$deobjLabel = New-Object System.Windows.Forms.Label
$deobjLabel.Location = New-Object System.Drawing.Size(35,140) 
$deobjLabel.Size = New-Object System.Drawing.Size(100,20) 
$deobjLabel.Text = "Description:"
$objForm.Controls.Add($deobjLabel) 

$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()

$objForm.Close()
}

function updateADInfo{
    $TARGETOU = Get-ADOrganizationalUnit -Identity $OU
    Get-ADComputer $x | Move-ADObject -TargetPath $TARGETOU.DistinguishedName
    write-host 'Moved to OU'
    $desc=$descTB.Text;
    Set-ADComputer $x -Description $desc
    write-host 'AD Description Updated'
}

loadGUI
updateADInfo

