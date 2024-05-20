class SleepMediaItem {
  String? title;
  String? imgUrl;
  String? mediaUrl;
  List? listSound;
  SleepMediaCategory? category;
  bool? isFavorite;

  SleepMediaItem({
    required this.title,
    required this.category,
    required this.imgUrl,
    required this.mediaUrl,
    required this.listSound,
    required this.isFavorite,
  });
  @override
  String toString() {
    return 'SleepMediaItem(title: $title, mediaUrl: $mediaUrl, img: $imgUrl)';
  }
  SleepMediaItem.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    imgUrl = json["imgUrl"];
    mediaUrl = json["mediaUrl"];
    listSound = json["listSound"];
    category = json["category"] == null
        ? null
        : SleepMediaCategory.fromJson(json["category"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["imgUrl"] = imgUrl;
    data["mediaUrl"] = mediaUrl;
    data["listSound"] = listSound;
    data["category"] = category!.toJson();
    return data;
  }
}

class SleepMediaCategory {
  late int id;
  late String name;
  SleepMediaCategory({
    required this.id,
    required this.name,
  });
  SleepMediaCategory.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    return data;
  }
}
