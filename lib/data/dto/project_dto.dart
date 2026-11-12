class ProjectDto {
  final int id;
  final String title;
  final String description;
  final String category;
  final double collected;
  final double target;
  final String icon;

  ProjectDto({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.collected,
    required this.target,
    required this.icon,
  });

  factory ProjectDto.fromJson(Map<String, dynamic> json) {
    return ProjectDto(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Без названия',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      // На бэке числа могут приходить как int, поэтому приводим к double
      collected: (json['collected'] as num? ?? 0).toDouble(),
      target: (json['target'] as num? ?? 0).toDouble(),
      icon: json['icon'] as String? ?? '❤️',
    );
  }
}