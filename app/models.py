from pydantic import BaseModel
from typing import Optional


class ItemCreate(BaseModel):
    name: str
    description: Optional[str] = None
    price: float


class ItemResponse(ItemCreate):
    id: int

    model_config = {"from_attributes": True}
