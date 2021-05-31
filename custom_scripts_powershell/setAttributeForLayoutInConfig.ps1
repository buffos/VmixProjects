$attribute_name = "selected_title"
$attribute_value = $args[0]
$xmlFileName = "${env:VMIX_SCRIPTS}\..\config.xml"
[xml]$xmlDoc = [xml] (Get-Content $xmlFileName)

$previous_layout = $xmlDoc.config.vmix.GetAttribute($attribute_name)
$min_state = $xmlDoc.config.vmix.GetAttribute("selected_title_min")
$max_state = $xmlDoc.config.vmix.GetAttribute("selected_title_max")
$current_state = [int]$xmlDoc.config.vmix.GetAttribute("selected_title_state")

if ($attribute_value -ne $previous_layout) {
    $xmlDoc.config.vmix.SetAttribute("selected_title_state", "0")
    $xmlDoc.config.vmix.SetAttribute($attribute_name, $attribute_value)
}
elseif ($current_state -eq 0) {
    $xmlDoc.config.vmix.SetAttribute("selected_title_state", $min_state)
}
elseif ($current_state -lt [int]$max_state) {
    $xmlDoc.config.vmix.SetAttribute("selected_title_state", "$($current_state + 1)")
}
else {
    $xmlDoc.config.vmix.SetAttribute("selected_title_state", "0")
}


$xmlDoc.Save($xmlFileName)