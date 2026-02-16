from pydantic import BaseModel

class UserOut(BaseModel):
    id: str
    email: str
    first_name: str
    last_name: str
    role: str

    class Config:
        from_attributes = True

class InternshipCreate(BaseModel):
    title: str
    description: str

class InternshipOut(BaseModel):
    id: str
    title: str
    description: str
    status: str

    class Config:
        from_attributes = True
