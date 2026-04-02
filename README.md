# EVM Decompilers Tests

Ce dépôt rassemble un corpus de **tests de décompilation de bytecode EVM** conçu dans le cadre d’un **stage de recherche au Laboratoire Méthodes Formelles (LMF)** autour de la **décompilation de bytecode EVM**.

L’objectif est de comparer plusieurs **décompilateurs de l’état de l’art** sur des contrats Solidity compilés avec différentes versions du compilateur, afin d’évaluer leur capacité à reconstruire une représentation exploitable du programme source à partir du bytecode EVM.

Cette étape s’inscrit dans une démarche plus large d’analyse de contrats intelligents déployés sur Ethereum, notamment pour étudier des comportements complexes comme :
- l’analyse de mécanismes économiques on-chain, par exemple certaines **stratégies d’arbitrage**.

---

## Objectif du dépôt

Ce dépôt sert de **banc de tests** pour observer comment différents décompilateurs se comportent face à plusieurs dimensions importantes de la compilation Solidity vers EVM :

- évolution du bytecode selon la **version de Solidity** ;
- restitution des **structures de contrôle** ;
- restitution des **structures de données** et du stockage ;
- détection des **fonctions internes** ;
- prise en charge de l’**inline assembly / Yul** ;
- comportement sur des exemples synthétiques et sur des **contrats plus réalistes**.

L’idée n’est pas uniquement de vérifier si un outil “produit une sortie”, mais surtout d’évaluer :
- la lisibilité de la décompilation ;
- la fidélité sémantique au contrat source ;
- la qualité de reconstruction des fonctions, variables, accès mémoire et accès stockage ;
- la robustesse face à des patterns EVM connus comme difficiles.

---

## Décompilateurs évalués

Les sorties actuellement présentes dans le dépôt montrent des essais réalisés avec plusieurs outils, selon les cas :

- **Gigahorse**
- **Heimdall**
- **Panoramix**
- **SolDec**

> Remarque : tous les outils ne produisent pas nécessairement une sortie exploitable pour tous les tests. L’absence d’un fichier `.decompiled` pour un outil donné signifie simplement qu’aucun résultat n’est présent dans ce dossier pour ce cas de test.

---

## Organisation du dépôt

Le dépôt est organisé par **thème de test**, puis par **version du compilateur Solidity**.

Structure générale :

```text
.
├── <theme>/
│   ├── <solc-version>/
│   │   ├── source.sol
│   │   ├── CFG.svg
│   │   ├── gigahorse.decompiled      # si disponible
│   │   ├── heimdall.decompiled       # si disponible
│   │   ├── panoramix.decompiled      # si disponible
│   │   └── soldec.decompiled         # si disponible
```

### Contenu d’un dossier de test

Chaque dossier de version contient généralement :

- `source.sol` : le contrat Solidity source utilisé comme référence ;
- `CFG.svg` : le **graphe de flot de contrôle** du bytecode EVM correspondant ;
- `*.decompiled` : la sortie textuelle du décompilateur testé.

Ce triplet permet de confronter :
1. le **source de référence** ;
2. la **structure réelle du bytecode** via le CFG ;
3. la **reconstruction produite** par le décompilateur.

---

## Familles de tests présentes

### `ERC20/`
Tests autour d’un contrat de type **ERC-20** pour observer la restitution de patterns classiques :
- mappings de soldes et d’allowances ;
- fonctions standards (`transfer`, `approve`, `transferFrom`, etc.) ;
- événements ;
- variables d’état simples et métadonnées du token.

Ce thème permet de voir comment les outils gèrent un contrat standard, fréquent et relativement structuré.

### `ERC20/ER20_factory/`
Variante orientée **déploiement / factory** autour d’un cas ERC20, utile pour observer l’impact de différentes versions de compilateur sur des patterns proches d’un cas d’usage plus applicatif.

### `data_structures/`
Tests centrés sur les **structures de données complexes**, notamment :
- `struct` ;
- tableaux dynamiques ;
- `mapping` imbriqués ;
- `bytes` ;
- stockage composite.

Ces cas sont importants pour évaluer la capacité des outils à retrouver la logique d’accès au stockage et la structure des données.

### `flow_structures/`
Tests centrés sur la restitution des **structures de contrôle** :
- `if / else` ;
- conditions imbriquées ;
- boucles `for`, `while`, `do while` ;
- `break` / `continue`.

Ce thème est particulièrement utile pour comparer la qualité de reconstruction d’un flot de contrôle haut niveau à partir d’un CFG EVM souvent plus bas niveau et fragmenté.

### `inline_assembly/`
Tests avec **inline assembly / Yul**, afin d’évaluer la robustesse des outils face à des constructions bas niveau comme :
- `sstore` / `sload` ;
- opérations arithmétiques explicites ;
- boucles écrites en assembly ;
- appels de bas niveau (`staticcall`) ;
- manipulation mémoire.

Ces cas sont parmi les plus difficiles pour les décompilateurs, car ils s’éloignent fortement des patterns Solidity classiques.

### `internal_calls/`
Tests conçus pour analyser la capacité des outils à **retrouver des fonctions internes** et leur rôle :
- détection de frontières de fonctions ;
- propagation de valeurs ;
- reconstruction de petits appels utilitaires internes ;
- distinction entre logique externe et logique factorisée en interne.

### `giga_func_detect/`
Cas ciblés pour étudier plus finement la **détection de fonctions** et la sensibilité d’un outil à de petites variations de structure source.

### `uniswapV2/`
Cas plus réaliste reposant sur un contrat de type **Uniswap V2 Pair**, utile pour observer le comportement des outils sur un contrat nettement plus riche :
- logique métier plus dense ;
- état global non trivial ;
- invariants ;
- appels internes et patterns DeFi classiques.

Cette catégorie permet de sortir des micro-benchmarks et d’approcher des contrats proches de ceux analysés en pratique sur Ethereum.

---

## Versions de compilateur couvertes

Le dépôt contient actuellement des tests compilés avec plusieurs versions de Solidity, notamment :

- `0.4.18`
- `0.5.0`
- `0.5.16`
- `0.7.0`
- `0.8.0`

Le choix de plusieurs versions permet de mesurer l’impact des changements de compilation sur la forme du bytecode et, par conséquent, sur la qualité de la décompilation.

---

## Comment lire les résultats

Pour un thème donné, l’analyse peut se faire de la manière suivante :

1. **Lire `source.sol`** pour comprendre l’intention sémantique du contrat.
2. **Observer `CFG.svg`** pour visualiser la structure réelle du bytecode EVM.
3. **Comparer les fichiers `*.decompiled`** pour voir ce que chaque outil reconstruit ou perd.
4. Évaluer plusieurs aspects :
   - noms et frontières de fonctions ;
   - restitution des branches et boucles ;
   - reconstruction des accès stockage / mémoire ;
   - qualité des types et des signatures ;
   - lisibilité globale ;
   - écarts sémantiques éventuels par rapport au source.