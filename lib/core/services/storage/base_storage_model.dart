abstract class BaseStorageModel<T> {
  Map<String, dynamic> toJson();

  T fromJson(Map<String, dynamic> json);
}
