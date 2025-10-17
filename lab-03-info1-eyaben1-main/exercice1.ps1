# Script PowerShell pour l'Exercice 1 : Deploiement de Base
# Lab 03 - Docker

Write-Host "=== Exercice 1 : Deploiement de Base ===" -ForegroundColor Green

# Verifier si Docker est en cours d'execution
try {
    docker ps | Out-Null
    Write-Host "Docker est en cours d'execution" -ForegroundColor Green
} catch {
    Write-Host "Erreur: Docker n'est pas en cours d'execution" -ForegroundColor Red
    exit 1
}

# 1. Construire l'image Docker
Write-Host "`n1. Construction de l'image Docker..." -ForegroundColor Yellow
docker build -t books-api .

if ($LASTEXITCODE -eq 0) {
    Write-Host "Image construite avec succes" -ForegroundColor Green
} else {
    Write-Host "Erreur lors de la construction de l'image" -ForegroundColor Red
    exit 1
}

# 2. Arreter et supprimer le conteneur existant s'il existe
Write-Host "`n2. Nettoyage des conteneurs existants..." -ForegroundColor Yellow
docker stop books-container 2>$null
docker rm books-container 2>$null

# 3. Executer le conteneur
Write-Host "`n3. Execution du conteneur..." -ForegroundColor Yellow
docker run -d -p 5000:5000 --name books-container books-api

if ($LASTEXITCODE -eq 0) {
    Write-Host "Conteneur demarre avec succes" -ForegroundColor Green
} else {
    Write-Host "Erreur lors du demarrage du conteneur" -ForegroundColor Red
    exit 1
}

# 4. Attendre que l'application demarre
Write-Host "`n4. Attente du demarrage de l'application..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# 5. Verifier que l'API est accessible
Write-Host "`n5. Test de l'API..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri "http://localhost:5000" -Method Get -TimeoutSec 10
    Write-Host "API accessible: $($response.message)" -ForegroundColor Green
    Write-Host "Version: $($response.version)" -ForegroundColor Cyan
} catch {
    Write-Host "Erreur: API non accessible" -ForegroundColor Red
}

try {
    $healthResponse = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get -TimeoutSec 10
    Write-Host "Health check: $($healthResponse.status)" -ForegroundColor Green
} catch {
    Write-Host "Erreur: Health check echoue" -ForegroundColor Red
}

try {
    $booksResponse = Invoke-RestMethod -Uri "http://localhost:5000/books" -Method Get -TimeoutSec 10
    Write-Host "Books API: $($booksResponse.count) livres disponibles" -ForegroundColor Green
} catch {
    Write-Host "Erreur: Books API non accessible" -ForegroundColor Red
}

# 6. Consulter les logs du conteneur
Write-Host "`n6. Consultation des logs du conteneur..." -ForegroundColor Yellow
Write-Host "Logs du conteneur:" -ForegroundColor Cyan
docker logs books-container

Write-Host "`n=== Exercice 1 termine ===" -ForegroundColor Green
Write-Host "Le conteneur books-container est en cours d execution sur le port 5000" -ForegroundColor Cyan
Write-Host "Pour arreter le conteneur: docker stop books-container" -ForegroundColor Yellow
Write-Host "Pour consulter les logs: docker logs books-container" -ForegroundColor Yellow
