$vmixURL = "http://127.0.0.1:8088/api"
$xmlFileName = "${env:VMIX_SCRIPTS}\..\config.xml"
[xml]$xmlDoc = [xml] (Get-Content $xmlFileName)
[xml]$vmixDoc = Invoke-WebRequest "http://127.0.0.1:8088/api"


$programInputNumber = $vmixDoc.SelectSingleNode("/vmix/active").InnerText
$programInput = $vmixDoc.SelectSingleNode("/vmix/inputs/input[@number='${programInputNumber}']")

$previewInputNumber = $vmixDoc.SelectSingleNode("/vmix/preview").InnerText
$previewInput = $vmixDoc.SelectSingleNode("/vmix/inputs/input[@number='${previewInputNumber}']")

$greenRoomNumber = $vmixDoc.SelectSingleNode("/vmix/inputs/input[@title='GREEN_ROOM']").GetAttribute("number")

$myCameraInputs = @("CAMERA_1", "CAMERA_2", "CAMERA_3", "CALLER_1", "CALLER_2", "CALLER_3", "CALLER_4")

foreach ($searchTitle in $myCameraInputs) {
    $layerKey = $vmixDoc.SelectSingleNode("/vmix/inputs/input[@title='${searchTitle}']").GetAttribute("key")
    $isInPreviewLayout = $null -ne $previewInput.SelectSingleNode("./overlay[@key='${layerKey}']")
    $isInPreview = $previewInput.GetAttribute("key") -eq $layerKey
    $isInProgramLayout = $null -ne $programInput.SelectSingleNode("./overlay[@key='${layerKey}']")
    $isInProgram = $programInput.GetAttribute("key") -eq $layerKey
    if ($isInProgram -or $isInProgramLayout) {
        Invoke-WebRequest "${vmixURL}?Function=SetText&Input=${greenRoomNumber}&Value=On Air&SelectedName=${searchTitle}_TEXT.Text"  | Out-Null
    }
    elseif ($isInPreview -or $isInPreviewLayout) {
        Invoke-WebRequest "${vmixURL}?Function=SetText&Input=${greenRoomNumber}&Value=Get Ready&SelectedName=${searchTitle}_TEXT.Text"  | Out-Null
    }
    else {
        Invoke-WebRequest "${vmixURL}?Function=SetText&Input=${greenRoomNumber}&Value=Green Room&SelectedName=${searchTitle}_TEXT.Text"  | Out-Null
    }
}

$myAudioInputs = @("CAMERA_2", "CAMERA_3", "CALLER_1", "CALLER_2", "CALLER_3", "CALLER_4")

foreach ($searchTitle in $myAudioInputs) {
    $layerInput = $vmixDoc.SelectSingleNode("/vmix/inputs/input[@title='${searchTitle}']")
    $layerKey = $layerInput.GetAttribute("key")
    $layerInputNumber = $layerInput.GetAttribute("number")
    $isInPreviewLayout = $null -ne $previewInput.SelectSingleNode("./overlay[@key='${layerKey}']")
    $isInPreview = $previewInput.GetAttribute("key") -eq $layerKey
    $isInProgramLayout = $null -ne $programInput.SelectSingleNode("./overlay[@key='${layerKey}']")
    $isInProgram = $programInput.GetAttribute("key") -eq $layerKey
    if ($isInProgram -or $isInProgramLayout) {
        Invoke-WebRequest "${vmixURL}?Function=AudioBusOff&Input=${layerInputNumber}&Value=A"  | Out-Null
        Invoke-WebRequest "${vmixURL}?Function=AudioBusOn&Input=${layerInputNumber}&Value=M"  | Out-Null
    }
    else {
        Invoke-WebRequest "${vmixURL}?Function=AudioBusOff&Input=${layerInputNumber}&Value=M"  | Out-Null
        Invoke-WebRequest "${vmixURL}?Function=AudioBusOn&Input=${layerInputNumber}&Value=A"  | Out-Null
    }
}