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

---


---

# Technical Reference (Setup & Security)

    this is AI generated content, it may contain inaccuracies. Please verify with the original source.

## 1. Project Structure

This is the canonical structure for the backend:

```
backend/
├── app/
│   ├── main.py
│   ├── database.py
│   ├── models.py
│   ├── schemas.py
│   ├── deps.py          # Dependency injection (Auth)
│   ├── auth.py          # Firebase verification
│   ├── security.py      # Role-based access control
│   ├── routers/
│   │   ├── users.py
│   │   ├── internships.py
│   │   └── documents.py
│   └── utils/
│       └── files.py
├── storage/             # Persistent storage
│   ├── internships/     # Generated PDFs
│   └── templates/       # HTML templates for WeasyPrint
├── requirements.txt
├── Dockerfile
└── docker-compose.yml
```

## 2. Docker & Deployment

The project is containerized using Docker and Docker Compose.

**Dockerfile** uses `python:3.11-slim` and installs system dependencies for WeasyPrint (PDF generation).

**docker-compose.yml** sets up:
- **Backend Service**: Port 8000, mounts `storage/` and `firebase.json`.
- **Database Service**: PostgreSQL 15.

### Running the Project
Ensure `firebase.json` is present in the `backend/` directory.
```bash
docker-compose up --build
```

## 3. Security Model

| Layer    | Responsibility                 |
| -------- | ------------------------------ |
| Firebase | Authentication (Who are you?)  |
| Backend  | Authorization (What can you do?)|
| Database | Data Integrity & Relationships |

### Authentication Flow
1.  **Client (Flutter)** logs in via Firebase and retrieves an ID Token.
    ```dart
    final token = await user!.getIdToken();
    ```
2.  **Client** sends request with header: `Authorization: Bearer <token>`.
3.  **Backend (`deps.py`)**:
    -   Extracts token.
    -   Verifies signature with Firebase Admin SDK.
    -   Extracts UID.
    -   Loads User from Database.

### Role-Based Access Control (RBAC)
We use a decorator approach in `security.py` to enforce roles cleanly:
```python
@router.post("/internships")
def create(user = Depends(require_role("student"))):
    ...
```

## 4. Document Storage & Generation
Documents are generated securely on the backend:
-   **Templates**: HTML files in `backend/storage/templates/`.
-   **Output**: PDFs saved in `backend/storage/internships/internship_<id>/`.

