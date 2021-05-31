Dim VmixXml as new System.Xml.XmlDocument
VmixXml.loadxml(API.XML())


Dim ProgramInputNumber as String = (VmixXml.SelectSingleNode("/vmix/active").InnerText)
Dim Program as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@number=""" & ProgramInputNumber & """]")


Dim PreviewInputNumber as String = (VmixXml.SelectSingleNode("/vmix/preview").InnerText)
Dim Preview as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@number=""" & PreviewInputNumber & """]")

' Get LayerKeys from Program
Dim layerProgramKeys as XMLNodelist = Program.SelectNodes("./overlay/@key")
' Get LayerKeys from Preview
Dim layerPreviewKeys as XMLNodelist = Preview.SelectNodes("./overlay/@key")

' First Reset All Text on Green Room to  Green Room'
API.Function("SetText", input:=36, SelectedName:="Camera1_TEXT.Text", value:="Green Room")
API.Function("SetText", input:=36, SelectedName:="Camera2_TEXT.Text", value:="Green Room")
API.Function("SetText", input:=36, SelectedName:="Camera3_TEXT.Text", value:="Green Room")
API.Function("SetText", input:=36, SelectedName:="Camera4_TEXT.Text", value:="Green Room")
API.Function("SetText", input:=36, SelectedName:="Caller1_TEXT.Text", value:="Green Room")
API.Function("SetText", input:=36, SelectedName:="Caller2_TEXT.Text", value:="Green Room")
API.Function("SetText", input:=36, SelectedName:="Caller3_TEXT.Text", value:="Green Room")
API.Function("SetText", input:=36, SelectedName:="Caller4_TEXT.Text", value:="Green Room")


For Each layerKey as XMLNode in layerPreviewKeys
    'Get the key for the layer
    Dim Key as String = layerKey.innerText
    'Find the corresponding input
    Dim layerInput as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@key=""" & Key & """]")
    Dim layerTitle as String = layerInput.Attributes.GetNamedItem("title").Value

    If layerTitle = "CAMERA_1" then
        API.Function("SetText", input:=36, SelectedName:="Camera1_TEXT.Text", value:="Get Ready")
        Continue For
    End If
    If layerTitle = "CAMERA_2" then
        API.Function("SetText", input:=36, SelectedName:="Camera2_TEXT.Text", value:="Get Ready")
        Continue For
    End If
    If layerTitle = "CAMERA_3" then
        API.Function("SetText", input:=36, SelectedName:="Camera3_TEXT.Text", value:="Get Ready")
        Continue For
    End If
    If layerTitle = "CALLER_1" then
        API.Function("SetText", input:=36, SelectedName:="Caller1_TEXT.Text", value:="Get Ready")
        API.Function("AudioBusOn", Input:=layerInput, Value:="A")
        API.Function("AudioBusOff", Input:=layerInput, Value:="M")
        Continue For
    End If
    If layerTitle = "CALLER_2" then
        API.Function("SetText", input:=36, SelectedName:="Caller2_TEXT.Text", value:="Get Ready")
        Continue For
    End If
    If layerTitle = "CALLER_3" then
        API.Function("SetText", input:=36, SelectedName:="Caller3_TEXT.Text", value:="Get Ready")
        Continue For
    End If
    If layerTitle = "CALLER_4" then
        API.Function("SetText", input:=36, SelectedName:="Caller4_TEXT.Text", value:="Get Ready")
        Continue For
    End If
Next



For Each layerKey as XMLNode in layerProgramKeys
    'Get the key for the layer
    Dim Key as String = layerKey.innerText
    'Find the corresponding input
    Dim layerInput as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@key=""" & Key & """]")
    Dim layerTitle as String = layerInput.Attributes.GetNamedItem("title").Value

    If layerTitle = "CAMERA_1" then
        API.Function("SetText", input:=36, SelectedName:="Camera1_TEXT.Text", value:="ON AIR")
        Continue For
    End If
    If layerTitle = "CAMERA_2" then
        API.Function("SetText", input:=36, SelectedName:="Camera2_TEXT.Text", value:="ON AIR")
        Continue For
    End If
    If layerTitle = "CAMERA_3" then
        API.Function("SetText", input:=36, SelectedName:="Camera3_TEXT.Text", value:="ON AIR")
        Continue For
    End If
    If layerTitle = "CALLER_1" then
        API.Function("SetText", input:=36, SelectedName:="Caller1_TEXT.Text", value:="ON AIR")
        Continue For
    End If
    If layerTitle = "CALLER_2" then
        API.Function("SetText", input:=36, SelectedName:="Caller2_TEXT.Text", value:="ON AIR")
        Continue For
    End If
    If layerTitle = "CALLER_3" then
        API.Function("SetText", input:=36, SelectedName:="Caller3_TEXT.Text", value:="ON AIR")
        Continue For
    End If
    If layerTitle = "CALLER_4" then
        API.Function("SetText", input:=36, SelectedName:="Caller4_TEXT.Text", value:="ON AIR")
        Continue For
    End If
Next

