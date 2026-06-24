import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/publication.dart';
import '../models/trend_data.dart';

class OpenAlexService {
  static const String baseUrl = 'https://api.openalex.org/works';

  // 1. Search publications
  Future<List<Publication>> searchPublications(String topic, {int perPage = 25}) async {
    // Add sorting by citation count to get the most influential papers for the topic
    final url = Uri.parse('$baseUrl?search=$topic&sort=cited_by_count:desc&per-page=$perPage');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => Publication.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load publications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching publications: $e');
    }
  }

  // 2. Get Trend Data using group_by
  Future<List<TrendData>> getTrendData(String topic, String groupBy) async {
    final url = Uri.parse('$baseUrl?search=$topic&group_by=$groupBy');
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> groups = data['group_by'] ?? [];
        return groups.map((json) => TrendData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trend data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching trend data: $e');
    }
  }

  // Helper methods for specific trends
  Future<List<TrendData>> getYearlyTrends(String topic) {
    return getTrendData(topic, 'publication_year');
  }

  Future<List<TrendData>> getTopAuthors(String topic) {
    return getTrendData(topic, 'authorships.author.id');
  }

  Future<List<TrendData>> getTopJournals(String topic) {
    return getTrendData(topic, 'primary_location.source.id');
  }
}
