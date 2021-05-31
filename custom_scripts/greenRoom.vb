Dim VmixXml as new System.Xml.XmlDocument
VmixXml.loadxml(API.XML())


Dim ProgramInputNumber as String = (VmixXml.SelectSingleNode("/vmix/active").InnerText)
Dim Program as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@number=""" & ProgramInputNumber & """]")


Dim PreviewInputNumber as String = (VmixXml.SelectSingleNode("/vmix/preview").InnerText)
Dim Preview as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@number=""" & PreviewInputNumber & """]")


Dim LayerInput as XMLNode
Dim LayerKey as String
Dim IsInPreview as Boolean
Dim IsInProgram as Boolean
Dim LayerInputNumber as String


Dim myCameraInputs as String() = new String() {"CAMERA_1", "CAMERA_2", "CAMERA_3", "CALLER_1", "CALLER_2", "CALLER_3", "CALLER_4"}
For Each searchTitle as String in myCameraInputs
    LayerInput = VmixXml.SelectSingleNode("/vmix/inputs/input[@title=""" & searchTitle & """]")
    LayerKey = LayerInput.Attributes.GetNamedItem("key").Value
    IsInPreview = (Preview.SelectSingleNode("./overlay[@key=""" & LayerKey & """]") isNot Nothing)
    IsInProgram = (Program.SelectSingleNode("./overlay[@key=""" & LayerKey & """]") isNot Nothing)
    IF IsInProgram Then
        API.Function("SetText", input:=36, SelectedName:= searchTitle + "_TEXT.Text", value:="OnAir")
    Else If IsInPreview then
        API.Function("SetText", input:=36, SelectedName:= searchTitle + "_TEXT.Text", value:="Get Ready")
    Else
        API.Function("SetText", input:=36, SelectedName:= searchTitle + "_TEXT.Text", value:="Green Room")
    End if
Next

Dim myAudioInputs as String() = new String() {"CAMERA_2", "CAMERA_3", "CALLER_1", "CALLER_2", "CALLER_3", "CALLER_4"}
For Each searchTitle as String in myAudioInputs
    LayerInput = VmixXml.SelectSingleNode("/vmix/inputs/input[@title=""" & searchTitle & """]")
    LayerKey = LayerInput.Attributes.GetNamedItem("key").Value
    LayerInputNumber = LayerInput.Attributes.GetNamedItem("number").Value
    IsInPreview = (Preview.SelectSingleNode("./overlay[@key=""" & LayerKey & """]") isNot Nothing)
    IsInProgram = (Program.SelectSingleNode("./overlay[@key=""" & LayerKey & """]") isNot Nothing)
    IF IsInProgram Then
        API.Function("AudioBusOff", Input:= LayerInputNumber, Value:="A")
        API.Function("AudioBusOn", Input:= LayerInputNumber, Value:="M")
    Else
        API.Function("AudioBusOn", Input:= LayerInputNumber, Value:="A")
        API.Function("AudioBusOff", Input:= LayerInputNumber, Value:="M")
    End if
Next

' For Each layerKey as XMLNode in layerPreviewKeys
'     'Get the key for the layer
'     Dim Key as String = layerKey.innerText
'     'Find the corresponding input
'     Dim layerInput as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@key=""" & Key & """]")
'     Dim layerTitle as String = layerInput.Attributes.GetNamedItem("title").Value

'     If layerTitle = "CAMERA_1" then
'         API.Function("SetText", input:=36, SelectedName:="Camera1_TEXT.Text", value:="Get Ready")
'         Continue For
'     End If
'     If layerTitle = "CAMERA_2" then
'         API.Function("SetText", input:=36, SelectedName:="Camera2_TEXT.Text", value:="Get Ready")
'         Continue For
'     End If
'     If layerTitle = "CAMERA_3" then
'         API.Function("SetText", input:=36, SelectedName:="Camera3_TEXT.Text", value:="Get Ready")
'         Continue For
'     End If
'     If layerTitle = "CALLER_1" then
'         API.Function("SetText", input:=36, SelectedName:="Caller1_TEXT.Text", value:="Get Ready")
'         'API.Function("AudioBusOn", Input:=layerInput, Value:="A")
'         'API.Function("AudioBusOff", Input:=layerInput, Value:="M")
'         Continue For
'     End If
'     If layerTitle = "CALLER_2" then
'         API.Function("SetText", input:=36, SelectedName:="Caller2_TEXT.Text", value:="Get Ready")
'         Continue For
'     End If
'     If layerTitle = "CALLER_3" then
'         API.Function("SetText", input:=36, SelectedName:="Caller3_TEXT.Text", value:="Get Ready")
'         Continue For
'     End If
'     If layerTitle = "CALLER_4" then
'         API.Function("SetText", input:=36, SelectedName:="Caller4_TEXT.Text", value:="Get Ready")
'         Continue For
'     End If
' Next



' For Each layerKey as XMLNode in layerProgramKeys
'     'Get the key for the layer
'     Dim Key as String = layerKey.innerText
'     'Find the corresponding input
'     Dim layerInput as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@key=""" & Key & """]")
'     Dim layerTitle as String = layerInput.Attributes.GetNamedItem("title").Value

'     If layerTitle = "CAMERA_1" then
'         API.Function("SetText", input:=36, SelectedName:="Camera1_TEXT.Text", value:="ON AIR")
'         Continue For
'     End If
'     If layerTitle = "CAMERA_2" then
'         API.Function("SetText", input:=36, SelectedName:="Camera2_TEXT.Text", value:="ON AIR")
'         Continue For
'     End If
'     If layerTitle = "CAMERA_3" then
'         API.Function("SetText", input:=36, SelectedName:="Camera3_TEXT.Text", value:="ON AIR")
'         Continue For
'     End If
'     If layerTitle = "CALLER_1" then
'         API.Function("SetText", input:=36, SelectedName:="Caller1_TEXT.Text", value:="ON AIR")
'         Continue For
'     End If
'     If layerTitle = "CALLER_2" then
'         API.Function("SetText", input:=36, SelectedName:="Caller2_TEXT.Text", value:="ON AIR")
'         Continue For
'     End If
'     If layerTitle = "CALLER_3" then
'         API.Function("SetText", input:=36, SelectedName:="Caller3_TEXT.Text", value:="ON AIR")
'         Continue For
'     End If
'     If layerTitle = "CALLER_4" then
'         API.Function("SetText", input:=36, SelectedName:="Caller4_TEXT.Text", value:="ON AIR")
'         Continue For
'     End If
' Next

