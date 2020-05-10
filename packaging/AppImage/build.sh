content=$(wget https://www.zotero.org/download -q -O -)
VERSION=$(echo $content | grep -o -P '(?<="linux-x86_64":").*(?="})')

if [ ! -e Zotero-${VERSION}_linux-x86_64.tar.bz2 ]
then
    wget "https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64&version=$VERSION" -O Zotero-${VERSION}_linux-x86_64.tar.bz2
fi

if [ -d Zotero-${VERSION}_linux-x86_64 ]
then
    rm -rf Zotero-${VERSION}_linux-x86_64
fi
echo "Extracting..."
tar -jxf Zotero-${VERSION}_linux-x86_64.tar.bz2
mv Zotero_linux-x86_64 Zotero-${VERSION}_linux-x86_64

if [ ! -f appimagetool-x86_64.AppImage ]
then
    wget "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
    chmod +x appimagetool-x86_64.AppImage
fi

echo "Configuring..."
cd Zotero-${VERSION}_linux-x86_64
mv zotero AppRun
sed "s/Exec=.*/Exec=zotero-bin/g" zotero.desktop | sed "s#MimeType=text/plain#MimeType=text/plain;#" | sed "s/zotero.ico/zotero/g"> zotero-new.desktop
mv zotero-new.desktop zotero.desktop

cp chrome/icons/default/main-window.ico zotero.ico
convert zotero.ico zotero.png
mv zotero-0.png zotero.png
rm zotero-*.png zotero.ico

echo "Packaging..."

cd ..
./appimagetool-x86_64.AppImage Zotero-${VERSION}_linux-x86_64
mv Zotero-x86_64.AppImage Zotero-${VERSION}_linux-x86_64.AppImage

rm -rf Zotero-${VERSION}_linux-x86_64
rm Zotero-${VERSION}_linux-x86_64.tar.bz2
rm appimagetool-x86_64.AppImage
