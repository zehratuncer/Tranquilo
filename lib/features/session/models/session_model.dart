class SessionModel {
  final String id;
  final String userId;
  final String worryText;
  final int? intensityBefore;
  final int? intensityAfter;
  final List<String> prompts;
  final Map<String, String> answers;
  final String? smallAction;
  final String? aiReliefMessage;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool isSynced;

  const SessionModel({
    required this.id,
    required this.userId,
    required this.worryText,
    this.intensityBefore,
    this.intensityAfter,
    this.prompts = const [],
    this.answers = const {},
    this.smallAction,
    this.aiReliefMessage,
    required this.createdAt,
    this.completedAt,
    this.isSynced = false,
  });

  SessionModel copyWith({
    String? id,
    String? userId,
    String? worryText,
    int? intensityBefore,
    int? intensityAfter,
    List<String>? prompts,
    Map<String, String>? answers,
    String? smallAction,
    String? aiReliefMessage,
    DateTime? createdAt,
    DateTime? completedAt,
    bool? isSynced,
  }) {
    return SessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      worryText: worryText ?? this.worryText,
      intensityBefore: intensityBefore ?? this.intensityBefore,
      intensityAfter: intensityAfter ?? this.intensityAfter,
      prompts: prompts ?? this.prompts,
      answers: answers ?? this.answers,
      smallAction: smallAction ?? this.smallAction,
      aiReliefMessage: aiReliefMessage ?? this.aiReliefMessage,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'worry_text': worryText,
      'intensity_before': intensityBefore,
      'intensity_after': intensityAfter,
      'prompts': prompts,
      'answers': answers,
      'small_action': smallAction,
      'ai_relief_message': aiReliefMessage,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'] as String,
      userId: map['user_id'] as String? ?? 'anonymous',
      worryText: map['worry_text'] as String,
      intensityBefore: map['intensity_before'] as int?,
      intensityAfter: map['intensity_after'] as int?,
      prompts: List<String>.from(map['prompts'] as List? ?? []),
      answers: Map<String, String>.from(map['answers'] as Map? ?? {}),
      smallAction: map['small_action'] as String?,
      aiReliefMessage: map['ai_relief_message'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at'] as String) : null,
      isSynced: map['is_synced'] as bool? ?? false,
    );
  }
}
