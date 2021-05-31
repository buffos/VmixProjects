$attribute_name = $args[0]
$attribute_value = $args[1]
$xmlFileName = "${env:VMIX_SCRIPTS}\..\config.xml"
[xml]$xmlDoc = [xml] (Get-Content $xmlFileName)
#$xmlDoc.DocumentElement.SetAttribute($attribute_name, $attribute_value)
$xmlDoc.config.vmixAudio.SetAttribute($attribute_name, $attribute_value)

$xmlDoc.Save($xmlFileName)