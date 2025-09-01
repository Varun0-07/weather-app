import 'package:flutter/material.dart';

class AddLocationDialog extends StatefulWidget {
  final Function(String) onCityAdded; // Callback to add city

  const AddLocationDialog({super.key, required this.onCityAdded});

  @override
  State<AddLocationDialog> createState() => _AddLocationDialogState();
}

class _AddLocationDialogState extends State<AddLocationDialog> {
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add New Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City Name',
                border: OutlineInputBorder(),
                hintText: 'e.g., London, New York, Tokyo',
              ),
              onSubmitted: (_) => _addLocation(),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _addLocation,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _addLocation() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      widget.onCityAdded(city);
      Navigator.pop(context);
    } catch (e) {
      // Error will be handled by the parent
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}