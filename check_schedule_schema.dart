import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('openapi.json');
  final jsonString = await file.readAsString();
  final data = jsonDecode(jsonString);
  
  final paths = data['paths'] as Map<String, dynamic>;
  final endpoint = paths['/doctor-system/schedule'];
  if (endpoint == null) {
    print('Endpoint not found');
    return;
  }
  final getMethod = endpoint['get'] as Map<String, dynamic>?;
  if (getMethod == null) {
    print('GET method not found');
    return;
  }
  print(jsonEncode(getMethod['responses']));
}
