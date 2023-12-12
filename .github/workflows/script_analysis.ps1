# Import modules
Import-Module Pester -Required
Install-Module PSScriptAnalyzer -Required

# Define script and report paths
$scriptPath = Join-Path $runner.workspace ".github/workflows/script_analysis.ps1"
$reportPath = Join-Path $runner.workspace "script_analysis_report.txt"

# Analyze scripts
$scriptFiles = Get-ChildItem -Path $runner.workspace -Filter "*.ps1", "*.psm1" -Recurse -File
$analysisResults = foreach ($scriptFile in $scriptFiles) { Invoke-ScriptAnalyzer -Path $scriptFile }

# Generate warnings for annotations
$warnings = ""
foreach ($analysisResult in $analysisResults) {
  foreach ($violation in $analysisResult.Diagnostics) {
    if ($violation.Severity -ge "Warning") {
      $warnings += "- $($violation.File) ($($violation.Rule.Name)): $($violation.Message)"
    }
  }
}

# Upload report as artifact
$report = $analysisResults | ConvertTo-Json
$report | Out-File $reportPath -Force
Upload-Artifact -Path $reportPath -Name script_analysis_report.txt

# Annotate commit with warnings (optional)
if ($warnings) {
  Write-Host "::warning:: Please review script quality issues:"
  Write-Host $warnings
  echo $warnings >> "${GITHUB_EVENT_PATH}/${{ runner.os }}"
}