class AppConfig {
  final String schema;
  final String host;
  final int? port;

  AppConfig({
    required this.schema,
    required this.host,
    this.port,
  });
}
