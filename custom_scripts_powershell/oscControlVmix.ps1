$xmlFileName = "${env:VMIX_SCRIPTS}\..\config.xml"
[xml]$xmlDoc = [xml] (Get-Content $xmlFileName)

[xml]$vmixDoc = Invoke-WebRequest "http://127.0.0.1:8088/api"

$companionURL = "http://127.0.0.1:9000"

# preview-program button
$working = $xmlDoc.config.vmix.GetAttribute("working")
if ($working -eq "active") {
    Invoke-WebRequest "${companionURL}/style/bank/2/2/?bgcolor=%23669900&text=Program"
    Invoke-WebRequest "${companionURL}/style/bank/2/6/?bgcolor=%23669900&text=Send%20camera%20to%20program"
}
else {
    Invoke-WebRequest "${companionURL}/style/bank/2/2/?bgcolor=%23FF9900&text=Preview"
    Invoke-WebRequest "${companionURL}/style/bank/2/6/?bgcolor=%23FF9900&text=Send%20camera%20to%20preview"
}



# SELECTED SLOTS
$selectedSlot = [int]$xmlDoc.config.vmix.GetAttribute("selected_slot") + 9

Invoke-WebRequest "${companionURL}/style/bank/2/10/?bgcolor=%239900FF"
Invoke-WebRequest "${companionURL}/style/bank/2/11/?bgcolor=%239900FF"
Invoke-WebRequest "${companionURL}/style/bank/2/12/?bgcolor=%239900FF"
Invoke-WebRequest "${companionURL}/style/bank/2/13/?bgcolor=%239900FF"
Invoke-WebRequest "${companionURL}/style/bank/2/14/?bgcolor=%239900FF"
Invoke-WebRequest "${companionURL}/style/bank/2/15/?bgcolor=%239900FF"

if ($selectedSlot -gt 15) {
    Invoke-WebRequest "${companionURL}/style/bank/2/16/?bgcolor=%23FF99CC&text=Slot7%2B%20Current%20$($selectedSlot -9)"
}
else {
    Invoke-WebRequest "${companionURL}/style/bank/2/${selectedSlot}/?bgcolor=%23FF99CC"
    Invoke-WebRequest "${companionURL}/style/bank/2/16/?bgcolor=%239900FF&text=Slot7%2B%20Current%20$($selectedSlot -9)"
}


# SELECTED CAMERAS
$selectedCamera = [int]$xmlDoc.config.vmix.GetAttribute("selected_camera") + 17

Invoke-WebRequest "${companionURL}/style/bank/2/18/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='1']/@title").Value)"
Invoke-WebRequest "${companionURL}/style/bank/2/19/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='2']/@title").Value)"
Invoke-WebRequest "${companionURL}/style/bank/2/20/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='3']/@title").Value)"
Invoke-WebRequest "${companionURL}/style/bank/2/21/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='4']/@title").Value)"
Invoke-WebRequest "${companionURL}/style/bank/2/22/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='5']/@title").Value)"
Invoke-WebRequest "${companionURL}/style/bank/2/23/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='6']/@title").Value)"
Invoke-WebRequest "${companionURL}/style/bank/2/24/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='7']/@title").Value)"
Invoke-WebRequest "${companionURL}/style/bank/2/25/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='8']/@title").Value)"
Invoke-WebRequest "${companionURL}/style/bank/2/26/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='9']/@title").Value)"
Invoke-WebRequest "${companionURL}/style/bank/2/27/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='10']/@title").Value)"
Invoke-WebRequest "${companionURL}/style/bank/2/28/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='11']/@title").Value)"
Invoke-WebRequest "${companionURL}/style/bank/2/29/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='12']/@title").Value)"
Invoke-WebRequest "${companionURL}/style/bank/2/30/?bgcolor=%23339933F&text=$($vmixDoc.SelectSingleNode("//inputs/input[@number='13']/@title").Value)"

if ($selectedCamera -gt 30) {
    Invoke-WebRequest "${companionURL}/style/bank/2/31/?bgcolor=%23006600&text=Camera%2014%2B%20Current%20$($vmixDoc.SelectSingleNode("//inputs/input[@number=$($selectedCamera - 17)]/@title").Value)"
}
else {
    Invoke-WebRequest "${companionURL}/style/bank/2/${selectedCamera}/?bgcolor=%23006600"
    Invoke-WebRequest "${companionURL}/style/bank/2/31/?bgcolor=%23000000&text=Camera%2014%2B%20Current%20$($selectedCamera - 17)"
}