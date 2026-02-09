// lib/views/add_edit_book_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/book_view_model.dart';
import '../models/book_model.dart';

/// Dialog for adding or editing books
/// Reusable component that handles both creation and modification
class AddEditBookDialog extends StatefulWidget {
  final bool isEditing;
  final BookModel? book;
  final int? index;
  
  const AddEditBookDialog({
    super.key,
    required this.isEditing,
    this.book,
    this.index,
  });
  
  @override
  State<AddEditBookDialog> createState() => _AddEditBookDialogState();
}

class _AddEditBookDialogState extends State<AddEditBookDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _yearController = TextEditingController();
  bool _isRead = false;
  
  @override
  void initState() {
    super.initState();
    // Pre-fill fields if editing existing book
    if (widget.isEditing && widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _yearController.text = widget.book!.yearPublished.toString();
      _isRead = widget.book!.isRead;
    }
  }
  
  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Edit Book' : 'Add New Book'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Book Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a book title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the author name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Year Published',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the publication year';
                  }
                  final year = int.tryParse(value);
                  if (year == null) {
                    return 'Please enter a valid year';
                  }
                  if (year < 0 || year > DateTime.now().year) {
                    return 'Please enter a valid year';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isRead,
                    onChanged: (value) {
                      setState(() {
                        _isRead = value!;
                      });
                    },
                  ),
                  const Text('I have read this book'),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveBook,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
          ),
          child: Text(widget.isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
  
  /// Validates and saves the book data
  void _saveBook() {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<BookViewModel>(context, listen: false);
      final newBook = BookModel(
        title: _titleController.text,
        author: _authorController.text,
        yearPublished: int.parse(_yearController.text),
        isRead: _isRead,
      );
      
      if (widget.isEditing && widget.index != null) {
        viewModel.updateBook(widget.index!, newBook);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        viewModel.addBook(newBook);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      Navigator.pop(context);
    }
  }
}