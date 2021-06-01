# $xmlFileName = (get-item $env:VMIX_SCRIPTS).parent.FullName + "/config.xml"
$xmlFileName = "${env:VMIX_SCRIPTS}\..\config.xml"
$vmixURL = "http://127.0.0.1:8088/api"

[xml]$xmlDoc = [xml] (Get-Content $xmlFileName)
[xml]$vmixDoc = Invoke-WebRequest $vmixURL

$companionURL = "http://127.0.0.1:9000"
$colorMuted = "%23FF0000"
$colorSolo = "%23009900"
$colorDefault = "%23000000"
$colorSelected = "%230000CC"
$selectedAudioButton = $xmlDoc.config.vmixAudio.GetAttribute("selected")

# Get all Audio inputs
$audioInputs = $vmixDoc.SelectNodes("//inputs/input[starts-with(@title,'AUDIO')]")

# remove old audio tags
$xmlDoc.selectNodes("//vmixAudio/audio") | ForEach-Object { $_.ParentNode.RemoveChild($_) } | Out-Null
# create new audio tags
$audioInputs.ForEach( {
        $audio = $xmlDoc.CreateElement('audio')
        $audio.SetAttribute('title', $_.title)
        $audio.SetAttribute('number', $_.number)
        $audio.SetAttribute('key', $_.key)
        $audio.SetAttribute('muted', $_.muted)
        $audio.SetAttribute('solo', $_.solo)
        $audio.SetAttribute('audiobusses', $_.audiobusses)
        $xmlDoc.config.GetElementsByTagName('vmixAudio').AppendChild($audio) | Out-Null
    })
$xmlDoc.Save($xmlFileName)

$startingBank = 2
for ($i = 0; $i -lt $audioInputs.Count; $i++ ) {
    Invoke-WebRequest "${companionURL}/style/bank/4/$($startingBank + $i)/?text=$($audioInputs[$i].title.TrimStart('AUDIO_')+'\n' + $audioInputs[$i].audiobusses)" | Out-Null

    if ($selectedAudioButton -eq $i) {
        Invoke-WebRequest "${companionURL}/style/bank/4/$($startingBank + $i)/?bgcolor=${colorSelected}" | Out-Null
    }
    elseif ($audioInputs[$i].solo -eq 'True' ) {
        Invoke-WebRequest "${companionURL}/style/bank/4/$($startingBank + $i)/?bgcolor=${colorSolo}" | Out-Null
    }
    elseif ($audioInputs[$i].muted -eq 'True') {
        Invoke-WebRequest "${companionURL}/style/bank/4/$($startingBank + $i)/?bgcolor=${colorMuted}" | Out-Null
    }
    else {
        Invoke-WebRequest "${companionURL}/style/bank/4/$($startingBank + $i)/?bgcolor=${colorDefault}" | Out-Null
    }
}

# for the selected slot show M, A, B, C,  S, Follow buttons
# MASTER BUTTON
$masterColor = $audioInputs[$selectedAudioButton].audiobusses -like '*M*' ? ${colorSolo} : ${colorDefault}
Invoke-WebRequest "${companionURL}/style/bank/4/10/?text=Master&bgcolor=${masterColor}" | Out-Null
# BusA BUTTON
$masterColor = $audioInputs[$selectedAudioButton].audiobusses -like '*A*' ? ${colorSolo} : ${colorDefault}
Invoke-WebRequest "${companionURL}/style/bank/4/11/?text=BusA&bgcolor=${masterColor}" | Out-Null
# BusB BUTTON
$masterColor = $audioInputs[$selectedAudioButton].audiobusses -like '*B*' ? ${colorSolo} : ${colorDefault}
Invoke-WebRequest "${companionURL}/style/bank/4/12/?text=BusB&bgcolor=${masterColor}" | Out-Null
# BusC BUTTON
$masterColor = $audioInputs[$selectedAudioButton].audiobusses -like '*C*' ? ${colorSolo} : ${colorDefault}
Invoke-WebRequest "${companionURL}/style/bank/4/13/?text=BusC&bgcolor=${masterColor}" | Out-Null
# Solo BUTTON
$masterColor = $audioInputs[$selectedAudioButton].solo -eq 'True'  ? ${colorSolo} : ${colorDefault}
Invoke-WebRequest "${companionURL}/style/bank/4/14/?text=Solo&bgcolor=${masterColor}" | Out-Null
# Mute BUTTON
$masterColor = $audioInputs[$selectedAudioButton].muted -eq 'True'  ? ${colorSolo} : ${colorDefault}
Invoke-WebRequest "${companionURL}/style/bank/4/15/?text=Muted&bgcolor=${masterColor}" | Out-Null


# # SELECTED SLOTS
# $selectedSlot = [int]$xmlDoc.config.vmix.GetAttribute("selected_slot") + 9

# Invoke-WebRequest "${companionURL}/style/bank/2/10/?bgcolor=%239900FF" | Out-Null
# Invoke-WebRequest "${companionURL}/style/bank/2/11/?bgcolor=%239900FF" | Out-Null
# Invoke-WebRequest "${companionURL}/style/bank/2/12/?bgcolor=%239900FF" | Out-Null
# Invoke-WebRequest "${companionURL}/style/bank/2/13/?bgcolor=%239900FF" | Out-Null
# Invoke-WebRequest "${companionURL}/style/bank/2/14/?bgcolor=%239900FF" | Out-Null
# Invoke-WebRequest "${companionURL}/style/bank/2/15/?bgcolor=%239900FF" | Out-Null

# if ($selectedSlot -gt 15) {
#     Invoke-WebRequest "${companionURL}/style/bank/2/16/?bgcolor=%23FF99CC&text=Slot7%2B%20Current%20$($selectedSlot -9)" | Out-Null
# }
# else {
#     Invoke-WebRequest "${companionURL}/style/bank/2/${selectedSlot}/?bgcolor=%23FF99CC" | Out-Null
#     Invoke-WebRequest "${companionURL}/style/bank/2/16/?bgcolor=%239900FF&text=Slot7%2B%20Current%20$($selectedSlot -9)" | Out-Null
# }


