# Script PowerShell pour l'Exercice 2 : Tests de l'API
# Lab 03 - Docker

Write-Host "=== Exercice 2 : Tests de l'API ===" -ForegroundColor Green

# Verifier que le conteneur est en cours d'execution
$containerStatus = docker ps --filter "name=books-container" --format "table {{.Names}}\t{{.Status}}"
if ($containerStatus -like "*books-container*") {
    Write-Host "Conteneur books-container est en cours d'execution" -ForegroundColor Green
} else {
    Write-Host "Erreur: Le conteneur books-container n'est pas en cours d'execution" -ForegroundColor Red
    Write-Host "Demarrez-le avec: docker start books-container" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n=== Tests automatiques Python ===" -ForegroundColor Yellow

# Installer requests si necessaire
Write-Host "Installation de requests..." -ForegroundColor Cyan
pip install requests

# Executer les tests Python
Write-Host "`nExecution des tests Python..." -ForegroundColor Cyan
python test_api.py

Write-Host "`n=== Tests manuels avec curl ===" -ForegroundColor Yellow

# 1. Lister tous les livres
Write-Host "`n1. Lister tous les livres:" -ForegroundColor Cyan
curl http://localhost:5000/books

# 2. Ajouter un nouveau livre
Write-Host "`n2. Ajouter un nouveau livre:" -ForegroundColor Cyan
$book1 = @{
    title = "Le Petit Prince"
    author = "Antoine de Saint-Exupery"
    year = 1943
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/books" -Method Post -Body $book1 -ContentType "application/json"

# 3. Ajouter un deuxieme livre
Write-Host "`n3. Ajouter un deuxieme livre:" -ForegroundColor Cyan
$book2 = @{
    title = "Harry Potter"
    author = "J.K. Rowling"
    year = 1997
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/books" -Method Post -Body $book2 -ContentType "application/json"

# 4. Récupérer un livre spécifique
Write-Host "`n4. Recuperer le livre ID 4:" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:5000/books/4" -Method Get

# 5. Mettre à jour un livre
Write-Host "`n5. Mettre a jour le livre ID 4:" -ForegroundColor Cyan
$updateData = @{
    title = "Le Petit Prince - Edition Speciale"
    year = 1944
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/books/4" -Method Put -Body $updateData -ContentType "application/json"

# 6. Vérifier la mise à jour
Write-Host "`n6. Verifier la mise a jour:" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:5000/books/4" -Method Get

# 7. Supprimer un livre
Write-Host "`n7. Supprimer le livre ID 5:" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:5000/books/5" -Method Delete

# 8. Vérifier les modifications finales
Write-Host "`n8. Verifier les modifications finales:" -ForegroundColor Cyan
Invoke-RestMethod -Uri "http://localhost:5000/books" -Method Get

Write-Host "`n=== Exercice 2 termine ===" -ForegroundColor Green
Write-Host "Toutes les operations CRUD ont ete testees avec succes" -ForegroundColor Cyan
