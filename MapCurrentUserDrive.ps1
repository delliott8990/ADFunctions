import-module ActiveDirectory
$Username = [Environment]::UserName
$FullPath = "\\Server\UsersDir\UserDrive" + $Username
net use J: $FullPath /Persistent:Yes