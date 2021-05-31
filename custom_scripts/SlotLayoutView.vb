Dim OverlayLayerForSlots as String = "10"
Dim SlotPrefix as String = "SLOT-"

Dim VmixXML as new system.xml.xmldocument
VmixXML.loadxml(API.XML())

' Get the XMLNode for the Inputs in PREVIEW and PROGRAM elements

Dim PreviewInput as String = VmixXML.selectSingleNode("/vmix/preview").InnerText
Dim ProgramInput as String = VmixXML.selectSingleNode("/vmix/active").InnerText

If PreviewInput = ProgramInput Then
    Exit Sub 'Do not display if Preview is also in ProgramInput
End If

Dim configFile As String = "D:\VmixProjects\config.xml"
Dim fileReader As String = My.Computer.FileSystem.ReadAllText(configFile)

Dim configXML as new system.xml.xmldocument
configXML.loadxml(fileReader)

Dim workingInput as String = configXML.SelectSingleNode("config/vmix/@working").value

IF workingInput = "preview" then
    API.Function("SetMultiviewOverlay", Input:= PreviewInput, Value:= OverlayLayerForSlots + ",None")
    API.Function("MultiViewOverlayOff", Input:= PreviewInput, Value:= OverlayLayerForSlots)
End If

Dim InputTitle as String
If workingInput = "preview" then
    InputTitle = VmixXML.selectSingleNode("/vmix/inputs/input[@number=""" & PreviewInput & """]").Attributes.GetNamedItem("title").Value
else
    InputTitle = VmixXML.selectSingleNode("/vmix/inputs/input[@number=""" & ProgramInput & """]").Attributes.GetNamedItem("title").Value
End if

Dim SlotLayerTitle as String = SlotPrefix & "OVERLAY"
Dim OverlayInput as XMLNode = VmixXML.selectSingleNode("/vmix/inputs/input[@title=""" & SlotLayerTitle & """]")

If OverlayInput Is Nothing Then
    Console.WriteLine("Overlay not found")
    Exit Sub 'Overlay Not Found
End If

Dim OverlayInputNumber as String = OverlayInput.Attributes.GetNamedItem("number").Value

If workingInput = "preview" then
    API.Function("SetMultiviewOverlay", Input:= PreviewInput, Value:= OverlayLayerForSlots + "," + OverlayInputNumber)
    'Turn the LAYER with the Label Overlay ON
    Sleep(200) 'Let the overlay updates complete
    API.Function("MultiViewOverlayOn",Input:= PreviewInput, Value:= OverlayLayerForSlots)
else
    API.Function("OverlayInput4In",Input:=CStr(OverlayInputNumber))
End if