import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('openapi.json');
  final jsonString = await file.readAsString();
  final data = jsonDecode(jsonString);
  
  // List all paths
  final paths = data['paths'] as Map<String, dynamic>;
  for (final p in paths.keys) {
    if (p.contains('doctor-system')) {
      print('\n=== $p ===');
      final methods = paths[p] as Map<String, dynamic>;
      for (final method in methods.keys) {
        print('  METHOD: $method');
        final methodData = methods[method];
        if (methodData['parameters'] != null) {
          print('  PARAMS: ${jsonEncode(methodData['parameters'])}');
        }
        if (methodData['responses'] != null) {
          print('  RESPONSES: ${methodData['responses'].keys}');
        }
      }
    }
  }
}
