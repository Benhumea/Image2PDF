# Ruta de las bibliotecas de ImageMagick
$magickLibPath = "C:\Ruta\A\La\Carpeta\Lib"

# Agrega la ruta de las bibliotecas de ImageMagick al entorno de ejecución
$env:Path += ";$magickLibPath"

# Función para convertir imágenes a PDF utilizando las bibliotecas de ImageMagick
function ConvertirImagenAPDF($inputImages, $outputPdf) {
    # Verifica que las imágenes existan
    foreach ($image in $inputImages) {
        if (-not (Test-Path $image -PathType Leaf)) {
            Write-Host "La imagen '$image' no existe."
            return
        }
    }

    # Convierte las imágenes a PDF
    $convertArgs = "-density 300 -compress jpeg"
    $convertArgs += "`"$($inputImages -join """ """)`""
    $convertArgs += "`"$outputPdf`""
    & convert.exe $convertArgs
}

# Ejemplo de uso
$imagenes = @("imagen1.jpg", "imagen2.png")
$salidaPdf = "salida.pdf"

ConvertirImagenAPDF $imagenes $salidaPdf
