# Script PowerShell pour l'Exercice 3 : Gestion des Conteneurs
# Lab 03 - Docker

Write-Host "=== Exercice 3 : Gestion des Conteneurs ===" -ForegroundColor Green

# Verifier que le conteneur est en cours d'execution
Write-Host "`n1. Verification de l'etat du conteneur:" -ForegroundColor Yellow
docker ps --filter "name=books-container"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Erreur: Le conteneur books-container n'est pas en cours d'execution" -ForegroundColor Red
    exit 1
}

# 1. Arreter le conteneur
Write-Host "`n2. Arret du conteneur..." -ForegroundColor Yellow
docker stop books-container

if ($LASTEXITCODE -eq 0) {
    Write-Host "Conteneur arrete avec succes" -ForegroundColor Green
} else {
    Write-Host "Erreur lors de l'arret du conteneur" -ForegroundColor Red
}

# Verifier que le conteneur est arrete
Write-Host "`n3. Verification que le conteneur est arrete:" -ForegroundColor Yellow
docker ps --filter "name=books-container"

# 2. Redemarrer le conteneur
Write-Host "`n4. Redemarrage du conteneur..." -ForegroundColor Yellow
docker start books-container

if ($LASTEXITCODE -eq 0) {
    Write-Host "Conteneur redemarre avec succes" -ForegroundColor Green
} else {
    Write-Host "Erreur lors du redemarrage du conteneur" -ForegroundColor Red
}

# Attendre que l'application redemarre
Write-Host "`n5. Attente du redemarrage de l'application..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# 3. Consulter les logs
Write-Host "`n6. Consultation des logs apres redemarrage:" -ForegroundColor Yellow
Write-Host "Logs du conteneur:" -ForegroundColor Cyan
docker logs books-container

# 4. Executer une commande dans le conteneur pour verifier la version de Python
Write-Host "`n7. Verification de la version de Python dans le conteneur:" -ForegroundColor Yellow
Write-Host "Version de Python:" -ForegroundColor Cyan
docker exec books-container python --version

Write-Host "`n8. Informations supplementaires sur le conteneur:" -ForegroundColor Yellow
Write-Host "Processus en cours dans le conteneur:" -ForegroundColor Cyan
docker exec books-container ps aux

Write-Host "`n9. Test de l'API apres redemarrage:" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get -TimeoutSec 10
    Write-Host "API fonctionne apres redemarrage: $($response.status)" -ForegroundColor Green
} catch {
    Write-Host "Erreur: API non accessible apres redemarrage" -ForegroundColor Red
}

Write-Host "`n=== Exercice 3 termine ===" -ForegroundColor Green
Write-Host "Gestion des conteneurs terminee avec succes" -ForegroundColor Cyan
Write-Host "Commandes utilisees:" -ForegroundColor Yellow
Write-Host "- docker stop books-container" -ForegroundColor White
Write-Host "- docker start books-container" -ForegroundColor White
Write-Host "- docker logs books-container" -ForegroundColor White
Write-Host "- docker exec books-container python --version" -ForegroundColor White
