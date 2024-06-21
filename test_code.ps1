##########################
# Taking inputs
Param(
    [Parameter(Position = 0)][string]$e,  # Base URL
    [Parameter(Position = 1)][string]$w,  # Workspace Id
    [Parameter(Position = 2)][string]$t,  # Token
    [Parameter(Position = 3)][string]$r   # Rule Id
   # [Parameter(Position = 4)][string]$f  # Check for extra input arguments ??
)

##########################
# Setting up static variables & functions
$date = Get-Date

# Debugging: Define static parameter values
$e = "https://app.icedq.net/api/v1"  # Base URL
$w = "wksc-fde1f71a-6119-53c4-8636-9effcf33dddf"       # Workspace Id
$t = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI5cjVWOVdsaU5jTE12NVFvR1dWSlhUWGpqREgwMXlxUHpKblpxZ2h5WHpnIn0.eyJleHAiOjE3MTg5ODM3MjYsImlhdCI6MTcxODk3NjUyNiwianRpIjoiYTZhZGJkNGUtYmI5Ni00Zjk3LTk4OTgtYzc4YzZhNDhmM2JiIiwiaXNzIjoiaHR0cHM6Ly9hcHAuaWNlZHEubmV0L2F1dGgvcmVhbG1zL2lhbS5pY2VkcSIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiJkODdjOTY3OC1iODRkLTRjZDUtYTBiOS00ZmZjOTY1ZWEwOWQiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJpY2VkcS5hZG1pbi11aSIsInNlc3Npb25fc3RhdGUiOiJhZjViYzg2OS01ZjM2LTQ1YjYtYTE1YS0yMGM3MzJiMzg0MGEiLCJhbGxvd2VkLW9yaWdpbnMiOlsiaHR0cHM6Ly9hcHAuaWNlZHEubmV0Il0sInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJ3a3NjLWNkNWMzYjY4LWU2OWEtNWM5Mi1iNTdiLWFlNTU3NDBmYjNjNy5FeGVjdXRvciIsIndrc2MtZTAwZWYxZGEtYjY3Mi01ZGQ2LTg4ODQtNzllNTY4ZDU5YmJlLk93bmVyIiwid2tzYy0wYWNjNGZlYS03Mzg4LTUwMDQtODE4Ni0wNjE4ZGEwMzhjNmMuRXhlY3V0b3IiLCJ3a3NjLTU4YzJlNWJiLTU3OWMtNThkMC05NWIyLTA0YzljOTM4YTZlYi5Pd25lciIsIndrc2MtMjUxOTRmZGUtMDdiMC01YWE4LWExZjAtY2Q1OTI1ODA4ZGZlLk93bmVyIiwid2tzYy0yYzU1YmIwZS03YWZkLTU2MzYtYTU0Zi00NTRmNWEzYWM0NWEuQ29udHJpYnV0b3IiLCJkZWZhdWx0LXJvbGVzLWlhbS5pY2VkcSIsIndrc2MtOTcwMDhjMTktYjViNi01MjIwLWI3M2QtN2JjOWM5MjE5NGM5Lk93bmVyIiwib2ZmbGluZV9hY2Nlc3MiLCJ1bWFfYXV0aG9yaXphdGlvbiIsIndrc2MtMjEzNjVmY2UtNGM5Yi01N2M1LWE4OWYtN2QxMDIyMzNmMzFkLk93bmVyIiwid2tzYy1hY2E0NDMyZi04MGFhLTUyMzgtODQ0ZS05NmQ1NDliNzIyY2QuT3duZXIiLCJ3a3NjLWZkZTFmNzFhLTYxMTktNTNjNC04NjM2LTllZmZjZjMzZGRkZi5Pd25lciJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInNpZCI6ImFmNWJjODY5LTVmMzYtNDViNi1hMTVhLTIwYzczMmIzODQwYSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwibmFtZSI6IkFudWogQ2hhd2RhIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiYW51ai5jIiwiZ2l2ZW5fbmFtZSI6IkFudWoiLCJmYW1pbHlfbmFtZSI6IkNoYXdkYSIsImVtYWlsIjoiYW51ai5jQHRvcmFuYWluYy5jb20ifQ.eX8-LiogD_huXNsCf9Z1ou4VKdLcCDymSv9ahSApb3AwIoe4w0dzo-HPNZg0H7wpUhTZzhOnXo4BmjochBRn0oGPiN5vQXgn-_pqKa6pfmZxsANCsCCT8R_OVd925-WnyTqWnHXhQKRukOPtmQ2_6dd52W0OBnovC7dXT1oesNW50fsL1N9knCsK92skL1W_bTHUpKt0bPEegGZGMkLzyuD9i0JmmBY5frYrzx7JhWtyYvH4o4pSNBrSPzIGaaOVA3Wxbr3Ua6LxjASPiBaopPNRrB4BoC60VXbFxmf35kjXV4MuPLFfIsDLMHaYYfgI20kq0EI9v-P_Ce2Yc7Dmiw"
$r = "rule-35a6cd0b-76b3-5dbf-b112-a05b52c9b95d"            # Rule Id

##########################
# Trigger rule run API
$base_url = [string]$e
$ruleTriggerUrl = "$base_url/workflow:trigger"
$workspaceId = [string]$w
$sleep = 5
$payload = @{
    objectId = $r
} | ConvertTo-Json

$headers_rule = @{
    'Content-Type'  = 'application/json'
    'Accept'        = 'application/json'
    'Workspace-Id'  = $workspaceId
    'Authorization' = "Bearer $t"
}

$response = try { Invoke-RestMethod -Uri $ruleTriggerUrl -Method Post -Body $payload -Headers $headers_rule } catch { Write-Error "Failed to trigger the workflow: $_" }
$instanceId = $response.instanceId

##########################
# Verifying if the regression run API is triggered

Write-Host "$date INFO: ---The Rule is triggered---"
Write-Host "$date INFO: Instance Id: $instanceId"

##########################
# Looping the status API until the Rule Status is other than running
Start-Sleep -Seconds 1
$headers_result = @{
    'Accept' = 'application/json'
    'Authorization' = "Bearer $t"
    'Content-Type' = 'application/json'
    'Workspace-Id' = $workspaceId
    'Cookie' = 'JSESSIONID=1FD5BB9FCA872C103046C11D50193A69'
}
$resultUrl = "$base_url/workflowruns/$instanceId/result"

while ($true) {
    $response_result = Invoke-RestMethod -Uri $resultUrl -Method Get -Headers $headers_result
    if ($response_result.status -eq "running") {
        Write-Output "Rule still running. Waiting for 5 seconds..."
        Start-Sleep -Seconds $sleep
    } else {
        Write-Output "Rule Executed."
        Write-Output "Rule Status:"$response_result.status
        Write-Output "Result: $($response_result | ConvertTo-Json -Depth 10)"
        break
    }
}
