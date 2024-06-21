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
