# Backend – Système de Gestion des Stages

Backend principal du système de gestion des stages universitaires.

Ce service expose une API sécurisée utilisée par l’application Flutter.  
Il est responsable de **l’autorisation**, de la **logique métier**, de la **gestion des fichiers** et de la **génération des documents officiels**.

---

## Rôle du backend

Le backend gère :

- La vérification des tokens Firebase
- L’application des rôles (Étudiant / Enseignant / Admin)
- Le cycle de vie des stages
- La génération et la distribution des documents
- L’accès sécurisé aux données

Le backend **ne gère pas** :
- Les mots de passe
- L’interface utilisateur
- Les états côté client

---

## Architecture générale


- Authentification : Firebase
- Autorisation : Backend
- Données : PostgreSQL

---

## Stack technique

- Python 3.x
- FastAPI
- PostgreSQL
- SQLAlchemy
- Docker

---

## Domaines principaux

| Domaine       | Responsabilité |
|--------------|----------------|
| Auth         | Vérification du token Firebase |
| Users        | Identité et rôles |
| Internships  | Gestion du workflow |
| Documents    | Génération et accès aux fichiers |
| Forms        | Données structurées |

Le domaine **Internships** est le cœur du système.

---

## Cycle de vie d’un stage

Soumission par l’étudiant
↓
PENDING
↓
Validation admin
↓
APPROVED / REJECTED
↓
Affectation enseignant
↓
Rapport étudiant
↓
Évaluation enseignant
↓
COMPLETED


Toute fonctionnalité doit servir ce flux.

---

## Modèle de sécurité

- Firebase : authentification
- Backend : autorisation
- Base de données : source de vérité

Règles :
- Un étudiant accède uniquement à ses données
- Un enseignant accède uniquement aux stages assignés
- Un administrateur accède à toutes les données

Aucune exception.

---

## Structure du projet (simplifiée)

app/
├── api/ # Routes FastAPI
├── core/ # Sécurité, config, dépendances
├── models/ # Modèles ORM
├── services/ # Logique métier
├── schemas/ # Schémas Pydantic
└── main.py

La logique métier est isolée dans `services/`.

---

## Style de l’API

- Endpoints orientés tâches
- Réponses JSON simples
- Codes HTTP explicites
- Routes protégées par rôle

Pas de GraphQL. Pas de logique inutile.

---

## Gestion des documents

- Génération côté backend (PDF)
- Basée sur des templates
- Fichiers immuables
- Accès contrôlé par rôle

Les utilisateurs ne modifient jamais les documents générés.

---

## Lancement du projet
```
git clone git@github.com:chedy256/PFA.git
cd backend
```

### Prérequis
- Docker
- Docker Compose

### Démarrage
```bash
docker-compose up 
```
Le backend est accessible sur :
http://localhost:8000
