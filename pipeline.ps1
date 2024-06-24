##########################
# Taking inputs
Param(
    [Parameter(Position = 0)][string]$e,  # Base URL
    [Parameter(Position = 1)][string]$w,  # Workspace Id
    [Parameter(Position = 2)][string]$r,  # Rule Id
    [Parameter(Position = 3)][string]$u,  # Username
    [Parameter(Position = 4)][string]$p   # Password 
)

##########################
#Fetching the Token

$url = "$e/auth/realms/iam.icedq/protocol/openid-connect/token"

$headers = @{
    "Content-type"  = "application/x-www-form-urlencoded"
    "x"             = "7ab54d93-a7e4-43da-9a7e-52705354405d7ab54d93-a7e4-43da-9a7e-52705354405d"
    "Cookie"        = "JSESSIONID=881440F094F82574926B88F3D42A2381"
    "Authorization" = "Basic aWNlZHEuYWRtaW4tdWk6MGVkYzQwNmQtYmE0YS00NzdjLTk2ZjItNzJiZTM1NWQ2ZDk4"
}

$body = @{
    "grant_type" = "password"
    "username"   = $u
    "password"   = $p
}

try {
    $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body
    $access_token = $response.access_token
} catch {
    Write-Error "Failed to fetch access token: $_"
    exit 1
}

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
    'Authorization' = "Bearer $access_token"
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
    'Authorization' = "Bearer $access_token"
    'Content-Type' = 'application/json'
    'Workspace-Id' = $workspaceId
    'Cookie' = 'JSESSIONID=1FD5BB9FCA872C103046C11D50193A69'
}
$resultUrl = "$base_url/workflowruns/$instanceId/result"

while ($true) {
  try{
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
  }catch{
  Write-Error "Failed to fetch rule status: $_"
        exit 1
    }
}
