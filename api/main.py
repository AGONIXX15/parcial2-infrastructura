import os, socket
import psycopg
from fastapi import FastAPI, HTTPException

app = FastAPI()
DSN = (f"host={os.environ['DB_HOST']} dbname={os.environ['POSTGRES_DB']} "
       f"user={os.environ['POSTGRES_USER']} password={os.environ['POSTGRES_PASSWORD']} connect_timeout=3")


def db():
    return psycopg.connect(DSN, autocommit=True)


@app.on_event("startup")
def init():
    for _ in range(30):
        try:
            with db() as c:
                c.execute("CREATE TABLE IF NOT EXISTS items (id SERIAL PRIMARY KEY, name TEXT NOT NULL)")
            return
        except Exception:
            import time; time.sleep(2)


@app.get("/health")
def health():
    try:
        with db() as c:
            c.execute("SELECT 1")
    except Exception as e:
        raise HTTPException(503, f"db: {e}")
    return {"status": "ok", "pod": socket.gethostname()}


@app.get("/items")
def list_items():
    with db() as c:
        rows = c.execute("SELECT id, name FROM items ORDER BY id").fetchall()
    return {"pod": socket.gethostname(), "items": [{"id": r[0], "name": r[1]} for r in rows]}


@app.post("/items")
def add_item(name: str):
    with db() as c:
        r = c.execute("INSERT INTO items (name) VALUES (%s) RETURNING id", (name,)).fetchone()
    return {"pod": socket.gethostname(), "id": r[0], "name": name}
