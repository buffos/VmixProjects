$attribute_name = $args[0]
$attribute_value = $args[1]
$xmlFileName = "D:\VmixProjects\config.xml"
[xml]$xmlDoc = [xml] (Get-Content $xmlFileName)
#$xmlDoc.DocumentElement.SetAttribute($attribute_name, $attribute_value)
$xmlDoc.config.vmix.SetAttribute($attribute_name, $attribute_value)

$xmlDoc.Save($xmlFileName)