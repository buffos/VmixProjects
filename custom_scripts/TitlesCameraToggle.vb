Dim VmixXml as new System.Xml.XmlDocument
VmixXml.loadxml(API.XML())

Dim PreviewInput as String = (VmixXml.SelectSingleNode("/vmix/preview").InnerText)
Dim Preview as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@number=""" & PreviewInput & """]")


' Get All the layer keys  in the preview
Dim layerKeys as XMLNodelist = Preview.SelectNodes("./overlay/@key")

For Each layerKey as XMLNode in layerKeys
    'Get the key for the layer
    Dim Key as String = layerKey.innerText
    'Find the corresponding input (in order to extract the sublayers)
    ' First find the input based on the key
    Dim layerInput as XMLNode = VmixXml.SelectSingleNode("/vmix/inputs/input[@key=""" & Key & """]")
    ' Also store the number of the input, since we will reference it when we turn off the title layer
    Dim layerIndex as String = layerInput.Attributes.GetNamedItem("number").Value
    'We now have the original Camera layer. Now we get all the overlay layers of the layer
    Dim NestedLayersKeys as XMLNodelist = layerInput.SelectNodes(".//overlay/@key")

    'console.writeline("LAYER: " & layerInput.Attributes.GetNamedItem("title").Value)
    'console.writeline("SUBLAYERS: " & NestedLayersKeys.Count())

    For Each NestedLayerKey as XMLNode in NestedLayersKeys
        ' Go and get the nested layer title/
        Dim NestedLayerTitle as String = VmixXml.SelectSingleNode("/vmix/inputs/input[@key=""" & NestedLayerKey.InnerText & """]").Attributes.GetNamedItem("title").Value
        ' console.writeline("SUBLAYER: " & NestedLayerTitle)
        ' if the layer title starts with TITLE, then we need to turn it off
        If NestedLayerTitle.StartsWith("TITLE")
            ' Get the index of the layer in the multilayer
            Dim subLayerIndex as String = layerInput.SelectSingleNode("overlay[@key=""" & NestedLayerKey.InnerText & """]").Attributes.GetNamedItem("index").Value
            ' toggle the state
            API.Function("MultiViewOverlay", Value:=CINT(subLayerIndex)+1, Input:= layerIndex)
        End If

    Next
Next