#!/usr/bin/env sh

genHtml() {
    echo "html for $1 with title $3 in template in dir $2"
    pandoc $1.md -o $1.html --template ${2}website-template/template.html --include-in-header ${2}website-template/header.html --include-before-body ${2}website-template/navbar.html --include-after-body ${2}website-template/footer.html --standalone --mathjax --toc --toc-depth 2 --metadata title="$3"
}

genHtml index "" "Home"

cd starfiveVisionFive2

genHtml FedoraATIRadeon5450 '../' "StarFive VisionFive 2 Fedora ATI Radeon 5450"
genHtml UbuntuATIRadeonR9_290 '../' "StarFive VisionFive 2 Ubuntu 22.04 ATI Radeon R9 290"
genHtml UbuntuATIRadeonR9_290_2023_11_20 '../' "StarFive VisionFive 2 23.10 Ubuntu ATI Radeon R9 290"

# TODO fix link .md to .html

cd ..

rsync -a --prune-empty-dirs --include '*/' --include '*.html' --include '*.png' --include '*.jpeg' --exclude '*' ./ ../website

rm *.html
rm starfiveVisionFive2/*.html