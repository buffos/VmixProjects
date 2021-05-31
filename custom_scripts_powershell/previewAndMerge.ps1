$vmixURL = "http://127.0.0.1:8088/api"
$xmlFileName = "${env:VMIX_SCRIPTS}\..\config.xml"
[xml]$xmlDoc = [xml] (Get-Content $xmlFileName)
$selectedCamera = $xmlDoc.config.vmix.GetAttribute("selected_camera")

# First send to preview
Invoke-WebRequest "${vmixURL}?Function=PreviewInput&Input=${selectedCamera}" | Out-Null
# Set Transition Effect 2 as Merge
Invoke-WebRequest "${vmixURL}?Function=SetTransitionEffect2&Value=Merge" | Out-Null
# Execute Merge Transition
Invoke-WebRequest "${vmixURL}?Function=Transition2" | Out-Null