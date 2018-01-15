---
title: "Convertir vídeos a GIF animats"
date: 2018-01-06T18:56:17+01:00
categories: [utils, android]
tags: ["recorda"]
draft: false
---
Ara tothom fa gifs animats dels programes que desenvolupa i els posa al repositori de GitHub. (sembla que això fa que això et converteix en un desenvolupador que "mola")

Com que jo també vull "molar", he decidit fer un GIF animat del darrer programa que vaig fer en Android fent servir Nativescript.

## Capturar el vídeo d'Android

El primer és aconseguir el vídeo. Per gravar la pantalla d'un dispositiu Android n'hi ha prou amb endollar el dispositiu a l'USB i executar (si tens l'SDK instal·lat):

    $ adb shell screenrecord  /sdcard/millor.mp4
    $ adb pull /sdcard/millor.mp4

## Convertir el vídeo a GIF

He provat moltes formes de convertir aquest vídeo a gif. Per exemple `convert` d'Imagemagik consumia molta CPU i el resultat no era gaire correcte ...

    $ convert millor.mp4 millor.gif

La que m'ha consumit menys memòria i CPU ha estat fer servir `ffmpeg`:

    $ ffmpeg -i millor.mp4 -vf scale=320:-1 -r 10 -f image2pipe -vcodec ppm - | \\n  convert -delay 5 -loop 0 - millor.gif

El resultat ha estat una mica gran per les meves espectatives:

    $ ls -hal millor.*
    -rw-rw-r--. 1 xavier xavier  11M  6 gen 01:52 millor.gif
    -rw-r--r--. 1 xavier xavier  13M  6 gen 01:44 millor.mp4


## Optimitzar el GIF
O sigui que s'ha d'optimitzar el GIF per  reduir-ne la mida. A cercar optimitzadors ...

L'optimitzador que m'ha anat millor en Linux ha estat `gifsicle` amb la optimització 3:

    $ gifsicle -i millor.gif -O3 --colors=256 -o millor-nou.gif

El resultat encara ha estat una mica massa gran:

    $ ls -hal millor.*
    -rw-rw-r--. 1 xavier xavier  11M  6 gen 01:52 millor.gif
    -rw-r--r--. 1 xavier xavier  13M  6 gen 01:44 millor.mp4
    -rw-rw-r--. 1 xavier xavier 4,5M  6 gen 12:12 millor-nou.gif

## Fer-lo encara més petit

Per fer que ocupi menys he de reduir alguna cosa:

1. Reduir el número de colors --colors=128
2. Reduir la mida de la imatge --scale 0.75
3. Fer les dues coses :-)

Per tant provo totes les opcions, només escalar:

    $ gifsicle -i millor.gif --scale 0.75 -O3 --colors=256 -o millor-r.gif

I escalar i reduir els colors:

    $ gifsicle -i millor.gif --scale 0.75 -O3 --colors=128 -o millor-re.gif

Evidentment escalar i reduir els colors dóna un millor resultat tot i que en algun punt la imatge perd una mica de qualitat:

    $ ls -all *.gif -h
    -rw-rw-r--. 1 xavier xavier 2,4M  6 gen 02:04 millor-r.gif
    -rw-rw-r--. 1 xavier xavier 2,0M  6 gen 02:05 millor-re.gif
    -rw-rw-r--. 1 xavier xavier  11M  6 gen 01:52 millor.gif

El resultat ha estat aquest:

![Resultat](https://raw.githubusercontent.com/utrescu/ElMillorMenjar/master/readme/millor.gif)

Ja sóc un desenvolupador "molón"!


