import 'package:flutter/material.dart';
import '../models/location_model.dart';

class LocationDialog extends StatelessWidget {
  final List<SavedLocation> locations;
  final Function(SavedLocation) onLocationSelected;
  final Function(SavedLocation) onLocationDeleted;
  final Function() onAddNewLocation;

  const LocationDialog({
    super.key,
    required this.locations,
    required this.onLocationSelected,
    required this.onLocationDeleted,
    required this.onAddNewLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Saved Locations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (locations.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('No locations saved yet'),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    return _buildLocationItem(context, location);
                  },
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAddNewLocation,
              icon: const Icon(Icons.add),
              label: const Text('Add New Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem(BuildContext context, SavedLocation location) {
    return Dismissible(
      key: Key(location.cityName),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmation(context, location);
      },
      onDismissed: (direction) {
        onLocationDeleted(location);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: const Icon(Icons.location_city, color: Colors.blue),
          title: Text(
            location.cityName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(location.country.isNotEmpty ? location.country : 'Unknown country'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteConfirmation(context, location)
                .then((confirmed) {
              if (confirmed == true) {
                onLocationDeleted(location);
              }
            }),
          ),
          onTap: () {
            Navigator.pop(context);
            onLocationSelected(location);
          },
        ),
      ),
    );
  }

  // ADD THIS MISSING METHOD
  Future<bool?> _showDeleteConfirmation(BuildContext context, SavedLocation location) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Location'),
        content: Text('Are you sure you want to delete ${location.cityName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}