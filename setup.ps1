#!/bin/bash

echo "=== Creando entorno virtual (venv) ==="
python3 -m venv venv

echo "=== Activando entorno ==="
source venv/bin/activate

echo "=== Instalando dependencias ==="
pip install --upgrade pip
pip install -r requirements.txt

echo "=== Iniciando el servidor FastAPI ==="
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000