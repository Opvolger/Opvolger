#!/usr/bin/env sh

genHtml() {
    echo "html for $1 with title $2"
    pandoc $1.md -o $1.html --template website-template/template.html --include-in-header website-template/header.html --include-before-body website-template/navbar.html --include-after-body website-template/footer.html --standalone --mathjax --toc --toc-depth 2 --metadata title="$2"
    # internal links md ext to html
    sed -i -e 's/md">/html">/g' $1.html
    # external links in new window
    sed -i -e 's/href="https/target="_blank" href="https/g' $1.html
}

genHtml index "Home"

genHtml kodi/npo "Kodi - NPO Uitzendinggemist"
genHtml kodi/rtlxl "Kodi - RTLxl"
genHtml kodi/kanalenlijst-hans "Kodi - Kanalenlijst Hans"

genHtml raspberrypi5/FedoraATIRadeonR9_290 "Raspberry Pi 5 - Fedora with AMDGPU, play Halflife 2"

genHtml milkVjupiter/OpenSUSEATIRadeonR9_290 "Milk-V Jupiter OpenSUSE Tumbleweed ATI Radeon R9 290"
genHtml milkVjupiter/OpenSUSEATIRadeonHD5850 "Milk-V Jupiter OpenSUSE Tumbleweed ATI Radeon HD 5850"

genHtml starfiveVisionFive2/FedoraATIRadeon5450 "StarFive VisionFive 2 Fedora ATI Radeon 5450"
genHtml starfiveVisionFive2/UbuntuATIRadeonR9_290 "StarFive VisionFive 2 Ubuntu 22.04 ATI Radeon R9 290"
genHtml starfiveVisionFive2/UbuntuATIRadeonR9_290_2023_11_20 "StarFive VisionFive 2 Ubuntu 23.10 ATI Radeon R9 290"
genHtml starfiveVisionFive2/OpenSUSEATIRadeonR9_290 "StarFive VisionFive 2 OpenSUSE Tumbleweed ATI Radeon R9 290"
genHtml starfiveVisionFive2/OpenSUSEATIRadeonR9_290_mainline "StarFive VisionFive 2 OpenSUSE Tumbleweed ATI Radeon R9 290 mainline kernel"
genHtml starfiveVisionFive2/Ubuntu2410_outofthebox "StarFive VisionFive 2 Ubuntu 24.10 AMDGPU"
genHtml starfiveVisionFive2/Ubuntu2504_outofthebox "StarFive VisionFive 2 Ubuntu 25.04 AMDGPU"
genHtml starfiveVisionFive2/LiteUBootKernel "StarFive VisionFive 2 Lite U-Boot and Kernel"

# TODO fix link .md to .html
rsync -a --prune-empty-dirs --include '*/' --include '*.ico' --include '*.html' --include '*.css' --include '*.png' --include '*.jpeg' --include '*.jpg' --exclude '*' ./ ../website

rm *.html
rm kodi/*.html
rm raspberrypi5/*.html
rm milkVjupiter/*.html
rm starfiveVisionFive2/*.html