class Task {
  final String id;
  final String taskBody;
  final String creationDate;
  final String importance;

  Task({
    required this.id,
    required this.taskBody,
    required this.creationDate,
    required this.importance,
  });

  String get formattedId => 'Task ID: $id';
  String get taskSummary => taskBody.length > 30 ? taskBody.substring(0, 30) + '...' : taskBody;
  String get formattedDate {
    DateTime date = DateTime.parse(creationDate);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
  String get importanceLevel => importance.toUpperCase();

  @override
  String toString() {
    return 'Task{id: $id, taskBody: $taskBody, creationDate: $creationDate, importance: $importance}';
  }
}
