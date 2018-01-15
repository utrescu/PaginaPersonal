---
title: "Captures de pantalla de dispositius Android"
categories: [android]
date: 2018-01-03T18:56:17+01:00
tags: ["recorda"]
draft: false
---
He estat fent proves sobre com fer aplicacions per Android amb Nativescript.

> Nativescript és un framework de codi obert que serveix per desenvolupar aplicacions per Android i iOS. Les aplicacions en Nativescript es desenvolupen en Javascript o Typescript i suporta directament Angular i Vue.js (en un plugin de la comunitat). Tot i que el programa està en Javascript pot interactuar directament amb les API i els controls nadius del sistema operatiu.


A l'hora de fer el README.md de Github he trobat que estaria bé fer unes captures de pantalla de l'aplicació executant-se.

Per això he punxat el dispositiu al portàtil i he fet les captures amb `adb` (reconec que ho tenia anotat):

    $ adb shell screencap -p /sdcard/pantalla.png
    $ adb pull /sdcard/pantalla.png
    $ adb shell rm /sdcard/pantalla.png

O sigui, primer fer la captura, després la transfereixo a l'ordinador i després l'esborro.

Quan n'he fet un parell ja n'estava cansat d'escriure tant i la meva reacció natural ha estat fer un script de Bash, però ... Segur que aquest és el millor sistema? Cal desar la captura al dispositiu per després esborrar-la?

O sigui que incomplint aquella regla bàsica de l'informàtica que diu, `"Quan tota la resta falli, llegeix el manual"`, m'he posat a mirar la documentació de Google i he descobert que sóc burro.

Es pot fer una captura de pantalla i transferir-la a l'ordinador en una sola comanda:

    $ adb exec-out screencap -p > captura.png

Au, per vergonya meva ho deixo aquí per no haver-ho de buscar més.