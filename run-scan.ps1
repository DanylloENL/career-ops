# Career-Ops Automated Scan
# Executa scan a cada 2 dias
# Log: c:\Users\Danyl\career-ops\batch\logs\scan-{timestamp}.log

param(
    [string]$WorkspaceDir = "c:\Users\Danyl\career-ops"
)

# Timestamps para logging
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logDir = "$WorkspaceDir\batch\logs"
$logFile = "$logDir\scan-$timestamp.log"

# Criar diretório de logs se não existir
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# Redirect output para log
$output = @()
$output += "=== Career-Ops Scan ===" 
$output += "Iniciado em: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$output += ""

try {
    # Navegar para workspace
    Set-Location $WorkspaceDir
    
    # Executar scan
    $output += "Executando: node scan.mjs"
    $output += ""
    
    $scanOutput = & node scan.mjs 2>&1
    $output += $scanOutput
    
    $output += ""
    $output += "=== Scan Completado ==="
    $output += "Finalizado em: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}
catch {
    $output += "ERRO: $_"
    $output += $_.Exception
}

# Salvar log
$output | Out-File -FilePath $logFile -Encoding UTF8
Write-Host "Log salvo em: $logFile"
