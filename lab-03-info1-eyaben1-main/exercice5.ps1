# Script PowerShell pour l'Exercice 5 : Gestion des logs
# Lab 03 - Docker

Write-Host "=== Exercice 5 : Gestion des logs ===" -ForegroundColor Green

# 1. Creer un volume log-volume
Write-Host "`n1. Creation du volume log-volume..." -ForegroundColor Yellow
docker volume create log-volume

if ($LASTEXITCODE -eq 0) {
    Write-Host "Volume log-volume cree avec succes" -ForegroundColor Green
} else {
    Write-Host "Erreur lors de la creation du volume" -ForegroundColor Red
    exit 1
}

# Lister les volumes pour verification
Write-Host "`n2. Verification des volumes disponibles:" -ForegroundColor Yellow
docker volume ls

# 2. Arreter et supprimer le conteneur avec logs existant s'il existe
Write-Host "`n3. Nettoyage des conteneurs avec logs existants..." -ForegroundColor Yellow
docker stop books-logs-container 2>$null
docker rm books-logs-container 2>$null

# 3. Construire une nouvelle image avec les logs
Write-Host "`n4. Construction de l'image avec support des logs..." -ForegroundColor Yellow
docker build -t books-api-logs .

if ($LASTEXITCODE -eq 0) {
    Write-Host "Image avec logs construite avec succes" -ForegroundColor Green
} else {
    Write-Host "Erreur lors de la construction de l'image avec logs" -ForegroundColor Red
    exit 1
}

# 4. Executer le conteneur avec le volume de logs
Write-Host "`n5. Execution du conteneur avec volume de logs..." -ForegroundColor Yellow
docker run -d -p 5002:5000 -v log-volume:/app/logs --name books-logs-container books-api-logs

if ($LASTEXITCODE -eq 0) {
    Write-Host "Conteneur avec logs demarre avec succes" -ForegroundColor Green
} else {
    Write-Host "Erreur lors du demarrage du conteneur avec logs" -ForegroundColor Red
    exit 1
}

# Attendre que l'application demarre
Write-Host "`n6. Attente du demarrage de l'application..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# 5. Generer quelques logs en testant l'API
Write-Host "`n7. Generation de logs en testant l'API..." -ForegroundColor Yellow

# Test de l'endpoint principal
Write-Host "Test de l'endpoint principal..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:5002" -Method Get -TimeoutSec 10
    Write-Host "API accessible: $($response.message)" -ForegroundColor Green
} catch {
    Write-Host "Erreur: API non accessible" -ForegroundColor Red
}

# Test de l'endpoint books
Write-Host "Test de l'endpoint books..." -ForegroundColor Cyan
try {
    $booksResponse = Invoke-RestMethod -Uri "http://localhost:5002/books" -Method Get -TimeoutSec 10
    Write-Host "Books API: $($booksResponse.count) livres disponibles" -ForegroundColor Green
} catch {
    Write-Host "Erreur: Books API non accessible" -ForegroundColor Red
}

# Test d'ajout d'un livre pour generer plus de logs
Write-Host "Test d'ajout d'un livre..." -ForegroundColor Cyan
$bookData = @{
    title = "Test Log Book"
    author = "Test Author"
    year = 2024
} | ConvertTo-Json

try {
    $addResponse = Invoke-RestMethod -Uri "http://localhost:5002/books" -Method Post -Body $bookData -ContentType "application/json" -TimeoutSec 10
    Write-Host "Livre ajoute: $($addResponse.title)" -ForegroundColor Green
} catch {
    Write-Host "Erreur lors de l'ajout du livre" -ForegroundColor Red
}

# 6. Arreter le conteneur
Write-Host "`n8. Arret du conteneur..." -ForegroundColor Yellow
docker stop books-logs-container

if ($LASTEXITCODE -eq 0) {
    Write-Host "Conteneur arrete avec succes" -ForegroundColor Green
} else {
    Write-Host "Erreur lors de l'arret du conteneur" -ForegroundColor Red
}

# 7. Verifier que les logs du serveur Flask sont stockes dans le volume
Write-Host "`n9. Verification des logs stockes dans le volume..." -ForegroundColor Yellow

# Inspecter le volume
Write-Host "Inspection du volume log-volume:" -ForegroundColor Cyan
docker volume inspect log-volume

# Redemarrer un conteneur temporaire pour acceder aux logs
Write-Host "`n10. Acces aux logs via un conteneur temporaire..." -ForegroundColor Yellow
docker run --rm -v log-volume:/logs alpine ls -la /logs

Write-Host "`n11. Contenu du fichier de log:" -ForegroundColor Yellow
docker run --rm -v log-volume:/logs alpine cat /logs/flask.log

Write-Host "`n=== Exercice 5 termine ===" -ForegroundColor Green
Write-Host "La gestion des logs avec volume Docker a ete implementee avec succes" -ForegroundColor Cyan
Write-Host "Les logs du serveur Flask sont stockes dans le volume log-volume" -ForegroundColor Green
Write-Host "Commandes utilisees:" -ForegroundColor Yellow
Write-Host "- docker volume create log-volume" -ForegroundColor White
Write-Host "- docker run -d -p 5002:5000 -v log-volume:/app/logs --name books-logs-container books-api-logs" -ForegroundColor White
Write-Host "- docker volume inspect log-volume" -ForegroundColor White
