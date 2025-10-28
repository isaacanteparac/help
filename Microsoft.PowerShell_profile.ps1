function new {
    param (
        [Parameter(Mandatory=$true)]
        [string]$fileName
    )

    # Construir la ruta completa
    $fullPath = Join-Path -Path (Get-Location) -ChildPath $fileName

    # Identificar si es un archivo o carpeta
    if ($fileName -match "\.") {
        # Caso: Es un archivo porque tiene un punto en el nombre
        Set-Content -Path $fullPath -Value ""
        Write-Host "New File Created 📄" -ForegroundColor Green
    } else {
        # Caso: Es una carpeta porque no tiene un punto en el nombre
        New-Item -Path $fullPath -ItemType Directory
        Write-Host "New Directory Created 📁" -ForegroundColor Yellow
    }
}

function hash{
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    # Verifica si el archivo existe antes de continuar
    if (-not (Test-Path $Path -PathType Leaf)) {
        Write-Error "El archivo no se encontró en la ruta: $Path"
        return
    }

    $hashTable = @{}
    $algorithms = 'MD5', 'SHA1', 'SHA256'

    foreach ($algorithm in $algorithms) {
        $hash = Get-FileHash -Path $Path -Algorithm $algorithm
        $hashTable.Add($hash.Algorithm, $hash.Hash)
    }

    # Muestra los resultados en un formato fácil de leer
    $hashTable | Format-List

}

function delete {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    # Eliminar archivos o carpetas
    Remove-Item -Path $Path -Force -Recurse
    Write-Host "Successfully removed" -ForegroundColor Green

}

function bws {
    param (
        [Parameter(Mandatory=$true)]
        [string]$fileName
    )

    # Construir la ruta completa del archivo
    $fullPath = Join-Path -Path (Get-Location) -ChildPath $fileName

    # Verificar si el archivo existe y es compatible con el navegador
    if (Test-Path $fullPath) {
        # Verificar si la extensión es compatible con el navegador
        if ($fileName -match "\.(html|htm|xml)$") {
            # Abrir directamente en el navegador predeterminado
            start $fullPath
            Write-Host "Abriendo en el navegador: $fileName" -ForegroundColor Green
        } else {
            Write-Host "El archivo no es compatible con el navegador: $fileName" -ForegroundColor Red
        }
    } else {
        Write-Host "El archivo '$fileName' no existe." -ForegroundColor Red
    }
}

function pc-info {
    # Obtener información básica del sistema
    $systemInfo = Get-ComputerInfo
    $cpuInfo = Get-CimInstance -ClassName Win32_Processor
    $memoryInfo = Get-CimInstance -ClassName Win32_PhysicalMemory
    $gpuInfo = Get-CimInstance -ClassName Win32_VideoController
    $networkInfo = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }

    # Mostrar información del sistema
    Write-Host "== Información del Sistema ==" -ForegroundColor Cyan
    Write-Host "Nombre del Equipo: $($systemInfo.CsName)"
    Write-Host "Sistema Operativo: $($systemInfo.OsName)"
    Write-Host "Versión del SO: $($systemInfo.OsVersion)"
    Write-Host "Fabricante del Sistema: $($systemInfo.Manufacturer)"
    Write-Host "Modelo: $($systemInfo.Model)"
    Write-Host "==================================="

    Write-Host "== Información del CPU ==" -ForegroundColor Cyan
    Write-Host "Nombre del Procesador: $($cpuInfo.Name)"
    Write-Host "Núcleos: $($cpuInfo.NumberOfCores)"
    Write-Host "==================================="

    Write-Host "== Información de la Memoria RAM ==" -ForegroundColor Cyan
    $memoryInfo | ForEach-Object {
        Write-Host "Capacidad: $(($_.Capacity / 1GB) -as [int]) GB"
        Write-Host "Fabricante: $($_.Manufacturer)"
    }
    Write-Host "==================================="

    Write-Host "== Información de la GPU ==" -ForegroundColor Cyan
    $gpuInfo | ForEach-Object {
        Write-Host "Nombre del GPU: $($_.Name)"
        Write-Host "Memoria: $(($_.AdapterRAM / 1MB) -as [int]) MB"
    }
    Write-Host "==================================="

    Write-Host "== Información de Red ==" -ForegroundColor Cyan
    $networkInfo | ForEach-Object {
        Write-Host "Interfaz: $($_.Description)"
        Write-Host "Dirección MAC: $($_.MACAddress)"
        if ($_.IPAddress) {
            Write-Host "Direcciones IP:"
            $_.IPAddress | ForEach-Object { Write-Host "- $_" }
        }
        Write-Host "-----------------------------------"
    }
}

function server {
    # Generar un puerto aleatorio entre 1024 y 65535
    $randomPort = Get-Random -Minimum 1024 -Maximum 65535

    # Obtener la IP pública
    try {
        $publicIP = Invoke-WebRequest -Uri "https://api64.ipify.org?format=text" | Select-Object -ExpandProperty Content
    } catch {
        $publicIP = "Unable to retrieve public IP"
    }

    # Obtener todas las IPs locales (IPv4) de todos los adaptadores
    $networkInterfaces = Get-NetIPAddress | Where-Object { $_.AddressFamily -eq "IPv4" } | Select-Object InterfaceAlias, IPAddress

    # Mostrar información en la consola
    Write-Host "Server Started -> IP Port ${randomPort}" -ForegroundColor Green
    Write-Host "Adapters:" -ForegroundColor Green
    # Listar todas las IPs asociadas a cada adaptador
    foreach ($adapter in $networkInterfaces) {
        Write-Host "   $($adapter.InterfaceAlias)" -ForegroundColor Yellow
        Write-Host "    -> http://$($adapter.IPAddress):$randomPort" -ForegroundColor Cyan
    }

    Write-Host "IP Public: http://${publicIP}:${randomPort}" -ForegroundColor Cyan

    # Ejecutar el servidor HTTP en el proceso actual
    python -m http.server $randomPort
}

function open {
    param (
        [string]$target
    )

    # Si no se proporciona un objetivo, usar la carpeta actual
    if (-not $target) {
        $fullPath = Get-Location
        # Abrir la carpeta actual en el explorador de archivos
        explorer.exe $fullPath
        Write-Host "Opening folder: '$fullPath'." -ForegroundColor Green
        return
    }

    # Construir la ruta completa del archivo o carpeta
    $fullPath = Join-Path -Path (Get-Location) -ChildPath $target

    # Verificar si el archivo o carpeta existe
    if (Test-Path $fullPath) {
        # Verificar si es un archivo o carpeta
        $attributes = Get-Item $fullPath | Select-Object -ExpandProperty Attributes

        if ($attributes -match "Directory") {
            # Abrir carpeta en el explorador de archivos
            explorer.exe $fullPath
            Write-Host "Opening folder '$target'" -ForegroundColor Green
        } elseif ($attributes -match "Archive") {
            # Verificar si es un archivo de código
            $extension = [System.IO.Path]::GetExtension($target).ToLower()
            if ($extension -match "\.(py|js|java|c|cpp|cs|html|css|json|xml|php|rb|swift|ts|go|kt|pl|sh|r|m|scala|sql|bat|ps1)$") {
                # Abrir archivos de código en Visual Studio Code directamente
                code $fullPath
                Write-Host "Opening code file '$target'." -ForegroundColor Green
            } else {
                # Abrir otros tipos de archivos con la aplicación predeterminada
                Invoke-Expression $fullPath
                Write-Host "Opening file '$target'" -ForegroundColor Green
            }
        }
    } else {
        Write-Host "The file or folder '$target' doesn't exist." -ForegroundColor Red
    }
}

function edit-commands {
    $fullPath = "C:\Users\isaac\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

    # Verificar si el archivo existe
    if (Test-Path $fullPath) {
        # Abrir el archivo en Visual Studio Code directamente
        code $fullPath
        Write-Host "Opening configuration file '$fullPath'." -ForegroundColor Green
    } else {
        Write-Host "The file '$fullPath' does not exist." -ForegroundColor Red
    }
}

function copy {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$source,       # Archivo o carpeta que deseas copiar
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$destination   # Carpeta o ruta destino donde pegar la copia
    )

    # Verificar si el archivo o carpeta de origen existe
    if (-not (Test-Path $source)) {
        Write-Host "Error: The source file or folder '$source' does not exist." -ForegroundColor Red
        return
    }

    # Verificar si la carpeta de destino existe
    if (-not (Test-Path (Split-Path -Parent $destination))) {
        Write-Host "Error: The destination folder does not exist. Please create it first." -ForegroundColor Red
        return
    }

    # Intentar copiar el archivo o carpeta
    try {
        Copy-Item -Path $source -Destination $destination -Recurse
        Write-Host "Successfully copied '$source' to '$destination'." -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to copy '$source' to '$destination'. $_" -ForegroundColor Red
    }
}

function find {
    param (
        [Parameter(Mandatory = $true)]
        [string]$query,      # Criterio de búsqueda: extensión (.psd) o nombre parcial (docu)
        [switch]$near,       # Interruptor para búsqueda en subcarpetas inmediatas
        [switch]$deep        # Interruptor para habilitar búsqueda profunda en todos los niveles
    )

    # Validar entrada
    if (-not $query) {
        Write-Host "You must provide a query (e.g., .psd or docu)." -ForegroundColor Red
        return
    }

    # Determinar alcance de la búsqueda
    if ($deep) {
        Write-Host "Performing a deep search in all nested subdirectories..." -ForegroundColor Green

        # Búsqueda profunda en todos los niveles (archivos y carpetas)
        $results = Get-ChildItem -Path . -Recurse | Where-Object {
            ($query.StartsWith('.') -and $_.Extension -like "$query") -or
            (-not $query.StartsWith('.') -and $_.Name -like "*$query*")
        }
    } elseif ($near) {
        Write-Host "Performing search limited to subdirectories..." -ForegroundColor Cyan

        # Búsqueda limitada a subcarpetas inmediatas (archivos y carpetas)
        $results = Get-ChildItem -Path . -Directory | ForEach-Object {
            Get-ChildItem -Path $_.FullName | Where-Object {
                ($query.StartsWith('.') -and $_.Extension -like "$query") -or
                (-not $query.StartsWith('.') -and $_.Name -like "*$query*")
            }
        }
    } else {
        Write-Host "Performing search in the current folder..." -ForegroundColor Green

        # Búsqueda en la carpeta actual (archivos y carpetas)
        $results = Get-ChildItem -Path . | Where-Object {
            ($query.StartsWith('.') -and $_.Extension -like "$query") -or
            (-not $query.StartsWith('.') -and $_.Name -like "*$query*")
        }
    }

    # Mostrar resultados
    if ($results) {
        $results | ForEach-Object {
            [PSCustomObject]@{
                Name       = $_.Name
                Extension  = if ($_.PSIsContainer) { "" } else { $_.Extension }
                FullName   = $_.FullName
            }
        } | Format-Table -AutoSize
    } else {
        Write-Host "No matches found for '$query'." -ForegroundColor Red
        Write-Host "Example: To search for files with the '.txt' extension in subdirectories, use:" -ForegroundColor Yellow
        Write-Host "         find .txt -near" -ForegroundColor Cyan
        Write-Host "Example: To search deeply for folders or files containing 'project', use:" -ForegroundColor Yellow
        Write-Host "         find project -deep" -ForegroundColor Cyan
    }
}

function environment {
    param (
        [switch]$create,    # Interruptor para crear un entorno virtual
        [switch]$active,    # Interruptor para activar un entorno virtual
        [Parameter(Mandatory = $true)]
        [string]$envName    # Nombre del entorno virtual
    )

    if ($create -and $active) {
        Write-Host "You cannot specify both -create and -active at the same time." -ForegroundColor Red
        return
    }

    if ($create) {
        # Crear entorno virtual
        if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
            Write-Host "Python is not installed or not added to PATH." -ForegroundColor Red
            return
        }

        Write-Host "Creating Python environment named '$envName' in the current folder..." -ForegroundColor Green
        python -m venv $envName

        # Verificar si se creó correctamente
        if (Test-Path "$PWD\$envName") {
            Write-Host "Environment '$envName' created successfully!" -ForegroundColor Cyan
        } else {
            Write-Host "Failed to create the environment '$envName'. Please check for errors." -ForegroundColor Red
        }
    } elseif ($active) {
        # Activar entorno virtual
        $activateScript = ".\$envName\Scripts\activate"
        if (Test-Path "$PWD\$envName\Scripts\activate") {
            Write-Host "Activating the environment '$envName'..." -ForegroundColor Green
            Invoke-Expression $activateScript
            Write-Host "Environment '$envName' is now active!" -ForegroundColor Cyan
        } else {
            Write-Host "Failed to find the activation script for '$envName'. Ensure the environment exists or create it first with:" -ForegroundColor Red
            Write-Host "    environment -create $envName" -ForegroundColor Cyan
        }
    } else {
        Write-Host "You must specify either -create or -active as the action." -ForegroundColor Red
    }
}

function rename {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$oldName,  # Nombre original del archivo o carpeta
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$newName   # Nuevo nombre del archivo o carpeta
    )

    # Verificar si el archivo o carpeta original existe
    if (-not (Test-Path $oldName)) {
        Write-Host "Error: The file or folder '$oldName' does not exist." -ForegroundColor Red
        return
    }

    # Verificar si ya existe un archivo o carpeta con el nuevo nombre
    if (Test-Path $newName) {
        Write-Host "Error: A file or folder with the name '$newName' already exists." -ForegroundColor Red
        return
    }

    # Intentar renombrar
    try {
        Rename-Item -Path $oldName -NewName $newName
        Write-Host "Successfully renamed '$oldName' to '$newName'." -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to rename '$oldName' to '$newName'. $_" -ForegroundColor Red
    }
}

function move {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$source,       # Archivo o carpeta que deseas mover
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$destination   # Carpeta o ruta destino
    )

    # Verificar si el origen existe
    if (-not (Test-Path $source)) {
        Write-Host "Error: The source file or folder '$source' does not exist." -ForegroundColor Red
        return
    }

    # Verificar si la carpeta de destino existe
    if (-not (Test-Path (Split-Path -Parent $destination))) {
        Write-Host "Error: The destination folder does not exist. Please create it first." -ForegroundColor Red
        return
    }

    # Intentar mover el archivo o carpeta
    try {
        Move-Item -Path $source -Destination $destination
        Write-Host "Successfully moved '$source' to '$destination'." -ForegroundColor Green
    } catch {
        Write-Host "Error: Failed to move '$source' to '$destination'. $_" -ForegroundColor Red
    }
}

function auto-shutdown {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [int]$value,  # Cantidad de tiempo

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateSet("min", "hr")]
        [string]$unit # Unidad de tiempo: minutos o horas
    )

    # Validar que el valor sea positivo
    if ($value -le 0) {
        Write-Host "❌ Error: The time value must be greater than zero." -ForegroundColor Red
        Write-Host "`n✅ Example commands:" -ForegroundColor Yellow
        Write-Host "  auto-shutdown 10 -min   # Shutdown in 10 minutes" -ForegroundColor Cyan
        Write-Host "  auto-shutdown 1 -hr     # Shutdown in 1 hour" -ForegroundColor Cyan
        return
    }

    # Convertir a segundos
    switch ($unit) {
        "min" { $seconds = $value * 60 }
        "hr"  { $seconds = $value * 3600 }
    }

    # Ejecutar el comando de apagado
    try {
        shutdown.exe -s -t $seconds
        Write-Host "🕒 Shutdown scheduled in $value $unit ($seconds seconds)." -ForegroundColor Green
    } catch {
        Write-Host "❌ Error: Failed to schedule shutdown. $_" -ForegroundColor Red
    }
}

function commands {
    $commands = @(
        [PSCustomObject]@{ Name = "open"; Description = "Muestra el contenido en default application." },
        [PSCustomObject]@{ Name = "delete"; Description = "Elimina un archivo del sistema." },
        [PSCustomObject]@{ Name = "new"; Description = "Crea un archivo o carpeta." },
        [PSCustomObject]@{ Name = "pc-info"; Description = "Muestra información sobre los componentes de tu PC." },
        [PSCustomObject]@{ Name = "bws"; Description = "Muestra HTML en el default browser." },
        [PSCustomObject]@{ Name = "server"; Description = "Inicia un servidor en python." },
        [PSCustomObject]@{ Name = "environment"; Description = "Crea un enviroment usado py." }
        [PSCustomObject]@{ Name = "move"; Description = "Mueve files or folder. Example: move file.txt folder/." }
        [PSCustomObject]@{ Name = "copy"; Description = "Mueve files or folder. Example: copy file.txt folder/." }
        [PSCustomObject]@{ Name = "hash"; Description = "Muestra el hash de un file/directory" }
        [PSCustomObject]@{ Name = "auto-shutdown"; Description = "Apaga la pc luego de un tiempo" }
        [PSCustomObject]@{
                            Name = "rename";
                            Description = "Renombra archivos o carpetas existentes especificando el nombre original y el nuevo nombre con el formato: rename old to newname.
                                        Por ejemplo: rename oldFile.txt newFile.txt"
        }
        [PSCustomObject]@{
                        Name = "find";
                        Description = "Busca archivos y carpetas mediante extensión (.ext) o nombres parciales. Usa -sub para búsqueda recursiva en subcarpetas o -deep para búsqueda profunda en todos los niveles de subdirectorios."
        }

        [PSCustomObject]@{ Name = "edit-commands"; Description = "Edita los commands." }
    )

    # Mostrar la tabla en pantalla
    $commands | Format-Table -Property Name, Description -AutoSize
}


