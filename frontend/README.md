# ISIMM Intern

Application Flutter **à rôles multiples** destinée à la gestion des stages universitaires.

Cette application est **un client** d’un système backend centralisé.  
Elle prend en charge **les étudiants**, **les enseignants** et **les administrateurs** à partir **d’un seul codebase**, avec une navigation et des permissions basées sur les rôles.

---

## Objectif

Cette application permet aux :

- **Étudiants** de soumettre leurs stages, déposer leurs rapports et télécharger des documents officiels
- **Enseignants** de suivre les étudiants et de soumettre des évaluations

Toute la logique métier, les permissions et la génération de documents sont gérées par le backend.

---

## Vue d’ensemble de l’architecture


- Flutter gère **l’interface utilisateur, la navigation et les formulaires**
- Firebase gère **uniquement l’authentification**
- Le backend gère **l’autorisation, les règles métier et les fichiers**

---

## Rôles supportés

| Rôle       | Plateforme cible | Capacités principales                                 |
|------------|------------------|-------------------------------------------------------|
| Étudiant   | Android Mobile   | Soumission de stages, dépôt de rapports, suivi d’état |
| Enseignant | Android Mobile   | Suivi des stages assignés, dépôt d’évaluations        |

Le rôle de l’utilisateur est déterminé **après connexion**, côté backend.

---

## Stack technique

### Frontend
- Flutter
- Dart
- Riverpod (State Manager)

### Authentification
- Firebase Authentication
- Email / Mot de passe (géré par Firebase)

### Backend (externe)
- FastAPI
- PostgreSQL
- Docker
---

## Gestion de l’état (State Management)

Riverpod est utilisé **uniquement** pour :
- l’état d’authentification
- les informations de l’utilisateur courant
- le client API
- le theme de l'application

Tous les états liés aux formulaires et à l’interface sont gérés localement.


---

## Flux de l’application

1. L’application démarre
2. Firebase vérifie l’authentification
3. Le token est envoyé au backend
4. Le backend valide l’utilisateur et son rôle
5. Redirection vers :
   - Accueil Étudiant
   - Accueil Enseignant
   - Tableau de bord Admin

La navigation est basée sur les rôles et **contrôlée côté serveur**.

### Flux plus détaillé :
#### Étudiant
- Soumission de stage → Backend valide et stocke :
    - L'étudiant remplit un formulaire avec les détails du stage :
      - Poste occupé
      - Description du stage
      - Nom de l’entreprise
      - Dates de début et de fin
      - Optionnellement un document illustrant de stage
      - Jusqu'à 3 professeurs encadrants qui seront notifiés qui l'un d'eux choisira d'etre son encadrant principal
- Téléchargement de documents → Backend génère et sert les fichiers :
  - Documents officiels liés au stage (demade de stage, conventions, etc.)
- Suivi d’état grace au journal du stage → Backend fournit les mises à jour en temps réel
- Dépôt de rapport → Backend valide et stocke
- Notifications → Backend envoie des notifications pour les échéances et les mises à jour
- Gestion de profil → Étudiant peut mettre à jour ses informations personnelles
#### Enseignant
- Consultation les demandes d'encadrement → Backend fournit la liste des étudiants et leurs stages
- Suivi des stages assignés → Backend fournit la liste des stages et leur statut
- Dépôt d’évaluations → Backend valide et stocke les évaluations
- Notifications → Backend envoie des notifications pour les échéances et les mises à jour
- Gestion de profil → Enseignant peut mettre à jour ses informations personnelles

---
## Roadmap

- [x] App Theming 
- [ ] Pages:
    - [x] Login / Inscription
    - [x] Accueil Étudiant
    - [x] Accueil Enseignant
    - [ ] Page des Stages:
       - [x] Page Stage Détailée
       - [x] Page de Soumission de Stage
       - [ ] Page du Document
       - [_] Page Profile / Paramètres
- [x] Intégration avec Firebase Authentication
- [ ] Intégration complète avec le backend
- [ ] Tests unitaires et d’intégration
---

### Prérequis
- Flutter SDK (stable)
- Android Studio ou VS Code
- Projet Firebase configuré
- Backend fonctionnel et accessible

### Cloner le repo
```bash
git clone git@github.com:chedy256/PFA.git
checkout frontend
```

### Lancer l’application
```bash
flutter pub get
flutter run
```

#### Made with ❤️ by [El Haj Chedy Amine](https://github.com/chedy256)
