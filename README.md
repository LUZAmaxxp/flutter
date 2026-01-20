# Course 101 - Appointment Booking App

## Project Overview

This project is a cross-platform mobile application for booking and managing appointments with doctors. It's built with a Flutter frontend and a Node.js backend. The application allows users to register as either a client or a doctor, book appointments, and manage their schedules.

## Tech Stack

### Frontend

*   **Framework:** [Flutter](https://flutter.dev/) 3.x
*   **Language:** [Dart](https://dart.dev/)
*   **State Management:** (Not specified, likely `setState` or a simple provider)
*   **HTTP Client:** [http](https://pub.dev/packages/http)
*   **UI Toolkit:** Material Design

### Backend

*   **Framework:** [Node.js](https://nodejs.org/) with [Express.js](https://expressjs.com/)
*   **Language:** JavaScript
*   **Database:** [MongoDB](https://www.mongodb.com/) with [Mongoose](https://mongoosejs.com/)
*   **Authentication:** JSON Web Tokens (JWT)
*   **Real-time Communication:** (Not implemented)
*   **Other Libraries:**
    *   `bcryptjs` for password hashing
    *   `cors` for handling Cross-Origin Resource Sharing
    *   `dotenv` for managing environment variables
    *   `nodemailer` for sending emails (e.g., for verification)

## Project Architecture

The Flutter application follows a feature-based architecture, with code organized into the following main directories under `lib/`:

*   `core/`: Contains shared functionalities like navigation, services (e.g., `AuthService`, `NetworkService`), and theme definitions (`AppTheme`).
*   `features/`: Each feature of the application is encapsulated in its own sub-directory. This includes:
    *   `auth`: Handles user authentication (login, registration).
    *   `onboarding`: Contains the initial splash screen and onboarding flow.
    *   `profile`: Manages user profiles.
    *   `appointments`: The core feature for booking and viewing appointments.
    *   `doctor_profile`: For viewing doctor-specific profiles.
*   `screens/`: Contains standalone screens, which could be refactored into the `features` directory.
*   `services/`: Contains business logic for different services.
*   `main.dart`: The entry point of the application.

## Features

### Implemented

*   **User Authentication:**
    *   User registration as a "client" or "doctor".
    *   Email verification using a one-time code sent via email.
    *   Secure login with JWT-based authentication.
*   **Doctor Profiles:**
    *   Doctors can have profiles with specialization, experience, rating, and a bio.
*   **Appointment Management:**
    *   Clients can book appointments with doctors.
    *   Both clients and doctors can view their upcoming and past appointments.
    *   Ability to update the status of an appointment (e.g., 'pending', 'confirmed', 'cancelled', 'done').
*   **Dashboard:**
    *   A summary of appointment statistics (total, pending, confirmed, etc.).

### Future (Potential)

*   Real-time chat between clients and doctors.
*   Push notifications for appointment reminders.
*   Payment integration for paid consultations.
*   Advanced search and filtering for doctors.
*   User reviews and ratings for doctors.

## Setup and Run

### Prerequisites

*   [Flutter SDK](https://flutter.dev/docs/get-started/install)
*   [Node.js and npm](https://nodejs.org/en/download/)
*   [MongoDB](https://www.mongodb.com/try/download/community) (or a MongoDB Atlas account)

### Backend Setup

1.  **Navigate to the backend directory:**
    ```bash
    cd backend
    ```
2.  **Install dependencies:**
    ```bash
    npm install
    ```
3.  **Create a `.env` file** in the `backend` directory and add the following environment variables:
    ```
    MONGODB_URI=<your_mongodb_connection_string>
    JWT_SECRET=<your_jwt_secret>
    EMAIL_USER=<your_gmail_address>
    EMAIL_PASS=<your_gmail_app_password>
    ```
4.  **Start the backend server:**
    ```bash
    npm start
    ```
    The server will be running on `http://localhost:3000`.

### Frontend Setup

1.  **Navigate to the project root directory:**
    ```bash
    cd .. 
    ```
2.  **Get Flutter packages:**
    ```bash
    flutter pub get
    ```
3.  **Run the application:**
    ```bash
    flutter run
    ```
    Select the desired device (e.g., Android emulator, iOS simulator, Chrome) to run the app.