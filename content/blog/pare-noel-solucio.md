---
title: "Resolució El pare Noel al món ASCII"
date: 2015-12-26T18:59:06+01:00
categories: [daw, programació]
draft: false
---
La majoria dels alumnes han optat per anar llegint les cadenes una a una i després cercar-ne les vegades que surt cada personatge amb *indexOf*.

Això els ha portat al "problema" de que el Pare Noel també és un follet (i els ha costat molt descobrir que només calia restar...)

Però hi ha una solució més elegant fent servir expressions regulars

```java
    public class App {
        private static final String PARE_NOEL = "Pare Noel";
        private static final String REN_NOM = "Ren";
        private static final String FOLLET_NOM = "Follet";
        private static final String PARE = "\\*<]:-DOo";
        private static final String REN = ">:o\\)";
        private static final String FOLLET = "[^\\*]<]:-D";

        public static void main(String[] args) throws IOException {
            String linea;

            BufferedReader db = new BufferedReader(
                    new InputStreamReader(App.class.getResource("/foto.txt").openStream()));

            while ((linea = db.readLine()) != null) {

                Busca(PARE, linea, PARE_NOEL);
                Busca(REN, linea, REN_NOM);
                Busca(FOLLET, linea, FOLLET_NOM);
                System.out.println("");

            }
        }

        private static void Busca(String pat, String linia, String text) {
            Pattern p = Pattern.compile(pat);
            Matcher m = p.matcher(linia);
            int count = 0;

            while (m.find()) {
                count++;
            }
            if (count != 0) {
                System.out.print(text + "(" + count + ") ");
            }
        }
    }
```

Es pot obtenir el codi en Maven a [Bitbucket](https://bitbucket.org/francesc_xavier_sala_pujolar/asciinoel/src)

