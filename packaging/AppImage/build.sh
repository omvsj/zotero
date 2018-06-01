
VERSION=5.0.47

if [ ! -e zotero-$VERSION.tar.bz2 ]
then
    #wget "https://github.com/zotero/zotero/archive/$VERSION.tar.gz"
    wget "https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64&version=$VERSION" -O zotero-$VERSION.tar.bz2
fi

if [ -d Zotero_linux-x86_64 ]
then
    rm -rf Zotero_linux-x86_64
fi
echo "Extracting.."
tar -jxf zotero-$VERSION.tar.bz2

if [ ! -f appimagetool-x86_64.AppImage ]
then
    wget "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
    chmod +x appimagetool-x86_64.AppImage
fi

echo "Configuring.."
cd Zotero_linux-x86_64
mv zotero AppRun
sed "s/Exec=.*/Exec=zotero-bin/g" zotero.desktop | sed "s#MimeType=text/plain#MimeType=text/plain;#" | sed "s/zotero.ico/zotero/g"> zotero-new.desktop
mv zotero-new.desktop zotero.desktop

cp chrome/icons/default/main-window.ico zotero.ico
convert zotero.ico zotero.png
mv zotero-0.png zotero.png
rm zotero-*.png zotero.ico

echo "Packaging.."

cd ..
./appimagetool-x86_64.AppImage ~/Programming/zotero/packaging/AppImage/Zotero_linux-x86_64

rm -rf Zotero_linux-x86_64

