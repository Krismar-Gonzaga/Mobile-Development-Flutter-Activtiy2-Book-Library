// lib/models/book_model.dart

/// BookModel represents a book in the library.
/// This is the data model that holds the book information.
class BookModel {
  /// Title of the book
  final String title;
  
  /// Author of the book
  final String author;
  
  /// Year the book was published
  final int yearPublished;
  
  /// Whether the user has read the book
  bool isRead;
  
  /// Constructor for creating a new BookModel instance
  /// 
  /// [title] and [author] are required strings
  /// [yearPublished] is the publication year
  /// [isRead] indicates if the book has been read (defaults to false)
  BookModel({
    required this.title,
    required this.author,
    required this.yearPublished,
    this.isRead = false,
  });
  
  /// Creates a copy of the book with updated values
  /// Useful for editing books while maintaining immutability
  BookModel copyWith({
    String? title,
    String? author,
    int? yearPublished,
    bool? isRead,
  }) {
    return BookModel(
      title: title ?? this.title,
      author: author ?? this.author,
      yearPublished: yearPublished ?? this.yearPublished,
      isRead: isRead ?? this.isRead,
    );
  }
}