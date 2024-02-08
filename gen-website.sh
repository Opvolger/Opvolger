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

genHtml starfiveVisionFive2/FedoraATIRadeon5450 "StarFive VisionFive 2 Fedora ATI Radeon 5450"
genHtml starfiveVisionFive2/UbuntuATIRadeonR9_290 "StarFive VisionFive 2 Ubuntu 22.04 ATI Radeon R9 290"
genHtml starfiveVisionFive2/UbuntuATIRadeonR9_290_2023_11_20 "StarFive VisionFive 2 23.10 Ubuntu ATI Radeon R9 290"

# TODO fix link .md to .html
rsync -a --prune-empty-dirs --include '*/' --include '*.ico' --include '*.html' --include '*.css' --include '*.png' --include '*.jpeg' --exclude '*' ./ ../website

rm *.html
rm kodi/*.html
rm starfiveVisionFive2/*.html