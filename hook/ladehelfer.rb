# Bitte ändern Sie den Pfad in der folgenden Zeile auf den Pfad, in dem
# Sie die Beispiele ausgepackt haben.
this_path = 'C:/Dokumente und Einstellungen/jan/Eigene Dateien/Sketchup-Beispiele'
# basisverzeichnis und lib zum load_path hinzufuegen
$LOAD_PATH.unshift(this_path)
$LOAD_PATH.unshift(File.join(this_path, 'lib'))
# alle beispiele laden
require_all(this_path)