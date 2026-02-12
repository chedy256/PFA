# ISIMM Intern

Application Flutter **à rôles multiples** destinée à la gestion des stages universitaires.

Cette application est **un client** d’un système backend centralisé.  
Elle prend en charge **les étudiants**, **les enseignants** et **les administrateurs** à partir **d’un seul codebase**, avec une navigation et des permissions basées sur les rôles.

---

## Objectif

Cette application permet aux:

- **Étudiants** de soumettre leurs stages, déposer leurs rapports et télécharger des documents officiels
- **Enseignants** de suivre les étudiants et de soumettre des évaluations
- **Administrateurs** de valider les stages, gérer les utilisateurs et générer des documents officiels

Toute la logique métier, les permissions et la génération de documents sont gérées par le backend.

---

## Vue d’ensemble de l’architecture


- Flutter gère **l’interface utilisateur, la navigation et les formulaires**
- Firebase gère **uniquement l’authentification**
- Le backend gère **l’autorisation, les règles métier et les fichiers**

---

## Rôles supportés

| Rôle        | Plateforme cible     | Capacités principales |
|------------|----------------------|-----------------------|
| Étudiant   | Android Mobile       | Soumission de stages, dépôt de rapports, suivi d’état |
| Enseignant | Android Mobile       | Suivi des stages assignés, dépôt d’évaluations |
| Admin      | Desktop / Web        | Validation des stages, gestion des utilisateurs, génération de documents |

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

---
## Roadmap

- [ ] App Theming 
- [ ] Pages:
    - [ ] Login / Inscription
    - [ ] Accueil Étudiant
    - [ ] Accueil Enseignant
    - [ ] Tableau de bord Admin (on hold)
- [ ] Intégration avec Firebase Authentication
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
git clone https://github.com/chedy256/PFA.git
checkout frontend
```

### Lancer l’application
```bash
flutter pub get
flutter run
```

#### Made with ❤️ by [El Haj Chedy Amine](https://github.com/chedy256)