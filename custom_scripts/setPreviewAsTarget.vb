Dim configFile As String = "D:\VmixProjects\config.xml"
Dim fileReader As String = My.Computer.FileSystem.ReadAllText(configFile)

Dim configXML as new system.xml.xmldocument
configXML.loadxml(fileReader)

Dim workingInput as XMLNode = configXML.SelectSingleNode("config/vmix/@working")

workingInput.value = "preview"

configXML.save(configFile)