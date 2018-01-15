---
title: "Injecció de dependències amb Guice"
categories: [programació, java]
date: 2017-06-01T18:56:17+01:00
tags: ["tutorials"]
draft: false
---
La injecció de dependències és un patró de disseny en el que una classe rep els objectes que necessita ja creats en comptes de crear-los. Es basa en un concepte més genèric anomenat Inversió de Control

> La inversió de control diu, més o menys, que una classe no hauria de crear cap classe estàticament sinó que les hauria de rebre des de fora.

Per tant les classes mai no han de crear els objectes que els hi fan falta (mai faran **new**)

L'objectiu final és aconseguir un dels aspectes fonamentals en programació Orientada a Objectes: **reduïr l'acoblament**

> Que no s'hagi de canviar cap classe perquè un dels objectes que fa servir hagi canviat.

El més corrent és implementar aquest patró a través d'algun tipus d'*injector* que serà el que se n'encarregarà d'injectar els objectes ja creats a qui els necessiti.

![Injector](/images/injector.png)

La injecció de dependències aporta diferents avantatges: millora el manteniment, la flexibilitat i facilita les proves unitaries dels objectes.

### Injecció de dependències en Java

Hi ha diferents formes de fer Injecció de dependències en Java. El framework més "popular" és Spring però n'hi ha d'altres, CDI, Dagger, Google Guice, ... i fins i tot hi ha una especificació oficial (JSR330)

En general la injecció de dependències en Java es sol basar en les *interfícies* ja que permeten independitzar les dependències de la seva implementació.

Google Guice
--------------
Google Guice és un framework d'Injecció de Dependències que es pot fer servir per aplicacions on es volen mantenir les relacions de dependència en el codi de l'aplicació i no en fitxers de configuració externs.

> Caldrà crear una classe en la que s'hi definiran els objectes que volem que gestioni Guice

En l'exemple de sota es pot veure com es fa per definir que es vol injectar una instància de `CotxeDeCarreres` com a substitut dels objectes de tipus `Cotxe`

```java
import com.google.inject.AbstractModule;

public class Configuracio extends AbstractModule {
  @Override
  protected void configure() {

    bind(Cotxe.class).to(CotxeDeCarreres.class);

  }
}
```
En *Guice* les classes a injectar, o els objectes que tinguin dependències que se'ls hi han d'injectar, s'obtenen a partir d'un objecte anomenat **Injector**

```java
Injector injector = Guice.createInjector(new Configuracio());
Cotxe cotxet = injector.getInstance(Cotxe.class);
```
Obtenim un objecte de tipus `Cotxe` (que segons la configuració serà de tipus `CotxeDeCarreres`).

> Al treballar amb interfícies serà senzill canviar la implementació de Cotxe que estem fent servir ara, CotxeDeCarreres, per una altra: *Només caldrà canviar la classe de configuració*

Les classes que es reben de l'injector  rebran automàticament les dependències que tinguin amb l'anotació `@Inject`.

L'anotació `@Inject` es pot posar tant en el constructor, com en un getter o en una propietat.

```java
class CotxeDeCarreres {

  Rodes rodes;

  @Inject
  public CotxeDeCarreres(Rodes r) {
    rodes = r;
  }
}
```

### Llibreria

Per poder fer servir Guice en un programa Java cal tenir la llibreria en el CLASSPATH. El més fàcil sol ser fer servir algun gestor de dependències com Maven o Gradle.

En Maven afegim la dependència al pom.xml:

```xml
<dependency>
    <groupId>com.google.inject</groupId>
    <artifactId>guice</artifactId>
    <version>4.1.0</version>
</dependency>
```
En Gradle és més o menys el mateix:

```
compile group: 'com.google.inject', name: 'guice', version: '4.1.0'
```

Exemple
----------------

El model que es farà servir en l'exemple seran "noms de persona" que codificaré en Strings.

### Crear els objectes que s'injectaran

#### Crear una interfície

Primer es defineix una interfície amb les operacions que es faran en el repositori.

En aquest cas la interfície  proporciona un mecanisme amb dos mètodes:

* Un per afegir noms de persona a una font de dades
* Un per saber quantes persones hi ha emmagatzemades

```java
public interface RepositoriPersones {

  int quantesPersonesHiHa();
  void afegirPersona(String nom);

}
```

#### Implementar la interfíce

Es desenvolupa un objecte que implementa la interfície de manera que els noms s'emmagatzemaran en memòria:

```java
public class RepositoriPersonesMemory implements RepositoriPersones {
   List<String> llistaPersones;
   llistaPersones = new ArrayList<>(Arrays.asList("Pere", "Manel"));

   public int quantesPersonesHiHa() {
     return llistaPersones.size();
   }

   public void afegirPersona(String nom) {
     llistaPersones.add(nom);
   }
}
```

Es poden tenir diferents implementacions de la interfície i carregar-les segons la configuració que fem

### Crear l'objecte configuració

En la classe de configuració s'hi defineixen quins són els objectes que es podran injectar.

La classe de configuració ha de ser descendent de Module (normalment serà AbstractModule) i per tant està obligada a implementar-ne el mètode `configure()`

* En el mètode `configure()` s'hi defineixen quins tipus d'objectes són els que s'han d'injectar i la implementació que es fa servir:

```java
public class GuiceConf extends AbstractModule {
  @Override
  protected void configure() {

    bind(RepositoriPersones.class).to(RepositoriPersonesMemory.class);

  }

}
```

Hi ha altres formes de definir-ho, com per exemple crear-lo manualment:

```java
bind(RepositoriPersones.class).to(new RepositoriPersonesMemory.class)
```

#### Injectar dependències en una classe

L'objecte `GestorNoms` es fa servir per demostrar com s'injecten automàticament les dependències dels objectes obtinguts de l'Injector. En aquest cas se li injectarà una instància de `RepositoriPersones`:

```java
public GestorNoms {
  RepositoriPersones repo;

  @Inject
  public GestorNoms(RepositoriPersones repo) {
    this.repo = repo;
  }

  public run() {
    System.out.println(repo.quantesPersonesHiHa());
  }
}
```

### Programa principal

Per fer el programa principal només hem de fer que s'arranqui *Guice* creant un `Injector` al que li donem la classe de configuració.

```java
public static void main(String[] args) {

  Injector injector = Guice.createInjector(new GuiceConf());
  ...
}
```

A partir d'aquest injector es poden obtenir les classes injectades i executar-ne els mètodes

```java
RepositoriPersones repositori;
repositori = injector.getInstance(RepositoriPersones.class);

System.out.println(repo.quantesPersonesHiHa());
repo.afegirPersona("Frederic");
System.out.println(repo.quantesPersonesHiHa());
```

El mateix es pot fer amb la classe `GestorNoms`:

```java
GestorDeNoms noms = injector.getInstance(GestorDeNoms.class);
noms.run();
```

Si s'executen un rere l'altre es veurà que Guice ha creat un objecte diferent cada vegada que injecta un objecte nou. Al executar això:

```java
RepositoriPersones repositori;

repositori = injector.getInstance(RepositoriPersones.class);
System.out.println(repositori.quantesPersonesHiHa());
repositori.afegirPersona("Frederic");
System.out.println(repositori.quantesPersonesHiHa());

System.out.println("------- GestorDeNoms -------");
GestorDeNoms noms = injector.getInstance(GestorDeNoms.class);
noms.run();
```

El repositori de GestorDeNoms donarà **2**. Com que a l'altre hi hem afegit un element: estem en un repositori diferent!

```
2
3
------- GestorDeNoms -------
2
```

Es pot aconseguir que cada vegada que s'injecti sigui el mateix objecte anotant la implementació amb `@Singleton`:

```java
@Singleton
public class RepositoriPersonesMemory implements RepositoriPersones{
    ...
}
```

Amb només aquest canvi es pot veure que tot i injectar-lo dues vegades l'objecte que s'aconsegeix és sempre el mateix:

```
2
3
------- GestorDeNoms -------
3
```

# Codi de l'exemple

Es pot trobar el codi d'exemple en el meu [repositori de Github](https://github.com/utrescu/GuiceExemple)
