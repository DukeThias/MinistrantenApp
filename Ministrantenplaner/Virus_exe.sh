#!/bin/bash

# Terminal öffnen, in den Ordner "MiniPlaner" wechseln und MiniPlaner.exe mit Wine starten
gnome-terminal -- bash -c 'cd "$(dirname "$0")/MiniPlaner" && wine MiniPlaner.exe; exec bash'

