Dim VmixXml as new System.Xml.XmlDocument
VmixXml.loadxml(API.XML())

Dim configFile As String = "D:\VmixProjects\config.xml"
Dim fileReader As String = My.Computer.FileSystem.ReadAllText(configFile)

Dim configXML as new system.xml.xmldocument
configXML.loadxml(fileReader)

Dim workingInput as String = configXML.SelectSingleNode("config/vmix/@working").value

Dim PreviewInput as String = (VmixXml.SelectSingleNode("/vmix/"+ workingInput ).InnerText)
Dim Preview as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@number=""" & PreviewInput & """]")


' Get All the layers in the preview
Dim layerKeys as XMLNodelist = Preview.SelectNodes("./overlay/@key")

For Each layerKey as XMLNode in layerKeys
    'Get the key for the layer
    Dim Key as String = layerKey.innerText
    'Find the corresponding input
    Dim layerInput as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@key=""" & Key & """]")
    Dim layerIndex as String = layerInput.Attributes.GetNamedItem("number").Value
    'We now have the original Camera layer. Now we get all the overlay layers of the layer
    Dim NestedLayersKeys as XMLNodelist = layerInput.SelectNodes(".//overlay/@key")

    ' console.writeline("LAYER: " & layerInput.Attributes.GetNamedItem("title").Value)
   ' console.writeline("SUBLAYERS: " & NestedLayersKeys.Count())

    For Each NestedLayerKey as XMLNode in NestedLayersKeys
        Dim NestedLayerTitle as String = VmixXml.SelectSingleNode("/vmix/inputs/input[@key=""" & NestedLayerKey.InnerText & """]").Attributes.GetNamedItem("title").Value
        ' console.writeline("SUBLAYER: " & NestedLayerTitle)
        ' We now have the original Camera layer. Now we get all the overlay layer[@key=""" & NestedLayerKey & """]").Attributes.GetNamedItem("title").Value
        If NestedLayerTitle.StartsWith("TITLE")
            ' console.writeline("STARTS")
            ' Get the number of the layer in the parent layer
            ' console.writeline("KEY: " & key)
            ' console.writeline("SUBKEY: " & NestedLayerKey.InnerText)
            Dim subLayerIndex as String = layerInput.SelectSingleNode("overlay[@key=""" & NestedLayerKey.InnerText & """]").Attributes.GetNamedItem("index").Value
            API.Function("MultiViewOverlayOn", Value:=CINT(subLayerIndex)+1, Input:= layerIndex)
        End If

    Next
    'console.writeline(layerInput.Attributes.GetNamedItem("title").Value)
    'Dim NestedLayers as XMLNodelist = layerInput.SelectNodes("./overlay/[starts-with(@title,'TITLE')]")
    'console.writeline(NestedLayers.count())
Next