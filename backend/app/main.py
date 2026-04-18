from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import Base, engine
from app.routers import users, internships, documents, auth, messaging, admin, dev

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Internship Management System")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins for testing via Flutter Web/Mobile
    allow_credentials=True,
    allow_methods=["*"],  # Allows OPTIONS method
    allow_headers=["*"],  # Allows headers
)

@app.get("/health")
def health():
    return {"status": "ok"}

app.include_router(auth.router)
app.include_router(users.router)
app.include_router(internships.router)
app.include_router(documents.router)
app.include_router(messaging.router)
app.include_router(admin.router)
app.include_router(dev.router)
