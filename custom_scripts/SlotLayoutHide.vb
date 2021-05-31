Dim OverlayLayerForSlots as String = "10"

Dim VmixXML as new system.xml.xmldocument
VmixXML.loadxml(API.XML())

Dim PreviewInput as String = VmixXML.selectSingleNode("/vmix/preview").InnerText
Dim ProgramInput as String = VmixXML.selectSingleNode("/vmix/active").InnerText

'Get which Input to act on
Dim configFile As String = "D:\VmixProjects\config.xml"
Dim fileReader As String = My.Computer.FileSystem.ReadAllText(configFile)

Dim configXML as new system.xml.xmldocument
configXML.loadxml(fileReader)

Dim workingInput as String = configXML.SelectSingleNode("config/vmix/@working").value

If workingInput = "preview" then
    API.Function("SetMultiviewOverlay", Input:= PreviewInput, Value:= OverlayLayerForSlots + ",None")
    API.Function("MultiViewOverlayOff", Input:= PreviewInput, Value:= OverlayLayerForSlots)
else
    API.Function("OverlayInput4Off")
End If