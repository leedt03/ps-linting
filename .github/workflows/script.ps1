$files = Get-ChildItem -Include "*.ps1", "*.psm1" -Recurse

foreach ($file in $files){
    $results = Invoke-ScriptAnalyzer -Path $file.FullName

    foreach ($result in $results){
        Write-Output "Analysing file: $($result.ScriptName)"
        Write-Output "Rule Name: $($result.RuleName)"
        Write-Output "Message: $($result.Message)"
        Write-Output "Severity: $($result.Severity)"
        Write-Output "------"
    }
}