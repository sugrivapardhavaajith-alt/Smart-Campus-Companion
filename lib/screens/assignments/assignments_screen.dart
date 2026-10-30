import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/assignment_model.dart';
import '../../state/app_state.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';

/// Screen 7: Assignment Planner with Interactive Checkboxes, Completion Progress, and Add Task Dialog
class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  String _selectedTab = 'All'; // All | Pending | Completed

  void _showAddAssignmentDialog(BuildContext context, AppState appState) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    final notesController = TextEditingController();
    String selectedPriority = 'High';
    String selectedDueDate = 'Due in 3 Days';

    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.add_task_rounded,
                    color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'New Assignment',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 400,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Assignment Title *',
                            hintText: 'e.g. Implement Dijkstra\'s Algorithm',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter assignment title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Subject
                        TextFormField(
                          controller: subjectController,
                          decoration: const InputDecoration(
                            labelText: 'Subject / Course *',
                            hintText: 'e.g. Data Structures & Algorithms',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter course name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Priority Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedPriority,
                          decoration: const InputDecoration(
                            labelText: 'Priority Level',
                          ),
                          items: AppConstants.priorityLevels.map((p) {
                            return DropdownMenuItem(
                              value: p,
                              child: Text(p),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedPriority = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 14),

                        // Due Date Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedDueDate,
                          decoration: const InputDecoration(
                            labelText: 'Due Deadline',
                          ),
                          items: [
                            'Due Tomorrow',
                            'Due in 2 Days',
                            'Due in 3 Days',
                            'Due in 5 Days',
                            'Due Next Week',
                          ].map((d) {
                            return DropdownMenuItem(
                              value: d,
                              child: Text(d),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedDueDate = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 14),

                        // Optional Notes
                        TextFormField(
                          controller: notesController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Notes (Optional)',
                            hintText: 'Rubric or submission instructions...',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      appState.addAssignment(
                        title: titleController.text.trim(),
                        subject: subjectController.text.trim(),
                        dueDate: selectedDueDate,
                        priority: selectedPriority,
                        notes: notesController.text.trim(),
                      );
                      Navigator.of(dialogContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added "${titleController.text.trim()}" successfully!'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final assignments = appState.assignments;
    final filtered = assignments.where((a) {
      if (_selectedTab == 'Pending') return !a.isCompleted;
      if (_selectedTab == 'Completed') return a.isCompleted;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Planner'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () => _showAddAssignmentDialog(context, appState),
            tooltip: 'Add Assignment',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAssignmentDialog(context, appState),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Task'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress Summary Banner
                      _buildSummaryCard(appState, isDark),

                      const SizedBox(height: 24),

                      // Status Tab Chips (All | Pending | Completed)
                      SectionHeader(
                        title: 'My Coursework',
                        subtitle: '${filtered.length} tasks in view',
                        icon: Icons.checklist_rounded,
                      ),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _buildTabChip('All (${assignments.length})', 'All'),
                          _buildTabChip('Pending (${appState.pendingAssignmentsCount})', 'Pending'),
                          _buildTabChip('Completed (${appState.completedAssignmentsCount})', 'Completed'),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Assignments List
                      if (filtered.isEmpty)
                        _buildEmptyState(isDark)
                      else
                        ...filtered.map((item) => _buildAssignmentItem(context, item, appState, isDark)),

                      const SizedBox(height: 80), // Padding for FAB
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabChip(String label, String value) {
    final isSelected = _selectedTab == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedTab = value;
          });
        }
      },
    );
  }

  Widget _buildSummaryCard(AppState appState, bool isDark) {
    final progress = appState.assignmentProgress;
    final percent = (progress * 100).toInt();

    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Semester Coursework Progress',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${appState.completedAssignmentsCount} of ${appState.assignments.length} assignments completed',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percent%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // LinearProgressIndicator
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: isDark ? AppColors.surfaceDarkElevated : AppColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 14),

          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _buildMiniMetric(
                '${appState.pendingAssignmentsCount}',
                'Pending Deliverables',
                AppColors.warning,
                isDark,
              ),
              _buildMiniMetric(
                '${appState.completedAssignmentsCount}',
                'Completed & Verified',
                AppColors.success,
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(String value, String label, Color color, bool isDark) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAssignmentItem(
    BuildContext context,
    AssignmentModel item,
    AppState appState,
    bool isDark,
  ) {
    Color priorityColor;
    switch (item.priority.toLowerCase()) {
      case 'high':
        priorityColor = AppColors.error;
        break;
      case 'medium':
        priorityColor = AppColors.warning;
        break;
      default:
        priorityColor = AppColors.info;
        break;
    }

    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      backgroundColor: item.isCompleted
          ? (isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.6)
              : AppColors.backgroundLight)
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Interactive Checkbox
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Checkbox(
              value: item.isCompleted,
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              onChanged: (val) {
                appState.toggleAssignmentCompletion(item.id);
              },
            ),
          ),
          const SizedBox(width: 8),

          // Assignment Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject + Priority Tag
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.subject,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${item.priority} Priority',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: priorityColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Assignment Title (Strikethrough if completed)
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                    color: item.isCompleted
                        ? (isDark ? AppColors.textMutedLight : AppColors.textSecondaryLight)
                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  ),
                ),

                if (item.notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.notes,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textMutedLight : AppColors.textSecondaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 8),

                // Due Date Meta
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 13,
                      color: isDark ? AppColors.textMutedLight : AppColors.textSecondaryLight,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.dueDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textMutedLight : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete Action
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
            onPressed: () {
              appState.deleteAssignment(item.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Assignment removed.'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Remove task',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.task_alt_rounded,
              size: 44,
              color: AppColors.success,
            ),
            const SizedBox(height: 12),
            Text(
              'No Assignments in This View',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'All tasks in this category are completed or none have been assigned yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
