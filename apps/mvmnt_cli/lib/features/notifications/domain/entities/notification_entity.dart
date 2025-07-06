class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final Map<String, dynamic> data;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.data,
  });
}
