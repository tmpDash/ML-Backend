param(
    [string]$ruta = "."
)

Write-Host "Escaneando proyecto en: $ruta`n"

# ---------------------------------------------------------
# 1. Detectar tipo de proyecto
# ---------------------------------------------------------
$esReact   = Test-Path "$ruta\package.json"
$esFastAPI = (Test-Path "$ruta\main.py") -or (Test-Path "$ruta\app\main.py")

Write-Host "Detectando tipo de proyecto..."
if ($esReact) { Write-Host " → Proyecto React detectado" }
if ($esFastAPI) { Write-Host " → Proyecto FastAPI detectado" }
if (-not $esReact -and -not $esFastAPI) { Write-Host " → Proyecto genérico (no React / FastAPI)" }

# ---------------------------------------------------------
# 2. Lista base de exclusión dependiendo del proyecto
# ---------------------------------------------------------
$excluir = @(".git", ".idea", ".vscode")

if ($esReact) {
    $excluir += @(
        "node_modules",
        "dist",
        "build",
        ".react-router"
    )
}

if ($esFastAPI) {
    $excluir += @(
        "__pycache__",
        "venv",
        ".venv",
        "env",
        ".mypy_cache",
        ".pytest_cache",
        "*.egg-info",
        "staticfiles",
        ".ruff_cache"
    )
}

Write-Host "`nCarpetas excluidas:"
$excluir | ForEach-Object { Write-Host " - $_" }
Write-Host ""

# ---------------------------------------------------------
# 3. Listado recursivo con exclusiones
# ---------------------------------------------------------
Get-ChildItem -Path $ruta -Recurse -Force |
    Where-Object {
        $full = $_.FullName
        $valid = $true
        foreach ($ex in $excluir) {
            # Manejar patrones *.egg-info
            if ($ex -like "*.egg-info" -and $full -like "*egg-info") {
                $valid = $false
            }
            elseif ($full -like "*\$ex\*") {
                $valid = $false
            }
        }
        $valid
    } |
    ForEach-Object {
        if ($_.PSIsContainer) {
            Write-Host "[DIR]  $($_.FullName)"
        } else {
            Write-Host "[FILE] $($_.FullName)"
        }
    }
