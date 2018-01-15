---
title: "Solució al repartidor de subvencions"
date: 2015-12-27T19:05:03+01:00
categories: [daw, programació, groovy]
tags: ["exercicis"]
draft: false
---
He decidit provar com es pot resoldre el problema de [repartir subvencions](http://blog.utrescu.cat/Repartidor%20de%20subvencions/) en Groovy i realment la quantitat de línies és molt menor que en Java ...

Faig servir una expressió regular inicial per separar el nom del nen, que no interessa per res, i la resta ho faig com els alumnes ho intenten fer tot (amb split)

```groovy
    def regex = ~/^([^:]+): (.*)/
```

Després només cal separar els personatges entre ells a partir del guió (-):

```groovy
    def quiRegala = regals.split(" - ").
```

Per cada línia miro quin personatge li ha portat regals i l'incremento la quantitat de regals (en el mapa *personatges*). Per comptar els regals només cal comptar les comes :-)

```groovy
    int numregals = ((personatge[1] =~ /,/).count) + 1
```
Queda una cosa com aquesta:

```groovy
    def regex = ~/^([^:]+): (.*)/
    def personatges = [:]

    int totalRegals = 0

    new File('subvencions4.txt').eachLine { line ->
      (line =~ regex).each { tot2, nen, regals ->
        def quiRegala = regals.split(" - ").each {
          def personatge = it.split(":")

          def nom = personatge[0]
          int numregals = ((personatge[1] =~ /,/).count) + 1

          if (!personatges.containsKey(nom)) {
            personatges[nom] = numregals
            } else {
              personatges[nom] += numregals
            }
            totalRegals += numregals
          }
        }
      }

      println personatges
      personatges.each { println "${it.key} : ${it.value/totalRegals*100}" }
```

M'encanta la idea dels closures de [Groovy](http://www.groovy-lang.org/) i la senzillesa en el tractament de llistes i mapes que proporciona
