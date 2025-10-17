import requests
import json

BASE_URL = "http://localhost:5000"

def test_get_books():
    """Tester la récupération de tous les livres"""
    response = requests.get(f"{BASE_URL}/books")
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}\n")

def test_get_book(book_id):
    """Tester la récupération d'un livre spécifique"""
    response = requests.get(f"{BASE_URL}/books/{book_id}")
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}\n")

def test_add_book(title, author, year):
    """Tester l'ajout d'un nouveau livre"""
    book_data = {
        "title": title,
        "author": author,
        "year": year
    }
    response = requests.post(f"{BASE_URL}/books", json=book_data)
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}\n")
    return response.json() if response.status_code == 201 else None

def test_update_book(book_id, title=None, author=None, year=None):
    """Tester la mise à jour d'un livre"""
    update_data = {}
    if title:
        update_data["title"] = title
    if author:
        update_data["author"] = author
    if year:
        update_data["year"] = year
    
    response = requests.put(f"{BASE_URL}/books/{book_id}", json=update_data)
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}\n")

def test_delete_book(book_id):
    """Tester la suppression d'un livre"""
    response = requests.delete(f"{BASE_URL}/books/{book_id}")
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}\n")

if __name__ == "__main__":
    print("=== Testing Books API ===\n")
    
    print("1. Testing GET all books")
    test_get_books()
    
    print("2. Testing add first book")
    book1 = test_add_book("The Lord of the Rings", "J.R.R. Tolkien", 1954)
    
    print("3. Testing add second book")
    book2 = test_add_book("Dune", "Frank Herbert", 1965)
    
    print("4. Testing GET all books after adding")
    test_get_books()
    
    if book1:
        print("5. Testing GET specific book")
        test_get_book(book1["id"])
        
        print("6. Testing UPDATE book")
        test_update_book(book1["id"], title="The Lord of the Rings - Special Edition", year=1955)
        
        print("7. Testing GET updated book")
        test_get_book(book1["id"])
    
    if book2:
        print("8. Testing DELETE book")
        test_delete_book(book2["id"])
    
    print("9. Testing GET all books after deletion")
    test_get_books()
    