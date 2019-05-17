#!/bin/bash

export PDD="/Library/Printers/PPDs/Contents/Resources/EPSON LP-S9000.gz"
export SPSE="/Library/Printers/SPSE/SPSENotifier.app"

function root_check()
{
if [[ $EUID -ne 0 ]]; then
  echo "管理員権限がありません、sudo bashしてからもう一回実行してください" 1>&2
  exit 1
fi
}

function INSDEV()
{
    curl https://www.komazawa-u.ac.jp/~joho/printer2015/Komazawa_u_pd_Mac_Ver4.zip -o /tmp/Komazawa_u_pd_Mac_Ver4.zip
    #curl -O https://ming.moe/Komazawa_u_pd_Mac_Ver4.zip
    unzip -o Komazawa_u_pd_Mac_Ver4.zip -x '__MACOSX/*'
    installer -pkg 駒澤大学_プリンタードライバー_forMac_Ver4/駒澤大学_プリンタードライバーforMac.pkg -target /
    installer -pkg 駒澤大学_プリンタードライバー_forMac_Ver4/SPSE\ CUPS\ Driver\ Input\ User\ Installer.pkg -target /
    rm -rf 駒澤大学_プリンタードライバー_forMac_Ver4
    rm -rf Komazawa_u_pd_Mac_Ver4.zip
    echo "ドライバーインストール完了"
}

function Install()
{
if [ ! -d "$SPSE" ]; then
    if [ ! -f "$PDD" ]; then
        echo "SPSEとプリンタードライバーが見つかりませんでした"
        echo "これからドライバーをダウンロードします"
        INSDEV
    else
    echo "Error:Please install SPSE."
    exit
    fi
else
if [ ! -r "$PDD" ]; then
echo "Error:Please install Printer Devicers."
exit
fi
echo "SPSE&Drivers OK"
fi

lpadmin -p Mono -E -v spssock://10.1.1.201:60000/Mono -m '/Library/Printers/PPDs/Contents/Resources/EPSON LP-S3550.gz'
lpadmin -p Color -E -v spssock://10.1.1.201:60000/Color -m 'Library/Printers/PPDs/Contents/Resources/EPSON LP-S9000.gz'
echo "プリンター追加完了"
echo "現在システムに設定したプリンター："
lpstat -s
echo "以上です"
echo "SPSEUserに書き込みします"
mkdir -p /Users/Shared/SPSE/
touch /Users/Shared/SPSE/SPSEUser
echo -n $ID > /Users/Shared/SPSE/SPSEUser
echo "完了"
}

if [ $# == '1' ]; then
    root_check
    echo "KOMAnetIDが$1になります"
    ID=$1
    Install
else
    echo "最後にKOMAnetIDをつけてください"
    echo "例：bash <(curl -s https://raw.githubusercontent.com/fengjueming/komau-printer-onekey/master/print.sh) 1mx0000x"
fi
