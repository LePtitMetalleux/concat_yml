#!/bin/bash

# concat_yml.sh
# Auteur : LePtitMetalleux
# Utilité : Concatène plusieurs fichiers YML
# Usage : Le script est à exécuter avec ou sans répertoire en argument
# Exemple : python3 concat_yml.sh /home/user/yml/
# Limites connues : Aucune
# Version : 1.0
# Historique : 26/11/2025 - Création du script - LePtitMetalleux
#              31/01/2026 - Amélioration du script, optimisations - LePtitMetalleux

# Chemin du dossier contenant les fichiers
folder_path="$PWD"

# Fonction récursive pour traiter les fichiers YML/YAML
concat_yml_files() {
    local file="$1"
    echo "Traitement du fichier : $file"
    cat "$file" >> "$output_file"
    echo "---" >> "$output_file"
}

# Fonction récursive pour parcourir les répertoires
loop_in_directory() {
    local dir="$1"
    for entry in "$dir"/*; do
        if [ -d "$entry" ]; then
            # Si c'est un répertoire, appeler récursivement
            loop_in_directory "$entry"
        elif [[ "$entry" == *.yml || "$entry" == *.yaml ]]; then
            # Si c'est un fichier YML/YAML, le concaténer
            concat_yml_files "$entry"
        fi
    done
}

if [ ! $# -eq 1 ]; then
    read -r -p "Indiquez le répertoire dans lequel se trouvent les fichiers YML à concaténer [$folder_path] : " folder_path
    folder_path="${folder_path:-$PWD}"
else
    folder_path="$1"
fi

echo "Traitement des fichiers présents dans : $folder_path"

# Chemin du fichier de synthèse
output_file="$PWD/concated.yml"

if [ ! $# -eq 2 ]; then
    read -r -p "Indiquez le chemin du fichier de sortie [$output_file] : " output_file
    output_file="${output_file:-$PWD/concated.yml}"
else
    output_file="$2"
fi

echo "Le fichier de sortie sera : $output_file"

# Vider ou créer le fichier de synthèse
> "$output_file"



# Appeler la fonction récursive à partir du dossier donné
if [ -d "$folder_path" ]; then
    loop_in_directory "$folder_path"
    # Retirer la dernière ligne "---" ajoutée en trop (portable: GNU and BSD sed)
    sed -i -e '$ d' "$output_file"
    echo "Les fichiers YML/YAML ont été concaténés dans $output_file."
else
    echo "Erreur : Le répertoire '$folder_path' n'existe pas."
    exit 1
fi
