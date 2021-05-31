$vmixURL = "http://127.0.0.1:8088/api"
$xmlFileName = "${env:VMIX_SCRIPTS}\..\config.xml"
[xml]$xmlDoc = [xml] (Get-Content $xmlFileName)
[xml]$vmixDoc = Invoke-WebRequest $vmixURL

$companionURL = "http://127.0.0.1:9000"
$working = $xmlDoc.config.vmix.GetAttribute("working")
$selectedLayoutTitle = $xmlDoc.config.vmix.GetAttribute("selected_title")
$selectedLayout = $vmixDoc.SelectSingleNode("//inputs/input[@title='${selectedLayoutTitle}']").GetAttribute("number")
$currentState = $xmlDoc.config.vmix.GetAttribute("selected_title_state")

Write-Output $selectedLayout

if ($working -eq "active") {
    if ($currentState -eq "0") {
        # First send to preview
        Invoke-WebRequest "${vmixURL}?Function=PreviewInput&Input=${selectedLayout}"
        # Set Transition Effect 2 as Merge
        Invoke-WebRequest "${vmixURL}?Function=SetTransitionEffect2&Value=Merge"
        # Execute Merge Transition
        Invoke-WebRequest "${vmixURL}?Function=Transition2"
    }
    else {
        # first find the key of the input in the selected layer
        $key = $vmixDoc.SelectSingleNode("//inputs/input[@title='${selectedLayoutTitle}']/overlay[@index='${currentState}']").GetAttribute("key")
        $locateNumberFromKey = $vmixDoc.SelectSingleNode("//inputs/input[@key='${key}']").GetAttribute("number")
        Invoke-WebRequest "${vmixURL}?Function=ActiveInput&Input=${selectedLayout}"
        Invoke-WebRequest "${vmixURL}?Function=PreviewInput&Input=${locateNumberFromKey}"
        # Set Transition Effect 2 as Merge
        Invoke-WebRequest "${vmixURL}?Function=SetTransitionEffect2&Value=Merge"
        # Execute Merge Transition
        Invoke-WebRequest "${vmixURL}?Function=Transition2"
    }

}
else {
    Invoke-WebRequest "${vmixURL}?Function=PreviewInput&Input=${selectedLayout}"
}

Invoke-WebRequest "${companionURL}/style/bank/3/25/?bgcolor=%23000000&text=State%20$($currentState)"