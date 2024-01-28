class HomeItemData {
  final dynamic docid;
  final dynamic name;
  final dynamic des;
  final dynamic image;
  final dynamic date;
  final dynamic isVideo;

  HomeItemData(
      {this.docid,
        required this.des,
        required this.name,
        required this.image,
        required this.date,
        required this.isVideo
      });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'des': des,
      'docid': docid,
      'date': date,
      'isVideo': isVideo,
    };
  }

  factory HomeItemData.fromMap(Map<String, dynamic> map) {
    return HomeItemData(
      name: map['name'],
      des: map['des'],
      image: map['image'],
      docid: map['docid'],
      date: map['date'],
      isVideo: map['isVideo'],
    );
  }
}
