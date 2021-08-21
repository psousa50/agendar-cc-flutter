import 'models.dart';

Map<T, List<IrnTable>> groupTables<T>(
    IrnTables tables, T groupedBy(IrnTable t)) {
  Map<T, List<IrnTable>> grouped = {};
  tables.forEach((t) {
    var key = groupedBy(t);
    if (!grouped.containsKey(key)) {
      grouped[key] = [];
    }
    grouped[key]!.add(t);
  });

  return grouped;
}
