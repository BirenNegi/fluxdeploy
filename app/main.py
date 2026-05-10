from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from prometheus_fastapi_instrumentator import Instrumentator
from .database import engine, Base, Item, get_db
from .models import ItemCreate, ItemResponse
from typing import List

app = FastAPI(title="FluxDeploy API", version="1.0.0")

Instrumentator().instrument(app).expose(app)


@app.on_event("startup")
def startup():
    Base.metadata.create_all(bind=engine)


@app.get("/health")
def health():
    return {"status": "ok", "service": "fluxdeploy"}


@app.get("/items", response_model=List[ItemResponse])
def list_items(db: Session = Depends(get_db)):
    return db.query(Item).all()


@app.post("/items", response_model=ItemResponse, status_code=201)
def create_item(item: ItemCreate, db: Session = Depends(get_db)):
    db_item = Item(**item.model_dump())
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item


@app.get("/items/{item_id}", response_model=ItemResponse)
def get_item(item_id: int, db: Session = Depends(get_db)):
    item = db.query(Item).filter(Item.id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item


@app.delete("/items/{item_id}", status_code=204)
def delete_item(item_id: int, db: Session = Depends(get_db)):
    item = db.query(Item).filter(Item.id == item_id).first()
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    db.delete(item)
    db.commit()
