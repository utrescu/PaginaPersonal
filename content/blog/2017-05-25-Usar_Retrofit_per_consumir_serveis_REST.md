---
title: "Usar Retrofit2 per consumir serveis REST"
categories: [programació, java]
date: 2017-05-25T18:56:17+01:00
tags: ["tutorials"]
draft: false
---
[Retrofit](http://square.github.io/retrofit/) és una llibreria de Java que es fa servir per consumir serveis REST de qualsevol tipus: JSON, XML, Protobuff, etc...

La idea de Retrofit és que no cal que ens preocupem de tot el que fa referència a les peticions per la xarxa, ni de construir els objectes, .. Només cal cridar els mètodes correctes i ell se n'encarregarà de la resta.

A més se n'encarregarà de convertir les dades rebudes en objectes Java. Per exemple si ens arriba un objecte com aquest:

```json
{"id":71,"nom":"Vermell","rgb":"#FF0000"}
```
Es pot mapejar en un objecte com aquest (he tret els getters i setters per fer la classe més senzilla)

```java
class Color {
    int id;
    String nom;
    String rgb;
}
```

Exemple d'ús
-----------------------
Volem consumir un servei REST que està a [http://colors-rgb.herokuapp.com]("http://colors-rgb.herokuapp.com") i que proporciona dos mètodes a través de GET:

| mètode          | resultat   |
| --------------- | ---------- |
| /color/nom      | Retorna les dades del color especificat a *nom* en format JSON. Per exemple la URL "/color/verd" donarà les dades del color verd. |
| /colors        | Llista tots els colors del servei |

### Afegir les llibreries
Per poder funcionar caldrà tenir la llibreria Retrofit2 en el CLASSPATH. Es pot fer descarregant les llibreries o bé a través d'un gestor de projectes.

Per mi, la forma més senzilla és definir-la en un gestor de projectes Maven o Gradle. En Maven fem una cosa com aquesta:

```xml
<dependency>
    <groupId>com.squareup.retrofit2</groupId>
    <artifactId>retrofit</artifactId>
    <version>2.3.0</version>
</dependency>
```
I en Gradle:

```
compile 'com.squareup.retrofit2:retrofit:2.0.2'
```
Si el que consumim no és HTML també farà falta afegir quin **conversor** es vol fer servir. En Retrofit hi ha diferents conversors predefinits:

* **Gson**: com.squareup.retrofit2:converter-gson
* **Jackson**: com.squareup.retrofit2:converter-jackson
* **Moshi**: com.squareup.retrofit2:converter-moshi
* **Protobuf**: com.squareup.retrofit2:converter-protobuf
* **Wire**: com.squareup.retrofit2:converter-wire
* **Simple XML**: com.squareup.retrofit2:converter-simplexml
* **Scalars (dades primitives i les seves classe, i Strings)**: com.squareup.retrofit2:converter-scalars

També se'n poden crear de personalitzats (però és una mica més complexe)

Per tant podem fer servir Gson o Jackson per consumir JSON. En el meu cas trio Jackson:

```xml
<dependency>
   <groupId>com.squareup.retrofit2</groupId>
   <artifactId>converter-jackson</artifactId>
   <version>2.3.0</version>
</dependency>
```

### Crear els models

En aquest cas el model de dades bàsic és senzill. Només cal crear un objecte *Color* (Jackson necessita *getters* i *setters*):

```java
public class Color {
   int id;
   String nom;
   String rgb;

   public int getId() {
     return id;
   }

   public void setId(int id) {
     this.id = id;
   }

   public String getNom() {
     return nom;
   }

   public void setNom(String nom) {
     this.nom = nom;
   }

   public String getRgb() {
     return rgb;
   }

   public void setRgb(String rgb) {
     this.rgb = rgb;
   }
```

En general el model es crea seguint les normes del conversor que es farà servir.

Si es fa servir Jackson com a conversor al definir el model es poden fer servir qualsevol de les anotacions de Jackson:

```java
@JsonIgnoreProperties({"nomEnCastella"})
@JsonIgnoreProperties(ignoreUnknown=true)
public class Color {
	public int id;
    public String nom;
	public String nomEnCastella;
	public String rgb;
}
```

### Definir el servei

Per consumir el servei cal definir en una interfície quins són els mètodes de l'API que es faran servir:

```java
import net.xaviersala.model.Color;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Path;

public interface ColorsRestService {

	@GET("color/{color}")
	Call<Color> getColor(@Path("color") String color);

  @Get("color") Call<Color> getColor(@Query("nom") String nom))

	@GET("/colors")
	Call<List<Color>> getColors();

	@Post("/color/crear")
	Call<Color> crearColor(@Body Color nou);
}
```
Com es pot veure, amb Retrofit 2 sempre es retorna un objecte parametritzat en **`Call<T>`**. Bàsicament això és així per poder cridar els mètodes tant de forma síncrona com asíncrona.

Es defineixen amb anotacions els diferents mètodes HTTP: (GET, POST, DELETE, ...), els paràmetres variables **@Path**, els paràmetres amb **@Query**, el cos del missatge amb **@Body**, a més d'altres anotacions sobre com funciona la petició **@FormUrlEncoded**, **@Multipart**, **@Headers**, **Field**, etc..

Aquí hi poso uns exemples diversos que no tenen a veure amb l'exemple

```java
@FormUrlEncoded
@POST("/afegir/color")
Call<Color> formulariColors(@Field("nom") String nom);
```

### Usar-lo

El programa principal ha de construir un objecte Retrofit, en el que se li pot definir la URL, el conversor que es farà servir, ... :

```java
Retrofit retrofit = new Retrofit.Builder()
  .baseUrl("http://colors-rgb.herokuapp.com")
  .addConverterFactory(JacksonConverterFactory.create())
  .build();
```
A partir de l'objecte Retrofit es crea el servei a partir de la interfície que hem definit abans:

```java
ColorsRestService service = retrofit.create(ColorsRestService.class);
```

#### Crida síncrona
Es poden fer crides a l'API de forma síncrona o asíncrona. El mètode síncron és el més senzill. Les crides síncrones es fan amb el mètode **execute()**.

```java
Call<Color> crida =  service.getColor("vermell");
Color color = response.execute().body();
```
També es pot recollir la resposta en un objecte *`Response<T>`* de manera que es podran comprovar altres coses sobre la resposta:

```java
Response<Color> resposta = service.getColor("vermell").execute();
if (response.code == 200) {
    Color color = response.body();
}
```

#### Crida asíncrona

Per fer una petició asíncrona caldrà definir els mètodes *`onResponse()`* i *`onFailure()`* en un Callback i fer servir **enqueue()** en comptes d'**execute()** per fer la crida:

```java
Call<Color> call = apiService.getColor("vermell");
call.enqueue(new Callback<Color>() {
    @Override
    public void onResponse(Call<Color> call, Response<Color> response) {
        int statusCode = response.code();
        Color user = response.body();
    }

    @Override
    public void onFailure(Call<Color> call, Throwable t) {
        // error!
    }
});
```

### Projecte GitHub

He fet un projecte a GitHub que fa servir Retrofit2 i que és una mica més elaborat del que he explicat aquí: [Exemple](https://github.com/utrescu/RetrofitColors)
