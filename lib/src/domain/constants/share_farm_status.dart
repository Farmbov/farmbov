enum ShareFarmStatus {
  pending,
  accepted,
  declined,
  canceled;

  String toMap() => name;
  static ShareFarmStatus fromJson(String json) => values.byName(json);
}
