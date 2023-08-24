class PageResult {
  dynamic data;
  bool isCreated;
  bool isDeleted;
  bool isUpdated;
  String? toastMsg;

  PageResult({
    this.data,
    this.isDeleted = false,
    this.isCreated = false,
    this.isUpdated = false,
    this.toastMsg,
  });
}
