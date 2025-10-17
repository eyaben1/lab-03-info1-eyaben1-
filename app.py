from flask import Flask, jsonify, request
from datetime import datetime

app = Flask(__name__)

# In-memory database
books = [
    {"id": 1, "title": "1984", "author": "George Orwell", "year": 1949},
    {"id": 2, "title": "To Kill a Mockingbird", "author": "Harper Lee", "year": 1960},
    {"id": 3, "title": "The Great Gatsby", "author": "F. Scott Fitzgerald", "year": 1925}
]

@app.route('/')
def home():
    return jsonify({
        "message": "Welcome to the Books API",
        "version": "1.0",
        "endpoints": {
            "GET /books": "List all books",
            "GET /books/<id>": "Get a specific book",
            "POST /books": "Add a new book",
            "PUT /books/<id>": "Update a book",
            "DELETE /books/<id>": "Delete a book",
            "GET /health": "Health check"
        }
    })

@app.route('/health')
def health():
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.now().isoformat()
    })

@app.route('/books', methods=['GET'])
def get_books():
    return jsonify({"books": books, "count": len(books)})

@app.route('/books/<int:book_id>', methods=['GET'])
def get_book(book_id):
    book = next((b for b in books if b["id"] == book_id), None)
    if book:
        return jsonify(book)
    return jsonify({"error": "Book not found"}), 404

@app.route('/books', methods=['POST'])
def add_book():
    if not request.json or not all(k in request.json for k in ['title', 'author', 'year']):
        return jsonify({"error": "Missing required fields"}), 400
    
    new_book = {
        "id": max([b["id"] for b in books]) + 1 if books else 1,
        "title": request.json['title'],
        "author": request.json['author'],
        "year": request.json['year']
    }
    books.append(new_book)
    return jsonify(new_book), 201

@app.route('/books/<int:book_id>', methods=['PUT'])
def update_book(book_id):
    book = next((b for b in books if b["id"] == book_id), None)
    if not book:
        return jsonify({"error": "Book not found"}), 404
    
    if request.json:
        book.update({k: v for k, v in request.json.items() if k in ['title', 'author', 'year']})
    return jsonify(book)

@app.route('/books/<int:book_id>', methods=['DELETE'])
def delete_book(book_id):
    global books
    book = next((b for b in books if b["id"] == book_id), None)
    if not book:
        return jsonify({"error": "Book not found"}), 404
    
    books = [b for b in books if b["id"] != book_id]
    return jsonify({"message": "Book deleted successfully"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)