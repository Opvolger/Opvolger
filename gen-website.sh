#!/usr/bin/env sh

genHtml() {
    echo "html for $1 in template in dir $2"
    pandoc $1.md -o $1.html --template ${2}website-template/template.html --include-in-header ${2}website-template/header.html --include-before-body ${2}website-template/navbar.html --include-after-body ${2}website-template/footer.html --standalone --mathjax --toc --toc-depth 2
}

genHtml index ""

cd starfiveVisionFive2

genHtml FedoraATIRadeon5450 '../'
genHtml UbuntuATIRadeonR9_290 '../'
genHtml UbuntuATIRadeonR9_290_2023_11_20 '../'

cd ..

rsync -a --prune-empty-dirs --include '*/' --include '*.html' --include '*.png' --include '*.jpeg' --exclude '*' ./ ../website

rm *.html
rm starfiveVisionFive2/*.html