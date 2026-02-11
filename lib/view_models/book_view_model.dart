
import 'package:flutter/foundation.dart';
import '../models/book_model.dart';

/// BookViewModel handles the business logic for book operations.
/// It manages the state of books and notifies listeners when changes occur.
class BookViewModel extends ChangeNotifier {
  /// Private list to store all books
  /// Using private variable (_books) to encapsulate the data
  final List<BookModel> _books = [];
  
  /// Getter to provide read-only access to books
  /// Returns a copy of the list to prevent external modifications
  List<BookModel> get books => List.from(_books);
  
  /// Adds a new book to the library
  /// 
  /// book - The BookModel to add to the collection
  /// After adding, notifies all listeners that data has changed
  void addBook(BookModel book) {
    _books.add(book);
    notifyListeners(); // Updates all listening widgets
  }
  
  /// Updates an existing book at the specified index
  /// index - Position of the book in the list
  /// updatedBook - New book data to replace the old one
  /// Replaces the book and notifies listeners of the change
  void updateBook(int index, BookModel updatedBook) {
    if (index >= 0 && index < _books.length) {
      _books[index] = updatedBook;
      notifyListeners();
    }
  }
  
  /// Removes a book from the library
  /// index - Position of the book to remove
  /// Deletes the book and updates all widgets
  void deleteBook(int index) {
    if (index >= 0 && index < _books.length) {
      _books.removeAt(index);
      notifyListeners();
    }
  }
  
  /// Toggles the read status of a book
  /// 
  /// [index] - Position of the book to update
  /// Changes isRead status and notifies listeners
  void toggleReadStatus(int index) {
    if (index >= 0 && index < _books.length) {
      _books[index].isRead = !_books[index].isRead;
      notifyListeners();
    }
  }
}