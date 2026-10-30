/// Student Assignment Model
class AssignmentModel {
  final String id;
  final String title;
  final String subject;
  final String dueDate;
  final String priority; // 'High', 'Medium', 'Low'
  final bool isCompleted;
  final String notes;

  const AssignmentModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.priority = 'Medium',
    this.isCompleted = false,
    this.notes = '',
  });

  AssignmentModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? dueDate,
    String? priority,
    bool? isCompleted,
    String? notes,
  }) {
    return AssignmentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}
