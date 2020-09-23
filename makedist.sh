#!/bin/sh -ex

cur=$(pwd)
tmp=$(mktemp -d)
release=$1
[ -n "$release" ]

redo-ifchange streebog256
git clone . $tmp/gogost-$release
cd $tmp/gogost-$release
git checkout v$release
redo module-name VERSION
mod_name=`cat module-name`

crypto_mod_path=$(sed -n 's#^require \(golang.org/x/crypto\) \(.*\)$#\1@\2#p' go.mod)
mkdir -p src/$mod_name
mv \
    gost28147 \
    gost3410 \
    gost34112012256 \
    gost34112012512 \
    gost341194 \
    gost3412128 \
    gost341264 \
    gost3413 \
    mgm \
    prfplus \
    cmd internal gogost.go go.mod go.sum src/$mod_name

echo $mod_name > module-name
find . -name "*.do" -exec perl -i -npe "s/^go/GOPATH=\`pwd\` go/" {} \;
mkdir contrib
cp ~/work/redo/minimal/do contrib/do

mkdir -p src/golang.org/x/crypto
( cd $GOPATH/pkg/mod/$crypto_mod_path ; \
    tar cf - AUTHORS CONTRIBUTORS LICENSE PATENTS README.md pbkdf2 hkdf ) |
    tar xfC - src/golang.org/x/crypto

cat > download.texi <<EOF
You can obtain releases source code prepared tarballs on
@url{http://www.gogost.cypherpunks.ru/}.
EOF

texi=$(mktemp)
cat > $texi <<EOF
\input texinfo
@documentencoding UTF-8
@settitle INSTALL
@include install.texi
@bye
EOF
mkinfo --output INSTALL $texi

cat > $texi <<EOF
\input texinfo
@documentencoding UTF-8
@settitle NEWS
@include news.texi
@bye
EOF
mkinfo --output NEWS $texi

cat > $texi <<EOF
\input texinfo
@documentencoding UTF-8
@settitle FAQ
@include faq.texi
@bye
EOF
mkinfo --output FAQ $texi

find . -name .git -type d | xargs rm -fr
rm -fr .redo
rm -f \
    $texi \
    *.texi \
    .gitignore \
    clean.do \
    makedist.sh \
    module-name.do \
    style.css \
    TODO \
    VERSION.do \
    www.do

find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;

cd ..
tar cvf gogost-"$release".tar --uid=0 --gid=0 --numeric-owner gogost-"$release"
xz -9 gogost-"$release".tar
gpg --detach-sign --sign --local-user 82343436696FC85A gogost-"$release".tar.xz

tarball=gogost-"$release".tar.xz
size=$(( $(stat -f %z $tarball) / 1024 ))
hash=$(gpg --print-md SHA256 < $tarball)
hashsb=$($HOME/work/gogost/streebog256 < $tarball)
release_date=$(date "+%Y-%m-%d")

cat <<EOF
An entry for documentation:
@item @ref{Release $release, $release} @tab $release_date @tab $size KiB
@tab @url{gogost-${release}.tar.xz, link} @url{gogost-${release}.tar.xz.sig, sign}
@tab @code{$hash}
@tab @code{$hashsb}
EOF

cat <<EOF
Subject: [EN] GoGOST $release release announcement

I am pleased to announce GoGOST $release release availability!

GoGOST is free software pure Go GOST cryptographic functions library.
GOST is GOvernment STandard of Russian Federation (and Soviet Union).

------------------------ >8 ------------------------

The main improvements for that release are:


------------------------ >8 ------------------------

GoGOST'es home page is: http://www.gogost.cypherpunks.ru/

Source code and its signature for that version can be found here:

    http://www.gogost.cypherpunks.ru/gogost-${release}.tar.xz ($size KiB)
    http://www.gogost.cypherpunks.ru/gogost-${release}.tar.xz.sig

Streebog-256 hash: $hashsb
SHA256 hash: $hash
GPG key: CEBD 1282 2C46 9C02 A81A  0467 8234 3436 696F C85A
         GoGOST releases <gogost at cypherpunks dot ru>

Please send questions regarding the use of GoGOST, bug reports and patches
to mailing list: https://lists.cypherpunks.ru/mailman/listinfo/gost
EOF

cat <<EOF
Subject: [RU] Состоялся релиз GoGOST $release

Я рад сообщить о выходе релиза GoGOST $release!

GoGOST это свободное программное обеспечение реализующее
криптографические функции ГОСТ на чистом Go. ГОСТ -- ГОсударственный
СТандарт Российской Федерации (а также Советского Союза).

------------------------ >8 ------------------------

Основные усовершенствования в этом релизе:


------------------------ >8 ------------------------

Домашняя страница GoGOST: http://www.gogost.cypherpunks.ru/

Исходный код и его подпись для этой версии могут быть найдены здесь:

    http://www.gogost.cypherpunks.ru/gogost-${release}.tar.xz ($size KiB)
    http://www.gogost.cypherpunks.ru/gogost-${release}.tar.xz.sig

Streebog-256 хэш: $hashsb
SHA256 хэш: $hash
GPG ключ: CEBD 1282 2C46 9C02 A81A  0467 8234 3436 696F C85A
          GoGOST releases <gogost at cypherpunks dot ru>

Пожалуйста, все вопросы касающиеся использования GoGOST, отчёты об
ошибках и патчи отправляйте в gost почтовую рассылку:
https://lists.cypherpunks.ru/mailman/listinfo/gost
EOF

mv $tmp/$tarball $tmp/"$tarball".sig $cur/gogost.html/
