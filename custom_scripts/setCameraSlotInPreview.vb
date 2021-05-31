Dim MultiViewLayerToChange as Integer
Dim InputToSet as Integer

Dim VmixXml as new System.Xml.XmlDocument
VmixXml.loadxml(API.XML())

Dim configFile As String = "D:\VmixProjects\config.xml"
Dim fileReader As String = My.Computer.FileSystem.ReadAllText(configFile)

Dim configXML as new system.xml.xmldocument
configXML.loadxml(fileReader)

Dim workingInput as String = configXML.SelectSingleNode("config/vmix/@working").value

Dim PreviewInput as String = (VmixXml.SelectSingleNode("/vmix/"+ workingInput ).InnerText)
' Read Dynamic Input1
Dim text as String = (VmixXml.SelectSingleNode("//dynamic/input1").InnerText)

if text = ""
   Exit Sub 'Dynamic Input 1 was not set
else
  Int32.TryParse(text, MultiViewLayerToChange)
end if

' Read Dynamic Input2
text = (VmixXml.SelectSingleNode("//dynamic/input2").InnerText)

if text = ""
    Exit Sub 'Dynamic Input 2 was not set
else
  Int32.TryParse(text, InputToSet)
end if

' First LayerSlot is reserved for BackGround Images. So MultiViewLayer is OffSetBy 1
Dim swapString as String = CStr(MultiViewLayerToChange + 1) + "," + CStr(InputToSet)

Api.Function("SetMultiViewOverlay", Value:=swapString, Input:= PreviewInput)