class TrendData {
  final String label;
  final int count;

  TrendData({
    required this.label,
    required this.count,
  });

  factory TrendData.fromJson(Map<String, dynamic> json) {
    return TrendData(
      label: json['key_display_name'] ?? json['key'] ?? 'Unknown',
      count: json['count'] ?? 0,
    );
  }
}
