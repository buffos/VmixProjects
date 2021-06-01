$parameter = $args[0]

$buses = @('M', 'A', 'B', 'C')

$xmlFileName = "${env:VMIX_SCRIPTS}\..\config.xml"
$vmixURL = "http://127.0.0.1:8088/api"

[xml]$xmlDoc = [xml] (Get-Content $xmlFileName)
[xml]$vmixDoc = Invoke-WebRequest $vmixURL

$selectedAudioButton = $xmlDoc.config.vmixAudio.GetAttribute("selected")
# Get all Audio inputs
$audioInputs = $vmixDoc.SelectNodes("//inputs/input[starts-with(@title,'AUDIO')]")
$audioInputNumber = $audioInputs[$selectedAudioButton].number

if ($buses.contains($parameter)) {
    Invoke-WebRequest "${vmixURL}?Function=AudioBus&Input=${audioInputNumber}&Value=${parameter}"  | Out-Null
}
elseif ($parameter -eq 'SOLO') {
    Invoke-WebRequest "${vmixURL}?Function=Solo&Input=${audioInputNumber}"  | Out-Null
}
elseif ($parameter -eq 'MUTE') {
    Invoke-WebRequest "${vmixURL}?Function=Audio&Input=${audioInputNumber}"  | Out-Null
}