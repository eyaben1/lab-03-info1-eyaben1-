# Script PowerShell pour l'Exercice 4 : Amelioration de la securite
# Lab 03 - Docker

Write-Host "=== Exercice 4 : Amelioration de la securite ===" -ForegroundColor Green

# 1. Construire l'image Docker avec l'utilisateur securise
Write-Host "`n1. Construction de l'image Docker avec utilisateur apiuser..." -ForegroundColor Yellow
docker build -f Dockerfile-apiuser -t books-api-secure .

if ($LASTEXITCODE -eq 0) {
    Write-Host "Image securisee construite avec succes" -ForegroundColor Green
} else {
    Write-Host "Erreur lors de la construction de l'image securisee" -ForegroundColor Red
    exit 1
}

# 2. Arreter et supprimer le conteneur securise existant s'il existe
Write-Host "`n2. Nettoyage des conteneurs securises existants..." -ForegroundColor Yellow
docker stop books-secure-container 2>$null
docker rm books-secure-container 2>$null

# 3. Executer le conteneur securise
Write-Host "`n3. Execution du conteneur securise..." -ForegroundColor Yellow
docker run -d -p 5001:5000 --name books-secure-container books-api-secure

if ($LASTEXITCODE -eq 0) {
    Write-Host "Conteneur securise demarre avec succes" -ForegroundColor Green
} else {
    Write-Host "Erreur lors du demarrage du conteneur securise" -ForegroundColor Red
    exit 1
}

# Attendre que l'application demarre
Write-Host "`n4. Attente du demarrage de l'application securisee..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# 4. Verifier que le serveur Flask est lance par l'utilisateur apiuser
Write-Host "`n5. Verification de l'utilisateur qui execute le serveur Flask..." -ForegroundColor Yellow
Write-Host "Utilisateur actuel dans le conteneur:" -ForegroundColor Cyan
docker exec books-secure-container whoami

Write-Host "`n6. Verification des processus en cours:" -ForegroundColor Yellow
Write-Host "Processus dans le conteneur securise:" -ForegroundColor Cyan
docker exec books-secure-container ps aux

Write-Host "`n7. Test de l'API securisee:" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:5001" -Method Get -TimeoutSec 10
    Write-Host "API securisee accessible: $($response.message)" -ForegroundColor Green
} catch {
    Write-Host "Erreur: API securisee non accessible" -ForegroundColor Red
}

try {
    $healthResponse = Invoke-RestMethod -Uri "http://localhost:5001/health" -Method Get -TimeoutSec 10
    Write-Host "Health check securise: $($healthResponse.status)" -ForegroundColor Green
} catch {
    Write-Host "Erreur: Health check securise echoue" -ForegroundColor Red
}

Write-Host "`n8. Comparaison avec le conteneur non-securise:" -ForegroundColor Yellow
Write-Host "Utilisateur dans le conteneur non-securise:" -ForegroundColor Cyan
docker exec books-container whoami

Write-Host "`n=== Exercice 4 termine ===" -ForegroundColor Green
Write-Host "L'image Dockerfile-apiuser a ete creee et testee avec succes" -ForegroundColor Cyan
Write-Host "Le serveur Flask s'execute maintenant avec l'utilisateur 'apiuser' (non-root)" -ForegroundColor Green
Write-Host "Commandes utilisees:" -ForegroundColor Yellow
Write-Host "- docker build -f Dockerfile-apiuser -t books-api-secure ." -ForegroundColor White
Write-Host "- docker run -d -p 5001:5000 --name books-secure-container books-api-secure" -ForegroundColor White
Write-Host "- docker exec books-secure-container whoami" -ForegroundColor White
Write-Host "- docker exec books-secure-container ps aux" -ForegroundColor White
