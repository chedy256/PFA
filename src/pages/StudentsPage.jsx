import { useState } from "react";

const ETUDIANTS_INITIAUX = [
  {
    id: 1,
    nom: "Alice Johnson",
    email: "alice@student.com",
    promo: "2026",
    filiere: "CS",
  },
  {
    id: 2,
    nom: "Bob Martin",
    email: "bob@student.com",
    promo: "2026",
    filiere: "SE",
  },
  {
    id: 3,
    nom: "Charlie Dupont",
    email: "charlie@student.com",
    promo: "2025",
    filiere: "CS",
  },
  {
    id: 4,
    nom: "Diana Nguyen",
    email: "diana@student.com",
    promo: "2026",
    filiere: "Data",
  },
  {
    id: 5,
    nom: "Evan Smith",
    email: "evan@student.com",
    promo: "2025",
    filiere: "SE",
  },
];

function Utilisateurs() {
  const [etudiants, setEtudiants] = useState(ETUDIANTS_INITIAUX);
  const [recherche, setRecherche] = useState("");
  const [etudiantEdite, setEtudiantEdite] = useState(null);
  const [modeCreation, setModeCreation] = useState(false);

  const etudiantsFiltres = etudiants.filter((e) => {
    if (!recherche) return true;
    const q = recherche.toLowerCase();
    return (
      e.nom.toLowerCase().includes(q) || e.email.toLowerCase().includes(q)
    );
  });

  const ouvrirEdition = (etudiant) => {
    setModeCreation(false);
    setEtudiantEdite({ ...etudiant });
  };

  const fermerEdition = () => {
    setEtudiantEdite(null);
    setModeCreation(false);
  };

  const sauvegarderEtudiant = () => {
    if (!etudiantEdite) return;
    if (modeCreation) {
      setEtudiants((prev) => [
        ...prev,
        { ...etudiantEdite, id: Date.now() },
      ]);
    } else {
      setEtudiants((prev) =>
        prev.map((e) => (e.id === etudiantEdite.id ? etudiantEdite : e))
      );
    }
    fermerEdition();
  };

  const supprimerEtudiant = (id) => {
    setEtudiants((prev) => prev.filter((e) => e.id !== id));
  };

  return (
    <div className="students-page">
      <div className="students-header">
        <div>
          <h1 className="page-title">Students</h1>
          <p className="page-subtitle">
            Manage student records and assignments.
          </p>
        </div>
        <button
          type="button"
          className="btn-primary"
          onClick={() => {
            setModeCreation(true);
            setEtudiantEdite({
              id: 0,
              nom: "",
              email: "",
              promo: "2026",
              filiere: "CS",
            });
          }}
        >
          + Add Student
        </button>
      </div>

      <div className="students-toolbar">
        <input
          type="text"
          placeholder="Search students..."
          value={recherche}
          onChange={(e) => setRecherche(e.target.value)}
          className="search-input"
        />
      </div>

      <div className="students-table-wrapper">
        <table className="students-table">
          <thead>
            <tr>
              <th>Full name</th>
              <th>Email</th>
              <th>Promo</th>
              <th>Major</th>
              <th className="text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            {etudiantsFiltres.map((e) => (
              <tr key={e.id}>
                <td>{e.nom}</td>
                <td>{e.email}</td>
                <td>
                  <span className="tag">{e.promo}</span>
                </td>
                <td>{e.filiere}</td>
                <td className="text-right actions-cell">
                  <button
                    type="button"
                    className="icon-btn edit"
                    onClick={() => ouvrirEdition(e)}
                  >
                    ✏️
                  </button>
                  <button
                    type="button"
                    className="icon-btn delete"
                    onClick={() => supprimerEtudiant(e.id)}
                  >
                    🗑️
                  </button>
                </td>
              </tr>
            ))}
            {etudiantsFiltres.length === 0 && (
              <tr>
                <td colSpan={5} className="empty-cell">
                  No students match this search.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {etudiantEdite && (
        <div className="modal-backdrop">
          <div className="modal-panel">
            <div className="modal-header">
              <h2>{modeCreation ? "Add Student" : "Edit Student"}</h2>
              <button
                type="button"
                className="modal-close"
                onClick={fermerEdition}
              >
                ×
              </button>
            </div>
            <div className="modal-body">
              <div className="field">
                <label className="field-label">Full Name</label>
                <input
                  type="text"
                  className="field-input"
                  value={etudiantEdite.nom}
                  onChange={(e) =>
                    setEtudiantEdite((prev) => ({
                      ...prev,
                      nom: e.target.value,
                    }))
                  }
                />
              </div>
              <div className="field">
                <label className="field-label">Email</label>
                <input
                  type="email"
                  className="field-input"
                  value={etudiantEdite.email}
                  onChange={(e) =>
                    setEtudiantEdite((prev) => ({
                      ...prev,
                      email: e.target.value,
                    }))
                  }
                />
              </div>
              <div className="field-row">
                <div className="field">
                  <label className="field-label">Promo</label>
                  <select
                    className="field-select"
                    value={etudiantEdite.promo}
                    onChange={(e) =>
                      setEtudiantEdite((prev) => ({
                        ...prev,
                        promo: e.target.value,
                      }))
                    }
                  >
                    <option value="2025">2025</option>
                    <option value="2026">2026</option>
                    <option value="2027">2027</option>
                  </select>
                </div>
                <div className="field">
                  <label className="field-label">Major</label>
                  <select
                    className="field-select"
                    value={etudiantEdite.filiere}
                    onChange={(e) =>
                      setEtudiantEdite((prev) => ({
                        ...prev,
                        filiere: e.target.value,
                      }))
                    }
                  >
                    <option value="CS">Computer Science</option>
                    <option value="SE">Software Engineering</option>
                    <option value="Data">Data</option>
                  </select>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <button
                type="button"
                className="btn-ghost"
                onClick={fermerEdition}
              >
                Cancel
              </button>
              <button
                type="button"
                className="btn-primary"
                onClick={sauvegarderEtudiant}
              >
                {modeCreation ? "Create Student" : "Update Student"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default Utilisateurs;

