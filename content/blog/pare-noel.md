---
title: "El pare Noel al món ASCII"
date: 2015-12-09T16:05:29+01:00
categories: [daw, programació]
tags: ["exercicis"]
draft: false
---

>He preparat una tasca sobre lectura de fitxers pels alumnes de DAW3.
>
> Com sempre n'he fet dues versions, una a Google Docs i una al [quadern d'exercicis de FP](https://uf.ctrl-alt-d.net/material/mostra/209/el-pare-noel-al-mon-ascii)

Molta gent desconeix que el pare Noel també reparteix regals en el món ASCII.  El món ASCII es un món en que els gràfics es formen a partir de caràcters ASCII.

![El pare Noel!](https://raw.githubusercontent.com/utrescu/pyEstira/master/README/noel3.png "El pare Noel en el món ASCII")

En aquest món quan es fan fotografies les cases són representades per línies de caràcters: Això és una fotografia de quatre cases

    [0]-=-=****=][=========
    ]-=-=****=][=*****=**=*![---!000
    =*0-!
    -=-0-oOo|=--=||++=++=++=>

Una bonica tradició que tenen els habitants d'aquest món consisteix és fer fotografies del pare Noel i els seus ajudants quan els visiten (es mouen tant de pressa que solen sortir en més d’una casa alhora)

- El pare Noel en ASCII té aquesta forma: `*<]:-DOo`
- Els rens del pare Noel aquesta: `>:o)`
- I els follets ajudants aquesta: `<]:-D`

Durant el dia de Nadal de l’any passat en un poble van fer aquesta fotografia:

    [0]-=-=*<]:-DOo=========
    ]-=-*<]:-DOo--**][=>:o)*=*0-!*<]:-DOo**=
    -=-0-o<]:Oo|=--=||++=++=++=>
    ==|<]:-D

En la fotografia es pot veure que la primera casa va ser visitada pel pare Noel, mentre que la segona va ser visitada per un ren i pel pare Noel dues vegades. La tercera casa no va rebre visites (perquè es van portar malament), i la quarta va rebre a un ajudant

Exercici
-------------------
1. Se us demana que feu un programa que digui qui ha visitat cada casa (i quantes vegades)

Per exemple, això:

    [0]-=-=*<]:-DOo##=========
    ]-=-*<]:-DOo--*=][=>:o)*=**<]:-DOo0-!...
    -=-0-o<]:Oo|=--=||++=++=++=>
    ==|<]:-D

Donarà:

    Pare Noel (1)
    Pare Noel (2), Ren (1)
    -
    Follet (1)


A veure com va... ;-)

