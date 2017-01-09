$date = Get-Date -Format "yyyy-MM-dd"
$user = Read-Host "Username:"
#$pc = Read-Host "PC Name:"
$userLpath = "C:\users\$user\"
$picPath = "C:\users\$user\Pictures"
$userSpath = "\\server01\Home\$user\LocalPC-$date"
$sourceList = ("$userLPath\Desktop","$userLPath\Downloads","$userLPath\Favorites","$userLPath\Documents")


#New-Item -ItemType directory -Path $userSpath

$userSpath = "\\server01\Home\$user\LocalPC-$date"
    if(!(Test-Path -Path $userSpath )){
        try{
        New-Item -ItemType directory -Path $userSpath -ErrorAction Stop
        }
        catch{

        }
        write-host "Directory created"
    }
$pics = "$userSpath\Pictures"
New-Item -ItemType directory -Path $pics


try{
write-host "Copying files from Desktop, Downloads, Documents, and Favorites"
copy-item $sourceList -destination $userSpath -recurse -container -ErrorAction Stop



}
catch{
$ErrorMessage = $_.Exception.Message

}

write-host "Transfer completed successfully"

try{
    write-host "Copying pictures"
    get-childitem -path $picPath -recurse | copy-item -destination $pics -recurse -container -erroraction stop
}
catch{
    $ErrorMessage = $_.Exception.Message
}