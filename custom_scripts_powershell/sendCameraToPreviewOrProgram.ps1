$vmixURL = "http://127.0.0.1:8088/api"
$xmlFileName = "D:\VmixProjects\config.xml"
[xml]$xmlDoc = [xml] (Get-Content $xmlFileName)


$working = $xmlDoc.config.vmix.GetAttribute("working")
$selectedCamera = $xmlDoc.config.vmix.GetAttribute("selected_camera")

if ($working -eq "active") {
    Invoke-WebRequest "${vmixURL}?Function=ActiveInput&Input=${selectedCamera}"
}
else {
    Invoke-WebRequest "${vmixURL}?Function=PreviewInput&Input=${selectedCamera}"
}