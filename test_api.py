import requests
import json

BASE_URL = "http://localhost:5000"

def test_get_books():
    response = requests.get(f"{BASE_URL}/books")
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}\n")

def test_add_book():
    # Ajouter votre code ici pour tester l'ajout d'un livre
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}\n")

def test_dele_book():
    # Ajouter votre code ici pour tester la suppression d'un livre
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}\n")

if __name__ == "__main__":
    print("Testing GET books")
    test_get_books()
    
    print("Testing add a book")
    test_add_book()
    
    print("Testing GET books again")
    test_get_books()

    print("Testing the previously added book")
    test_add_book()
    
    print("Testing GET books again")
    test_get_books()
    