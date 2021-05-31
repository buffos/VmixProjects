$vmixURL = "http://127.0.0.1:8088/api"
$xmlFileName = "${env:VMIX_SCRIPTS}\..\config.xml"
$comma = "%2C"
[xml]$xmlDoc = [xml] (Get-Content $xmlFileName)
[xml]$vmixDoc = Invoke-WebRequest "http://127.0.0.1:8088/api"

$working = $xmlDoc.config.vmix.GetAttribute("working")
# get the input number on preview or program
$inputNumber = $vmixDoc.SelectSingleNode("/vmix/${working}").InnerText
$slot = [int]$xmlDoc.config.vmix.GetAttribute("selected_slot") + 1
$camera = $xmlDoc.config.vmix.GetAttribute("selected_camera")

$currentSlotInput = $vmixDoc.SelectSingleNode("//inputs/input[@number='${inputNumber}']/overlay[@index='$($slot-1)']")

# Write-Output $currentSlotInput
# Write-Output "$($slot-1)"

if (!($currentSlotInput)) {
    Write-Output "Slot is Empty"
}
else {
    Invoke-WebRequest "${vmixURL}?Function=SetMultiViewOverlay&Value=${slot}, ${camera}&Input=${inputNumber}"
}




