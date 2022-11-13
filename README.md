# TP1 projet Microprocesseur _(16 novembre 2022)_
Simulateur de net-list sur la base de [ce dépôt](https://github.com/hbens/sysnum-2022/tree/master/tp1).

## Quickstart
Cloner le dépôt et lancer `make` afin de lancer le simulateur sur le test `test/fulladder.net`. Dune et ocaml sont nécessaires au bon fonctionnnement du simulateur. Pour lancer le simulateur sur d'autres fichiers, ajoutez la variable `file=<fichier>` sans préciser l'extension `.net` et ce fichier test sera simulé. Une liste des tous les fichiers disponible est disponible en lançant `make list`. La variable `n=<entier positif>` permet de contrôler le nombre de cycles sur lesquels le simulateur s'exécutera. Par exemple la commande : 
```bash
$ make file=ram n=2
```
lance le simulateur sur le programme `test/ram.net` pour 2 cycles puis s'arrête.
