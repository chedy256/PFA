import React from "react";
import { useAuth } from "../context/AuthContext";

export default function AdminHome() {
  const { user, isAdmin, logout, idToken } = useAuth();

  async function testBackendCall() {
    if (!idToken) return;

    const res = await fetch("http://localhost:8000/protected-admin-endpoint", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${idToken}`,
        "Content-Type": "application/json",
      },
    });

    const data = await res.json();
    console.log("Backend response:", data);
  }

  return (
    <div style={{ padding: 24 }}>
      <h1>Admin App</h1>
      <p>User: {user?.email}</p>
      <p>Admin claim: {String(isAdmin)}</p>

      <button onClick={testBackendCall} style={{ marginRight: 12 }}>
        Call backend
      </button>

      <button onClick={logout}>Logout</button>
    </div>
  );
}
