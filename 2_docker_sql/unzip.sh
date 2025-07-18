#!/bin/bash

# Crée un dossier pour les fichiers décompressés
mkdir -p Data

# Boucle sur tous les fichiers .csv.gz présents dans le dossier courant
for f in yellow_tripdata_*.csv.gz
do
    echo "Unzipping $f ..."
    gunzip -c "$f" > "Data/${f%.gz}"
done

echo "✅ All files unzipped into ./uncompressed"
