// lib/views/book_list_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/book_view_model.dart';
import '../models/book_model.dart';
import 'add_edit_book_dialog.dart';

/// Main view that displays all books in the library
/// Connects to BookViewModel to get and manipulate data
class BookListView extends StatelessWidget {
  const BookListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Book Library'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Consumer<BookViewModel>(
        builder: (context, viewModel, child) {
          // Shows message if no books, otherwise displays list
          if (viewModel.books.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Your library is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Tap + to add your first book',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: viewModel.books.length,
            itemBuilder: (context, index) {
              final book = viewModel.books[index];
              return _buildBookItem(context, viewModel, book, index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBookDialog(context),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        tooltip: 'Add New Book',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  /// Builds a single book item in the list
  /// Shows book details and provides edit/delete options
  Widget _buildBookItem(BuildContext context, BookViewModel viewModel, BookModel book, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: _buildReadIndicator(book.isRead),
        title: Text(
          book.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: book.isRead ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Author: ${book.author}'),
            Text('Published: ${book.yearPublished}'),
            Text(
              book.isRead ? 'Status: Read ✓' : 'Status: Unread',
              style: TextStyle(
                color: book.isRead ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Toggle read status button
            IconButton(
              onPressed: () => viewModel.toggleReadStatus(index),
              icon: Icon(
                book.isRead ? Icons.bookmark_remove : Icons.bookmark_added,
                color: book.isRead ? Colors.green : Colors.blue,
              ),
              tooltip: book.isRead ? 'Mark as unread' : 'Mark as read',
            ),
            // Edit button
            IconButton(
              onPressed: () => _showEditBookDialog(context, viewModel, book, index),
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Edit Book',
            ),
            // Delete button
            IconButton(
              onPressed: () => _showDeleteConfirmation(context, viewModel, index),
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Delete Book',
            ),
          ],
        ),
        onTap: () => viewModel.toggleReadStatus(index),
      ),
    );
  }
  
  /// Visual indicator for read/unread status
  Widget _buildReadIndicator(bool isRead) {
    return CircleAvatar(
      backgroundColor: isRead ? Colors.green[100] : Colors.orange[100],
      child: Icon(
        isRead ? Icons.check_circle : Icons.circle,
        color: isRead ? Colors.green : Colors.orange,
      ),
    );
  }
  
  /// Shows dialog for adding a new book
  void _showAddBookDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddEditBookDialog(isEditing: false),
    );
  }
  
  /// Shows dialog for editing an existing book
  void _showEditBookDialog(BuildContext context, BookViewModel viewModel, BookModel book, int index) {
    showDialog(
      context: context,
      builder: (context) => AddEditBookDialog(
        isEditing: true,
        book: book,
        index: index,
      ),
    );
  }
  
  /// Confirms before deleting a book
  void _showDeleteConfirmation(BuildContext context, BookViewModel viewModel, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteBook(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Book deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}