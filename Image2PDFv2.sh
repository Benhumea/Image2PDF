#!/bin/bash
echo "
 __      __        .__   __   .__ 
/  \    /  \_____  |  | |  | _|__|
\   \/\/   /\__  \ |  | |  |/ /  |
 \        /  / __ \|  |_|    <|  |
  \__/\  /  (____  /____/__|_ \__|
       \/        \/          \/   
Imagen a PDF v1.0
"

sleep 1


generarPDF() {
  # Verifica si ImageMagick está instalado
  if ! command -v convert &>/dev/null; then
    echo "ImageMagick no está instalado. Por favor, instálalo antes de ejecutar este script."
    exit 1
  fi

  # Solicita al usuario ingresar la carpeta que contiene las imágenes
  read -p "Ingrese la ruta de la carpeta que contiene las imágenes: " input_folder
  if [ ! -d "$input_folder" ]; then
    echo "La carpeta '$input_folder' no existe."
    exit 1
  fi

  # Solicita al usuario ingresar el nombre del archivo PDF de salida
  read -p "Ingrese el nombre del archivo PDF de salida: " output_pdf

 # Solicita el valor de calidad (quality)
  while true; do
    read -p "Ingrese el valor de calidad (1-100): " quality
    if ! [[ "$quality" =~ ^[1-9][0-9]?$|^100$ ]]; then
      echo "Valor de calidad inválido. Intente nuevamente."
    else
      break
    fi
  done

  # Solicita el valor de densidad (density)
  while true; do
    read -p "Ingrese el valor de densidad (72-300): " density
    if ! [[ "$density" =~ ^(7[2-9]|8[0-9]|9[0-9]|100|2[0-9]{2}|300)$ ]]; then
      echo "Valor de densidad inválido. Intente nuevamente."
    else
      break
    fi
  done
  # Convierte las imágenes a PDF
  convert -quality "$quality" -density "$density" "$input_folder/*" "$output_pdf"
  echo "Se ha generado el archivo PDF '$output_pdf'."
}



# Función para convertir varias imágenes a PDF con nombres ascendentes
convertirImagenes() {
  # Verifica si ImageMagick está instalado
if ! command -v convert &>/dev/null; then
  echo "ImageMagick no está instalado. Por favor, instálalo antes de ejecutar este script."
  exit 1
fi
  read -p "Ingrese la ruta donde estan los archivos de imagen:" input_directory
  read -p "Ingrese la extensión de imagen (por ejemplo, 'jpg', 'png', 'gif', etc.):" image_extension
  read -p "Ingrese el prefijo de Salida para los nombres de archivo (por ejemplo, 'output'):" filename_prefix
  read -p "Ingrese la ruta de salida para los archivos PDF:" output_directory
  # Solicita el valor de calidad (quality)
  while true; do
    read -p "Ingrese el valor de calidad (1-100): " quality
    if ! [[ "$quality" =~ ^[1-9][0-9]?$|^100$ ]]; then
      echo "Valor de calidad inválido. Intente nuevamente."
    else
      break
    fi
  done

  # Solicita el valor de densidad (density)
  while true; do
    read -p "Ingrese el valor de densidad (72-300): " density
    if ! [[ "$density" =~ ^(7[2-9]|8[0-9]|9[0-9]|100|2[0-9]{2}|300)$ ]]; then
      echo "Valor de densidad inválido. Intente nuevamente."
    else
      break
    fi
  done
  # Verifica que las imágenes existan
  input_images=()
  shopt -s nullglob
  for image in "$input_directory"/*."$image_extension"; do
    input_images+=("$image")
  done
  shopt -u nullglob

  # Convierte las imágenes a PDF con nombres ascendentes
  if [ ${#input_images[@]} -gt 0 ]; then
    counter=1
    for image in "${input_images[@]}"; do
      output_pdf="${output_directory}/${filename_prefix}_$(printf "%04d" $counter).pdf"
      convert -quality "$quality" -density "$density" "$image" "$output_pdf"
      echo "Se ha generado el archivo PDF '$output_pdf'."
      ((counter++))
    done
  else
    echo "No se encontraron imágenes con la extensión '$image_extension' en el directorio actual."
  fi
}

# Menú principal
while true; do
  echo "Seleccione una opción:"
  echo "1. Generar un solo archivo PDF para varias imágenes"
  echo "2. Convertir varias imágenes a PDF con nombres ascendentes"
  echo "3. Salir"
  read option

  case $option in
    1)
      generarPDF
      ;;
    2)
      convertirImagenes
      ;;
    3)
      echo "¡Hasta luego!"
      exit 0
      ;;
    *)
      echo "Opción inválida. Intente nuevamente."
      ;;
  esac

  echo "Presione Enter para continuar..."
  read enter_key
done
