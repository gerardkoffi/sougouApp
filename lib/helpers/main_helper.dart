
const jwtToken = '20000';
Map<String, String> get commonHeader => {
  'Authorization': 'Bearer $jwtToken',
  'Accept': 'application/json',
};
