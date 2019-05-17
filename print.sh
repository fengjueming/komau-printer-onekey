#!/bin/bash

export PDD="/Library/Printers/PPDs/Contents/Resources/EPSON LP-S9000.gz"
export SPSE="/Library/Printers/SPSE/SPSENotifier.app"

[[ "$EUID" -ne '0' ]] && echo "Error:This script must be run as root!" && exit 1;


if [ ! -d "$SPSE" ]; then
    echo "Error:Please install SPSE."
    exit 1
fi
echo "SPSE OK"

if [ ! -f "$PDD" ]; then
    echo "Error:Please install Printer Devicers."
    exit 1
fi
echo "Devicers OK"


lpadmin -p Mono -E -v spssock://10.1.1.201:60000/Mono -m '/Library/Printers/PPDs/Contents/Resources/EPSON LP-S3550.gz'
lpadmin -p Color -E -v spssock://10.1.1.201:60000/Color -m 'Library/Printers/PPDs/Contents/Resources/EPSON LP-S9000.gz'
echo "プリンター追加完了"
echo "現在システムに設定したプリンター："
lpstat -s
echo "以上です"

read -p "KOMAnetIDを入力してください: " KOMAID
echo -n $KOMAID > /Users/Shared/SPSE/SPSEUser
echo "OK"
