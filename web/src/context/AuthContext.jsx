import { createContext, useContext, useState, useEffect } from 'react'
import {
  signInWithEmailAndPassword,
  signOut,
  onAuthStateChanged,
  sendPasswordResetEmail,
} from 'firebase/auth'
import { auth } from '../firebase'

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const [user,    setUser]    = useState(null)
  const [isAdmin, setIsAdmin] = useState(false)
  const [idToken, setIdToken] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (firebaseUser) => {
      if (firebaseUser) {
        // Get the ID token with custom claims
        const token = await firebaseUser.getIdTokenResult()
        
        setUser({
          uid:      firebaseUser.uid,
          name:     firebaseUser.displayName || firebaseUser.email.split('@')[0],
          email:    firebaseUser.email,
          photoURL: firebaseUser.photoURL,
        })
        
        // Check for admin custom claim
        setIsAdmin(token.claims.admin === true)
        setIdToken(token.token)
      } else {
        setUser(null)
        setIsAdmin(false)
        setIdToken(null)
      }
      setLoading(false)
    })
    return unsubscribe
  }, [])

  const loginWithEmail = (email, password) => signInWithEmailAndPassword(auth, email, password)
  const resetPassword  = (email) => sendPasswordResetEmail(auth, email)
  const logout         = () => signOut(auth)

  return (
    <AuthContext.Provider value={{ user, loading, loginWithEmail, resetPassword, logout, isAdmin, idToken }}>
      {!loading && children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => useContext(AuthContext)
