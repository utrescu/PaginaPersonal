---
title: "Asseure els convidats en una taula en Groovy"
date: 2015-12-13T18:52:27+01:00
categories: [groovy, programació]
tags: ["exercicis"]
draft: false
---
He trobat un problema per Internet que es fa amb una recursivitat clàssica i l'he fet servir per aprendre [Groovy](http://www.groovy-lang.org/).

La idea és asseure els convidats al dinar de Nadal tenint en compte el grau de felicitat que tindran al estar asseguts els uns al costat dels altres.

Per exemple si tenim una entrada com aquesta (el problema estava en anglès...):

    Alice would gain 54 happiness units by sitting next to Bob.
    Alice would lose 79 happiness units by sitting next to Carol.
    Alice would lose 2 happiness units by sitting next to David.
    Bob would gain 83 happiness units by sitting next to Alice.
    Bob would lose 7 happiness units by sitting next to Carol.
    Bob would lose 63 happiness units by sitting next to David.
    Carol would lose 62 happiness units by sitting next to Alice.
    Carol would gain 60 happiness units by sitting next to Bob.
    Carol would gain 55 happiness units by sitting next to David.
    David would gain 46 happiness units by sitting next to Alice.
    David would lose 7 happiness units by sitting next to Bob.
    David would gain 41 happiness units by sitting next to Carol.

S'ha d'aconseguir trobar quina és la màxima felicitat que es pot aconseguir al asseure'ls en una taula circular.

Amb la llista anterior el grau màxim de felicitat és **330**

Resolució del problema
--------------
Primer he de processar el fitxer d'entrada. Ho faig amb una expressió regular per estalviar-me comparacions. Amb cada línia vaig omplint una llista [ ] i un diccionari [:]

```groovy
    def relations = [:]
    def persons = []

    def regex = ~/(.*) would (.*) (\d+) happiness.*to (.*)\./

    new File('input.txt').eachLine { line ->
      def match = regex.matcher(line)
      persons << match[0][1]
      int valor = match[0][3].toInteger()
      if (match[0][2] == "lose") {
        valor *= -1
      }
      relations[match[0][1] + "-" + match[0][4]] = valor
    }
    persons.unique()
```

Al final tindré la llista de persones (*persons*) a la que li he retirat els duplicats (*unique()*) i un diccionari amb les afinitats entre les persones (*relations*).

Després només cal provar totes les combinacions mirant quina és la que dóna la relació més alta. Es comença per cada una de les possibles persones i mira quin és el número més gran aconseguit

```groovy
    println persons.collect {
      calculate(0, persons.minus(it), [it], relations)
    }.max()
```

Calculate no té secrets ja que és un recursiu clàssic: va passant els elements de persons a order fins que no en queda cap i es queda amb el valor aconseguit, recula, prova amb una persona diferent i així successivament fins que ha provat totes les combinacions possibles.

```groovy
    def calculate(valor, persons, order, relations) {
        String last = order[-1]
        if (persons.size() == 0) {
           return valor + relations[last + "-" + order[0]]
                        + relations[order[0] + "-" + last]
        }
        return persons.collect {
            def adding = relations[last + "-" + it]
                         + relations[it + "-" + last]
            calculate(valor + adding, persons.minus(it), order.plus(it), relations)
        }.max()
    }
```

El resultat ja l'havia avançat abans:

    330

