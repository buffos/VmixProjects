[xml]$xmlDoc = Invoke-WebRequest "http://127.0.0.1:8088/api"

# Write-Output $xmlDoc.SelectSingleNode("//inputs/input[@number='1']")

Write-Output $xmlDoc.SelectSingleNode("//inputs/input[@number='1']/@title").Value