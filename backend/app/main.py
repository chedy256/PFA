from fastapi import FastAPI
from database import Base, engine
from routers import users, internships, documents, auth, messaging

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Internship Management System")

app.include_router(auth.router)
app.include_router(users.router)
app.include_router(internships.router)
app.include_router(documents.router)
app.include_router(messaging.router)