from fastapi import FastAPI
from app.database import Base, engine
from app.routers import users, internships, documents, auth, messaging

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Internship Management System")


@app.get("/")
def root():
    return {"message": "Welcome to the PFA Backend API!"}


@app.get("/health")
def health_check():
    return {"status": "ok", "message": "Backend is running smoothly 🚀"}


app.include_router(auth.router)
app.include_router(users.router)
app.include_router(internships.router)
app.include_router(documents.router)
app.include_router(messaging.router)
