import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final _genericNameTextboxController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _searchByGenericName(String genericName) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final url =
        'https://api.fda.gov/drug/label.json?search=openfda.generic_name:"$genericName"';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _searchResults =
          List<Map<String, dynamic>>.from(data['results'] ?? []);
        });
      } else {
        setState(() {
          _error = 'Error: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _genericNameTextField(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final genericName = _genericNameTextboxController.text.trim();
                if (genericName.isNotEmpty) {
                  _searchByGenericName(genericName);
                }
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_searchResults.isNotEmpty) _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _genericNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Generic Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _genericNameTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Generic name obat harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buildSearchResults() {
    return Expanded(
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final result = _searchResults[index];
          return Card(
            child: ListTile(
              title: Text(
                  result['openfda']['generic_name']?.join('') ?? 'Unknown'),
              subtitle:
              Text(result['purpose']?.join(', ') ?? 'No purpose provided'),
            ),
          );
        },
      ),
    );
  }
}