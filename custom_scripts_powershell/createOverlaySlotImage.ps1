# $attribute_name = $args[0]
# $attribute_value = $args[1]
# start /d "D:\VmixProjects\createOverlays_golang\" createOverlays.exe active test.vmix 3
$xmlFileName = "${env:VMIX_SCRIPTS}\..\config.xml"
$workingDir = "${env:VMIX_SCRIPTS}\..\createOverlays_golang\"
$overlayProgram = "createOverlays.exe"

[xml]$xmlDoc = [xml] (Get-Content $xmlFileName)

$target = $xmlDoc.config.vmix.GetAttribute("working")

$presetFile = "test.vmix"

Start-Process -WindowStyle Minimized -FilePath $overlayProgram  -WorkingDirectory $workingDir  -ArgumentList $target, $presetFile, 10