class Taskentity {
  final int? id;
  final String? title;
  final String? priority;
  final String? completed;
  final String? dueDate;

  Taskentity({
    this.id,
    this.title,
    this.priority,
    this.completed,
    this.dueDate,
  });

  factory Taskentity.fromJson(Map<String, dynamic> json) {
    return Taskentity(
      id: json['id'] as int?,
      title: json['title'] as String?,
      priority: json['priority'] as String?,
      completed: json['completed'] as String?,
      dueDate: json['dueDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'completed': completed,
      'dueDate': dueDate,
    };
  }

  Taskentity copyWith({
    int? id,
    String? title,
    String? priority,
    String? completed,
    String? dueDate,
  }) {
    return Taskentity(
      id: id ?? this.id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
