#!/usr/bin/env perl
## Bemeneti fájlt a standard inputról?
# open(INFILE,"vizeskekezel.txt");
# open(INFILE,"vizgazdismlevelezo.txt");
# open(INFILE,"Vizgazdism2018.txt");
# open(INFILE,"Vizeselohely2019.txt");
# open(INFILE,"Aramlastan2019.txt");
open(INFILE,"nmt2.txt");
#open(OUTFILE,">prob.pl.txt");

## \nopagebreak kellene a hallgatói cellákba.

## A tárgynév és oktatói adatok beolvasása még nem perlesített!

## Hány jegy volt? Meghatározni, hogy hányszor jött vissza?
## Ez talán a fájl egy lépésben való beolvasása helyett mehet lépésenként
## és a feldolgozás közben számolom a max jegyeket.
## Nevet, kódot, jegyet és dátumot tömbben tárolom és a végén egy
## ciklussal íratom ki. A tömbben tárolom, hogy az adott személy hányszor
## vizsgázott és az üres oszlopokat a maximumig pótolom.

## Dátumot és jegyet egymás alá, hogy jobban kiférjen a hosszú nevek
## esetén is.

$hanyjegy = 1;

while (<INFILE>){
    chomp;
    ##A tabulátorral elválasztott szöveg szétszedése
    ($ttkod, $ttveznev, $ttkernev, $nincs1, $ttertek, $ttelozo) = split(/\t/);
######################################################################
###Tömbkezdemény a $sor nullával generálódik, ami úgysem kell.
    ######################################################################
    @kod[$sor] = $ttkod;
    @nev[$sor] = join(" ",$ttveznev,$ttkernev);
    ##A bejegyzések sorrendjének megfordítása, dátum szerint növekednek.
    @jegydateossz = reverse(split(/,/,$ttelozo));
    ##Az első elem (Aláírva) elhagyása
    @jegydateossz = @jegydateossz[1 .. $#jegydateossz];
    @hanyszor[$sor] = scalar @jegydateossz;
    if($hanyjegy < @hanyszor[$sor]){
	$hanyjegy = @hanyszor[$sor];
    }

##Egy a vizsgák számával (@hanyszor[$sor]) megegyező hosszú for
##ciklussal előállítjuk a dátumok és a jegyek tömbjét.

    $ttjegy = "";
    $ttdate = "";
    if(@hanyszor[$sor] > 0){
	for($i=1; $i <= @hanyszor[$sor]; $i++){
	    ##Jegy kiszedés
	    @jegydate = split(/\(/,@jegydateossz[$i-1]);
 	    $ttjegy = join(" & ",$ttjegy,@jegydate[0]);
	    ##Dátum kiszedés
 	    @predate = split(/-/,@jegydate[1]);
 	    @predate[1] =~ tr/\./-/;
 	    $ttdate = join(" & ",$ttdate,substr(@predate[1], 0, 10));
	}
    }
    @jegy[$sor] = $ttjegy;
    @date[$sor] = $ttdate;
   $sor++;
}

######################################################################
###Jegyek szokásos formátumra alakítása!
######################################################################
foreach (@jegy){
    s/Jeles/jeles (5)/;
    s/Jó/jó (4)/;
    s/Közepes/közepes (3)/;
    s/Elégséges/elégséges (2)/;
    s/Elégtelen/elégtelen (1)/g;
}

######################################################################
###Kiíratás
######################################################################
##Ha kell itt be lehet állítani az üres oszlopokat is nyomtassa ki.
##$hanyjegy = 3;
print "\\begin{longtable}{|l|";
$i = 1;
until ($i > $hanyjegy){
    print "l|";
    $i++
}
print "} \n";
print "\\hline \n";
print "Név és kód & Első vizsga ";
if($hanyjegy >1){
    print "& Második vizsga ";
    if($hanyjegy > 2) {
	print "& Harmadik vizsga ";
    }
}
print "\\\\\n";
print "\\hline \n";
print "\\endhead \n";
print "\\multicolumn{";
print $hanyjegy+1;
print "}{r}{\\emph{folytatás a következő oldalon}} \n";
print "\\endfoot \n";
print "\\endlastfoot \n";

######################################################################
###Kiíratás
######################################################################
for($i=1; $i < scalar @nev; $i++){
    print @nev[$i];
    print @jegy[$i];
    #A táblázat celláinak feltöltése a legtöbb vizsgázóig
    for ( $plus = @hanyszor[$i] ; $plus < $hanyjegy; $plus++){
	print " &";
    }
    print " \\\\\n";
    print @kod[$i];
    ##Dátumot hasonlóan a jegyhez
    print @date[$i];
    for ( $plus = @hanyszor[$i] ; $plus < $hanyjegy; $plus++){
	print " &";
    }
    print " \\\\\n";
    print "\\hline \n";
}

print "\\end{longtable} \n";


close INFILE;
