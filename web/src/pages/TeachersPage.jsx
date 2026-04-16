import { useState } from "react";

const ENSEIGNANTS_INITIAUX = [
  { id: 1, nom: "Dr. Ahmad Youssef", email: "ahmad@university.edu", departement: "Informatique", statut: "Titulaire" },
  { id: 2, nom: "Prof. Sarah Connor", email: "sarah@university.edu", departement: "Mathématiques", statut: "Vacataire" },
  { id: 3, nom: "M. Karim Benali", email: "karim@university.edu", departement: "Informatique", statut: "Contractuel" },
];

function TeachersPage() {
  const [enseignants, setEnseignants] = useState(ENSEIGNANTS_INITIAUX);
  const [recherche, setRecherche] = useState("");
  const [enseignantEdite, setEnseignantEdite] = useState(null);
  const [modeCreation, setModeCreation] = useState(false);

  const enseignantsFiltres = enseignants.filter((e) => {
    if (!recherche) return true;
    const q = recherche.toLowerCase();
    return e.nom.toLowerCase().includes(q) || e.email.toLowerCase().includes(q);
  });

  const ouvrirEdition = (enseignant) => {
    setModeCreation(false);
    setEnseignantEdite({ ...enseignant });
  };

  const fermerEdition = () => {
    setEnseignantEdite(null);
    setModeCreation(false);
  };

  const sauvegarderEnseignant = () => {
    if (!enseignantEdite) return;
    if (modeCreation) {
      setEnseignants((prev) => [...prev, { ...enseignantEdite, id: Date.now() }]);
    } else {
      setEnseignants((prev) =>
        prev.map((e) => (e.id === enseignantEdite.id ? enseignantEdite : e))
      );
    }
    fermerEdition();
  };

  const supprimerEnseignant = (id) => {
    setEnseignants((prev) => prev.filter((e) => e.id !== id));
  };

  return (
    <div className="students-page"> {/* Reusing the layout class from students */}
      <div className="students-header">
        <div>
          <h1 className="page-title">Teachers</h1>
          <p className="page-subtitle">Manage faculty members and advisors.</p>
        </div>
        <button
          type="button"
          className="btn-primary"
          onClick={() => {
            setModeCreation(true);
            setEnseignantEdite({ id: 0, nom: "", email: "", departement: "Informatique", statut: "Titulaire" });
          }}
        >
          + Add Teacher
        </button>
      </div>

      <div className="students-toolbar">
        <input
          type="text"
          placeholder="Search teachers..."
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
              <th>Department</th>
              <th>Status</th>
              <th className="text-right">Actions</th>
            </tr>
          </thead>
          <tbody>
            {enseignantsFiltres.map((e) => (
              <tr key={e.id}>
                <td>{e.nom}</td>
                <td>{e.email}</td>
                <td>{e.departement}</td>
                <td>
                  <span className="tag" style={{
                    borderColor: e.statut === 'Titulaire' ? 'var(--success)' : 'var(--border)',
                    color: e.statut === 'Titulaire' ? 'var(--success)' : 'var(--text-secondary)'
                  }}>{e.statut}</span>
                </td>
                <td className="text-right actions-cell">
                  <button type="button" className="icon-btn edit" onClick={() => ouvrirEdition(e)}>✏️</button>
                  <button type="button" className="icon-btn delete" onClick={() => supprimerEnseignant(e.id)}>🗑️</button>
                </td>
              </tr>
            ))}
            {enseignantsFiltres.length === 0 && (
              <tr>
                <td colSpan={5} className="empty-cell">No teachers match this search.</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {enseignantEdite && (
        <div className="modal-backdrop">
          <div className="modal-panel">
            <div className="modal-header">
              <h2>{modeCreation ? "Add Teacher" : "Edit Teacher"}</h2>
              <button type="button" className="modal-close" onClick={fermerEdition}>×</button>
            </div>
            <div className="modal-body">
              <div className="field">
                <label className="field-label">Full Name</label>
                <input
                  type="text"
                  className="field-input"
                  value={enseignantEdite.nom}
                  onChange={(e) => setEnseignantEdite((prev) => ({ ...prev, nom: e.target.value }))}
                />
              </div>
              <div className="field">
                <label className="field-label">Email</label>
                <input
                  type="email"
                  className="field-input"
                  value={enseignantEdite.email}
                  onChange={(e) => setEnseignantEdite((prev) => ({ ...prev, email: e.target.value }))}
                />
              </div>
              <div className="field-row">
                <div className="field">
                  <label className="field-label">Department</label>
                  <select
                    className="field-select"
                    value={enseignantEdite.departement}
                    onChange={(e) => setEnseignantEdite((prev) => ({ ...prev, departement: e.target.value }))}
                  >
                    <option value="Informatique">Informatique</option>
                    <option value="Mathématiques">Mathématiques</option>
                    <option value="Physique">Physique</option>
                  </select>
                </div>
                <div className="field">
                  <label className="field-label">Status</label>
                  <select
                    className="field-select"
                    value={enseignantEdite.statut}
                    onChange={(e) => setEnseignantEdite((prev) => ({ ...prev, statut: e.target.value }))}
                  >
                    <option value="Titulaire">Titulaire</option>
                    <option value="Contractuel">Contractuel</option>
                    <option value="Vacataire">Vacataire</option>
                  </select>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <button type="button" className="btn-ghost" onClick={fermerEdition}>Cancel</button>
              <button type="button" className="btn-primary" onClick={sauvegarderEnseignant}>
                {modeCreation ? "Create Teacher" : "Update Teacher"}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default TeachersPage;
