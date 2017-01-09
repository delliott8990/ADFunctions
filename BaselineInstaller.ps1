#McAfee
function installMcafee {
    write-host "Installing McAfee EPO Agent" | Out-File $logName -Append
    $Directory = "\\server02\installs\mcafee\epo-agent"
    $FullDir = "$Directory\Setup.exe "
    
    
    try{
    start-process $FullDir -wait -ErrorAction Stop
    }
    catch{
    write-host "EPO Agent installed successfully" | Out-File $logName -Append
    }
}#End McAfee

#Juris
function installMozilla {
    
    $LocalPCRoot = "c:\"

    if($OSValues -match '32-bit'){
    #Add name of file or folder to full path string
    $FILELOCATION = '\\server02\installs\Mozilla\201609X86\setup.EXE'
    $Sharepath = "C:\Program Files\Software"
    $Install = "$LocalPCRoot\setup.EXE"

    }
    Elseif($OSValues -match '64-bit'){
    $FILELOCATION = '\\server02\installs\Mozilla\201609X64\setupX64.EXE'
    $Sharepath = "C:\Program Files(x86)\Software"
    $Install = "$LocalPCRoot\setupX64.EXE"
    }


    #write-host $LocalPCRoot$FILENAME
    copy-item $FILELOCATION -destination $LocalPCRoot -recurse -container
     

    Write-Host "Installing Mozilla" | Out-File $logName -Append

    try
    {
        Start-Process $Install /s -wait -ErrorAction Stop
        write-host "Installation Successful"
        $time = Get-Date
        "$time - Installation Completed" | Out-File $logName -Append
    }
    catch
    {
        $ErrorMessage = $_.Exception.Message
        write-host "Installation Failed"
        $time = Get-Date
        "$time - Installation Failed" | Out-File $logName -Append
        break
    }


    write-host "Firefox installed successfully" | Out-File $logName -Append

    try
    {
        $Acl = Get-ACL $SharePath
        $AccessRule= New-Object System.Security.AccessControl.FileSystemAccessRule("users","modify","ContainerInherit,Objectinherit","none","Allow")
        $Acl.AddAccessRule($AccessRule)
        Set-Acl $SharePath $Acl
        write-host "Folder Permissions Updated Successfully"
        $time = Get-Date
        "$time - Update Folder Permissions Finish" | Out-File $logName -Append
    }
    catch
    {
        $ErrorMessage = $_.Exception.Message
        write-host "Error Updating Folder Permissions"
        $time = Get-Date
        "$time - Error Updating Folder Permissions" | Out-File $logName -Append
        break
    }
    
}#End Juris


#Java
function installJava {
    
    $Directory = "\\server02\installs\Java\Java_Remediation"
    write-host "Installing Java" | Out-File $logName -Append
    
    try{
    start-process $directory\jre1.8.0_91.msi -wait -ErrorAction Stop
    }
    catch{
            
    }
    write-host "Install Complete" | Out-File $logName -Append

    write-host "Confirming C:\Windows\Sun\Java\Deployment has been created"
    $TARGETDIR = 'C:\Windows\Sun\Java\Deployment'
    if(!(Test-Path -Path $TARGETDIR )){
        try{
        New-Item -ItemType directory -Path $TARGETDIR -ErrorAction Stop
        }
        catch{

        }
        write-host "Directory created"
    }
    write-host "C:\windows\Sun\Java\Deployment confirmed" | Out-file $logname -Append

    write-host "Copying configuration files to C:\Windows\Sun\Java\Deployment"
    try{
    copy-item $Directory\deployment.system.config -destination $TARGETDIR -recurse -container -ErrorAction Stop
    write-host "deployment.system.config copied" | Out-file $logname -Append
    }
    catch{
            
    }
    
    try{
    copy-item $Directory\deployment.properties -destination $TARGETDIR -recurse -container -ErrorAction Stop
    write-host "deployment.properties copied" | Out-file $logname -Append
    }
    catch{
            
    } 
    
    try{
    copy-item $Directory\exception.sites -destination $TARGETDIR -recurse -container -ErrorAction Stop
    write-host "exception.sites copied" | Out-file $logname -Append
    }
    catch{
            
    } 
    
    try{
    copy-item $Directory\java.policy -destination $TARGETDIR -recurse -container -ErrorAction Stop
    write-host "java.policy copied" | Out-file $logname -Append
    }
    catch{
            
    } 
    write-host "Java installed and configuration files copied successfully" | Out-file $logname -Append
}#End Java


#Chrome
function installChrome {

    write-host "Installing Google Chrome"
    $Directory = "\\server02\installs\google\googlechrome_v54.0.2840.59"
    
    try{
    start-process $Directory\InstallGoogleChromeEnterprise_54.0.2840.59.cmd /S -wait -ErrorAction Stop
    }
    catch{
            
    } 
    write-host "Chrome installed successfully" | Out-file $logname -Append

}#End Chrome


#CutePDF
function installCutePDF {

    write-host "Installing CutePDF Writer"
    $Directory = "\\server02\installs\cutepdf\cutewriter"
    try{
    start-process $Directory\InstallCutePDF.cmd /S -wait -ErrorAction Stop
    }
    catch{
            
    } 
    
    write-host "CutePDF Writer installed successfully" | Out-file $logname -Append

}#End CutePDF



if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $Script:MyInvocation.MyCommand.Path } 
#### Script start - Get OS version, update log ####
$logTime = Get-Date -Format "yyyy-MM-dd"
$logName = "C:\BaselineInstall.log"
$Stime = Get-Date

#Get OS Architecture Version
write-host "Checking OS Architecture"
$OSValues = (Get-WmiObject -class Win32_OperatingSystem).OSArchitecture
"OS Architecture: $OSValues"  | Out-File $logName -Append

installMcafee

installJuris
    
installJava

installChrome

InstallCutePDF

installIE11

###Functions to Add###
#Web Agent Install

"Script Started: $Stime" | Out-File $logName -Append

$Ftime = Get-Date
"Script Finish: $Ftime" | Out-File $logName -Append
