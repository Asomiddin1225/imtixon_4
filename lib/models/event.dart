
class Event {
  String id;
  String name;
  String date;
  String time;
  String description;
  String imageUrl;
  String location;
  String userId;
  bool isCancelled; // Add this line

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.userId,
    this.isCancelled = false, // Initialize the new property
  });

  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    return Event(
      id: documentId,
      name: data['name'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      location: data['location'] ?? '',
      userId: data['userId'] ?? '',
      isCancelled: data['isCancelled'] ?? false, // Add this line
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'time': time,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'userId': userId,
      'isCancelled': isCancelled, // Add this line
    };
  }
}
