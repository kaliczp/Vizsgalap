#Adatok feldolgozasa
cat $1 | tr -d '\r' |\
sed -e's/^\([^%]\)/\\newcommand{\\\1/'\
    -e's/\([^:]\)$/\1}/'\
    -e's/ /}{/' > adat.tex
