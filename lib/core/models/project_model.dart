import 'package:hive_flutter/adapters.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class ProjectModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? path;
  @HiveField(2)
  String? branch;
  @HiveField(3)
  bool? ios = false;
  @HiveField(4)
  bool? android = false;
  String? projectName;
  String? version;

  ProjectModel({this.android, this.branch, this.id, this.ios, this.path});
}
