$files = Get-ChildItem -Include "*.ps1", "*.psm1" -Recurse

foreach ($file in $files){
    $results = Invoke-ScriptAnalyzer -Path $file.FullName

    foreach ($result in $results){
        Write-Host "Analysing file: $($result.ScriptName)"
        Write-Host "Rule Name: $($result.RuleName)"
        Write-Host "Message: $($result.Message)"
        Write-Host "Severity: $($result.Severity)" -ForegroundColor Red -BackgroundColor Black
        Write-Host "------"
    }
}