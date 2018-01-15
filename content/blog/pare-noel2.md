---
title: "El pare Noel s'ha trencat una cama"
date: 2015-12-09T17:12:14+01:00
categories: [daw, programació]
tags: ["exercicis"]
draft: false
---
> He preparat una nova tasca sobre lectura de fitxers pels alumnes de DAW M3 - Programació.
>
> Com sempre n'he fet dues versions, una a Google Docs i una al [quadern d'exercicis de FP](https://uf.ctrl-alt-d.net/material/mostra/208/el-pare-noel-sha-trencat-una-cama)


El pare Noel va tenir un problema mentre tornava d’una festa (no se sap exactament què va passar però va tenir problemes amb un ren) i es va trencar una cama.

![Noel](https://raw.githubusercontent.com/utrescu/pyEstira/master/README/noel1.png "Noel")

Per aquest motiu ara no podrà fer el repartiment dels regals de Nadal i han hagut de cercar un substitut. El problema està en que el pare Noel ja es coneix els camins i les rutes que s’havien de fer per fer el repartiment de regals (anys d’experiència) però el substitut no en té ni idea.

No es pot seguir una ruta normal perquè hi ha cases on la gent no s’ha portat bé … Per això els follets li han preparat una llista simple (s’ha d’anar per feina) que indica cap a on ha d’anar a entregar els regals:

Per dir que s’ha d’anar avall es fa servir **v**, per anar a la dreta **>**, per anar amunt **^** i per anar a l’esquerra **>**

O sigui que si tenim `v>>v>^`  visitarà 7 cases:

![7 Visites](https://raw.githubusercontent.com/utrescu/pyEstira/master/README/noel2.png "7 visites")

El problema és que la llista no està gaire optimitzada i a vegades passa dos cops per les mateixes cases (i no s’ha de tornar a repartir els regals)

Activitat
----------------
1. Repartiment de regals. Com que el substitut cobra per casa en la que deixa regals el pare Noel us demana que li feu un programa que digui a quantes cases ha deixat regals el substitut si segueix les instruccions que se li han proporcionat. En quantes cases ha deixat regal?

[Instruccions](https://drive.google.com/file/d/0B1USLpQ7TipGSDlJS3dyVVNnaGc/view?usp=sharing)

A veure com va... ;-)

