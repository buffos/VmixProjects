Dim configFile As String = "D:\VmixProjects\config.xml"
Dim fileReader As String = My.Computer.FileSystem.ReadAllText(configFile)

Dim configXML as new system.xml.xmldocument
configXML.loadxml(fileReader)

Dim workingInput as XMLNode = configXML.SelectSingleNode("config/vmix/@working")
Dim SelectedTitle as XMLNode = configXML.SelectSingleNode("config/vmix/@selected_title")

Dim VmixXml as new System.Xml.XmlDocument
VmixXml.loadxml(API.XML())


Dim InputFromTitle as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@title=""" & SelectedTitle.innerText & """]")


IF workingInput.innerText = "preview" Then
  API.Function("PreviewInput", Input:= InputFromTitle.innerText)
else
  API.Function("ActiveInput", Input:= InputFromTitle.innerText)
End if