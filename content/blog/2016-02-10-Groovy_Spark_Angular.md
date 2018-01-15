---
layout: post
title: "Fent servir Groovy, SparkJava i Angular"
categories: [web, programació, groovy]
date: 2016-02-10T18:56:17+01:00
draft: false
---
He creat un projecte per provar [AngularJS](https://angularjs.org/) amb [Spark Java](http://sparkjava.com/) fent servir [Groovy](http://www.groovy-lang.org/).

Bàsicament es tracta d'una aplicació web per treure noms de persona per pantalla

Iniciar el projecte
-----------------------
El projecte està en Gradle i té una tasca per iniciar-lo:

    gradle runScript

El servidor proporciona una interfície REST que permet llistar les persones entrades en el sistema i crear-ne de noves:

Des de la consola es pot provar amb cUrl o Httpie.

### Persones en el sistema
Per veure les persones del sistema s'accedeix a través de GET a ```http://localhost:4567/persona```

Fent una petició Httpie:

    $ http http://localhost:4567/persona

```http
HTTP/1.1 200 OK
Content-Type: application/json
Date: Wed, 10 Feb 2016 16:02:29 GMT
Server: Jetty(9.3.2.v20150730)
Transfer-Encoding: chunked

[
  {
    "cognom": "Sala",
    "id": 0,
    "nom": "Xavier"
  },
  {
    "cognom": "Puig",
    "id": 1,
    "nom": "Lluis"
  }
]
```

### Llistar una persona pel seu id
Es poden llistar les persones a partir del seu ``id`` amb un GET a ``http://localhost:4567/persona/1``

Executant la petició amb Httpie:

    $ http http://localhost:4567/persona/1

```http
HTTP/1.1 200 OK
Content-Type: application/json
Date: Wed, 10 Feb 2016 16:03:56 GMT
Server: Jetty(9.3.2.v20150730)
Transfer-Encoding: chunked

{
  "cognom": "Puig",
  "id": 1,
  "nom": "Lluis"
}
```

En cas de que la persona no existeixi es rebrà un missatge d'error:

    $ http http://localhost:4567/persona/2

```http
HTTP/1.1 200 OK
Content-Type: application/json
Date: Wed, 10 Feb 2016 16:03:51 GMT
Server: Jetty(9.3.2.v20150730)
Transfer-Encoding: chunked

{
  "error": "not found"
}
```

### Afegir una nova persona
Per afegir persones noves només cal enviar un POST a la url 'http://localhost:4567/persona' amb el nom i cognom en format JSON en les dades

```json
{ "cognom": "Boix", "nom": "Manel" }
```
La resposta serà un fitxer JSON amb el nom, cognom i l'ID

Per exemple si enviem un POST amb HTTPie amb "Manel Boix"

    $ http http://localhost:4567/persona nom='Manel' cognom='Boix' --json

Es rebrà un JSON amb el nou registre:

```http
HTTP/1.1 200 OK
Content-Type: application/json
Date: Wed, 10 Feb 2016 16:09:05 GMT
Server: Jetty(9.3.2.v20150730)
Transfer-Encoding: chunked

{
  "cognom": "Boix",
  "id": 2,
  "nom": "Manel"
}
```

Angular
-----------------
Per accedir a la web amb Angular només s'ha de visitar l'adreça http://localhost:4567 (no és cap meravella del disseny)

![web](https://github.com/utrescu/Groovy-Spark-Angular/raw/master/images/web.png)

Per crear noves persones només s'ha de clicar a l'enllaç i omplir el formulari

![crear](https://github.com/utrescu/Groovy-Spark-Angular/raw/master/images/crear.png)

i la nova persona s'afegirà a la llista ..

![resultat](https://github.com/utrescu/Groovy-Spark-Angular/raw/master/images/web2.png)

Si es mira el codi font tot el codi Angular està en el fitxer App.js en el directory ```scripts```:

```javascript
var app = angular.module('personesapp', [
'ngCookies',
'ngResource',
'ngSanitize',
'ngRoute'
]);

app.config(function ($routeProvider) {
  $routeProvider.when('/', {
    templateUrl: 'views/list.html',
    controller: 'ListCtrl'
  }).when('/create', {
    templateUrl: 'views/create.html',
    controller: 'CreateCtrl'
  }).otherwise({
    redirectTo: '/'
  })
});
```

Hi ha dos controladors, un per mostrar la llista:

```javascript
app.controller('ListCtrl', function ($scope, $http) {
  $http.get('/persona').success(function (data) {
    $scope.persones = data;
  }).error(function (data, status) {
    console.log('Error ' + data)
  })
});
```

I un per crear una nova entrada:

```javascript
app.controller('CreateCtrl', function ($scope, $http, $location) {
  $scope.persona = {
    nom: '',
    cognom: ''
  };

  $scope.createPerson = function () {
    console.log($scope.persona);
    $http.post('/persona/', $scope.persona).success(function (data) {
      $location.path('/');
    }).error(function (data, status) {
      console.log('Error ' + data)
    })
  }
});
```

O sigui que només és una prova per veure si podia usar Angular des d'Spark fent servir Groovy. Es pot :-)
