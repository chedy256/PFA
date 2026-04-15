# API Endpoints Documentation

This document outlines the API endpoints extracted from the FastAPI backend, organized by client applications.

## Base URL
Ensure your Flutter HTTP service and Web Axios/Fetch service point to your FastAPI URL (e.g., `http://localhost:8000` or your production domain).

## Authentication
**Note:** All endpoints (except the initial auth flow) require an `Authorization: Bearer <token>` header.

---

## 📱 Flutter Mobile App (Students & Teachers)

### Authentication & User Profile
* **`POST /auth/bootstrap`**
  * **Description:** Authenticate or initialize a session using a Firebase token in the `Authorization` header.
  * **Body:** `BootstrapRequest` schema.
* **`GET /auth/me`** (or `GET /users/me`)
  * **Description:** Fetches the currently authenticated user's profile information.
* **`PATCH /auth/fcm-token`**
  * **Description:** Updates the user's Firebase Cloud Messaging token to receive push notifications.
  * **Body:** `{"fcm_token": "string"}`

### Internships
* **`GET /internships/`**
  * **Description:** Retrieves internships.
    * If `student`: returns only their own internships.
    * If `teacher`: returns only the internships assigned to them.
* **`POST /internships/`** *(Students Only)*
  * **Description:** Allows a student to propose or create a new internship.
  * **Body:** `{"title": "string", "description": "string"}`

### Messaging (Chat System)
* **`GET /messages/`**
  * **Description:** Gets a list of messages where the current user is the receiver.
* **`GET /messages/conversation/{other_user_id}`**
  * **Description:** Fetches the entire chat history between the current user and `other_user_id`.
* **`POST /messages/`**
  * **Description:** Sends a message to another user.
  * **Body:** `MessageCreate` schema (e.g., `{"receiver_id": "string", "content": "string"}`).

---

## 💻 Web App (Admins)

The admin panel generally needs broader access and document generation capabilities.

### Admin Internships Management
* **`GET /internships/`**
  * **Description:** Retrieves **all** internships in the system across all students and teachers.

### Document Generation
* **`POST /documents/generate-fiche`**
  * **Description:** Generates a PDF based on the provided fiche data.
  * **Body:** `FicheData` schema.
* **`POST /documents/{internship_id}`** *(Admin Only)*
  * **Description:** Generates a specific document for an internship. Access is strictly blocked for non-admins.

### Shared Endpoints
Admins will also use `POST /auth/bootstrap` and `GET /auth/me` to log into the web dashboard.
