# API Endpoints Documentation

This document outlines the API endpoints extracted from the FastAPI backend, organized by client applications. It includes request schemas and expected responses.

## Base URL
Ensure your Flutter HTTP service and Web Axios/Fetch service point to your FastAPI URL (e.g., `http://localhost:8000` or your production domain).

## Authentication
**Note:** All endpoints (except the health check) require an `Authorization: Bearer <token>` header. For local testing, you can bypass Firebase using the format `Bearer test-<user_id>`.

---

## 📱 Flutter Mobile App (Students & Teachers)

### Authentication & User Profile

* **`POST /auth/bootstrap`**
  * **Description:** Authenticate or initialize a session. Registers a user if they don't exist.
  * **Headers:** `Authorization: Bearer <token>`
  * **Request Body (JSON):**
    ```json
    {
      "requested_role": "string (e.g., 'student', 'teacher')",
      "first_name": "string (optional)",
      "last_name": "string (optional)",
      "fcm_token": "string (optional)"
    }
    ```
  * **Response (UserOut - 200 OK):**
    ```json
    {
      "id": "string",
      "email": "string",
      "first_name": "string (or null)",
      "last_name": "string (or null)",
      "cin_number": "string (or null)",
      "role": "string ('student', 'none' if pending teacher, etc.)",
      "status": "string ('active', 'pending')"
    }
    ```

* **`GET /auth/me`**
  * **Description:** Fetches the currently authenticated user's profile information.
  * **Response (UserOut - 200 OK):**
    ```json
    {
      "id": "string",
      "email": "string",
      "first_name": "string",
      "last_name": "string",
      "cin_number": "string",
      "role": "string",
      "status": "string"
    }
    ```

* **`PATCH /auth/fcm-token`**
  * **Description:** Updates the user's Firebase Cloud Messaging token.
  * **Request Body (JSON):**
    ```json
    {
      "fcm_token": "string"
    }
    ```
  * **Response (200 OK):**
    ```json
    {
      "message": "FCM token mis à jour"
    }
    ```

### Internships

* **`GET /internships/`**
  * **Description:** Retrieves internships. Returns only own internships for students, assigned internships for teachers, and all internships for admins.
  * **Response (List of InternshipOut - 200 OK):**
    ```json
    [
      {
        "id": "string",
        "title": "string",
        "description": "string",
        "status": "string",
        "type": "string (e.g., 'ete', 'pfe')",
        "company_name": "string (or null)",
        "company_address": "string (or null)",
        "company_sector": "string (or null)",
        "company_phone": "string (or null)",
        "supervisor_name": "string (or null)",
        "supervisor_email": "string (or null)",
        "supervisor_function": "string (or null)"
      }
    ]
    ```

* **`POST /internships/`** *(Students Only)*
  * **Description:** Allows a student to propose or create a new internship.
  * **Request Body (JSON):**
    ```json
    {
      "title": "string",
      "description": "string",
      "type": "string (optional, defaults to 'ete')",
      "company_name": "string (optional)",
      "company_address": "string (optional)",
      "company_sector": "string (optional)",
      "company_phone": "string (optional)",
      "supervisor_name": "string (optional)",
      "supervisor_email": "string (optional)",
      "supervisor_function": "string (optional)"
    }
    ```
  * **Response (InternshipOut - 200 OK):** (Same object format as in GET)

### Messaging (Chat System)

* **`GET /messages/`**
  * **Description:** Gets a list of messages where the current user is the receiver.
  * **Response (List of MessageOut - 200 OK):**
    ```json
    [
      {
        "id": "string",
        "sender_id": "string",
        "receiver_id": "string",
        "content": "string",
        "created_at": "2023-10-25T14:30:00Z"
      }
    ]
    ```

* **`GET /messages/conversation/{other_user_id}`**
  * **Description:** Fetches the entire chat history between the current user and `other_user_id`.
  * **Response (List of MessageOut - 200 OK):** (Same array of messages as above)

* **`POST /messages/`**
  * **Description:** Sends a message to another user.
  * **Request Body (JSON):**
    ```json
    {
      "receiver_id": "string",
      "content": "string"
    }
    ```
  * **Response (MessageOut - 200 OK):** (The newly created message object)

---

## 💻 Web App (Admins)

The admin panel generally needs broader access and document generation capabilities.

### Admin Internships Management

* **`GET /internships/`**
  * **Description:** Retrieves **all** internships in the system across all students and teachers.

### Document Generation

* **`POST /documents/generate-fiche`**
  * **Description:** Generates a PDF based on the provided fiche data (ad-hoc template rendering).
  * **Request Body (JSON):**
    ```json
    {
      "template": "string (either 'ete' or 'pfe', defaults to 'ete')",
      "data": {
        "key": "value" // Optional dictionary of fields passed to the jinja template
      }
    }
    ```
  * **Response:**
    * **Content-Type:** `application/pdf`
    * **Body:** Raw PDF bytes.

* **`GET /documents/{internship_id}/document.pdf`** *(Admin Only)*
  * **Description:** Generates a specific PDF document filled with the data from a stored internship in the database.
  * **Response:**
    * **Content-Type:** `application/pdf`
    * **Body:** Raw PDF bytes.

### User Management (Admin Only)

* **`GET /users/role/{role_name}`**
  * **Description:** Fetches a paginated list of users by their role (e.g., 'student', 'teacher', 'admin').
  * **Query Parameters:** `page` (int, default=1), `size` (int, default=10)
  * **Response (PaginatedUsersOut - 200 OK):**
    ```json
    {
      "users": [
        {
          "id": "string",
          "email": "string",
          "first_name": "string",
          "last_name": "string",
          "cin_number": "string",
          "role": "string",
          "status": "string"
        }
      ],
      "total_count": 50,
      "total_pages": 5,
      "current_page": 1
    }
    ```

* **`GET /users/make-admin-debug`**
  * **Description:** Debug endpoint to grant admin privileges to the current user.
  * **Response (200 OK):**
    ```json
    {
      "message": "Vous êtes maintenant admin."
    }
    ```

### Shared Endpoints

* **`GET /health`**
  * **Description:** Health check endpoint to ensure the API is running correctly.
  * **Response (200 OK):**
    ```json
    {
      "status": "ok"
    }
    ```
