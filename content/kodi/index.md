---
layout: simple
title: KODI Addons
---
## Waarom

Omdat ik had besloten de “kabel” eruit “te gooien”, omdat ik geen zin meer had in betaald reclame te kijken en alles was van het zelfde op t.v. Netflix kwam toen net in Nederland en ik dacht: “Ik doe het gewoon, ik gooi de kabel er uit”. Ik had een “Smart” TV welke RTL-XL en NPO uitzendingen terug kon kijken (zonder reclame) en film van Netflix. Prima. Google Chromecast + Kodi op een Raspberry Pi. Alles opgelost dacht ik.

Helaas 2 maanden nadat ik mijn kabel opzeg, veranderd de “API” van RTL-XL en weer 4 maanden later die van NPO. Kortom, ik kon dit niet meer kijken op mijn “Smart” TV.

## Oplossing

Kodi gebruikte ik al jaren voor mijn series en films te kijken (legaal! ik heb de DVD’s/Blu-Ray’s in de kast staan). Na het opzeggen van de kabel had ik ook tvheadend met een dvb-t USB ontvanger geconfigureerd met Kodi. Zodat ik in het hele huis Nederland 1/2/3 en TV Gelderland kon kijken. Ik kan vanuit mijn werk uit aardig programmeren, dus het lag nu voor de hand om een add-on te maken in Kodi voor NPO en RTL-XL. Beide add-ons aangemeld bij Kodi en ze zijn jaren lang een “Officiële” addon geweest, deze was dus te downloaden uit de repository van Kodi zelf.

## Uitwerking

Hoe start je nu zo iets? Het was vroeger wat meer zoek werk, maar je kan het allemaal vinden op de wiki pagina van Kodi, nu hebben ze erg goede uitlegt hoe je moet beginnen. Nu dus de taal python nog even leren (lees google elke actie welke je wil doen) en achterhalen hoe je video’s ophaalt bij NPO. Dat laatste ging vroeger erg makkelijk, dat deed je als volgend:

Zet een “Zed Attack Proxy” op je pc
Stel het juiste IP-Adres in (van je locale netwerk) “ZAP > Tools > Options > Local Proxies”
Op een Android telefoon (emulator of echte), zet je de NPO App er op.
Zorg ervoor dat je telefoon via de proxy loop (Ga naar “advanced options” van je Wifi connection) of je emulator opstart met “-http-proxy http://xx.xxx.xx.xx:8080”
Klaar! Als je verkeer loopt nu via je pc, je ziet alle aanvragen van de app. Alles ging over http, hier kon je zien hoe de “API” werkte en deze “op de zelfde manier” toepassen in python. Je moest alleen even aansluiten om de “API” van Kodi en klaar. Dit klinkt natuurlijk makkelijker dan het is, maar daar komt het in het kort wel op neer. Dit alles is gemaakt november 2013 t/m januari 2014. De code aangeboden aan Kodi met een pull request en na wat kleine aanpassingen geaccepteerd!

## Mijn addons

[NPO](/kodi/npo)

[RTLxl](/kodi/rtlxl)

[Kanalenlijst Hans](/kodi/kanalenlijst-hans)
