class Article {
  final String uid;
  Article({this.uid});
}

class ArticleData {
  final String content;
  final int timeStamp;
  final String title;
  final String uploadedBy;
  final String photoUrl;

  ArticleData({this.content, this.timeStamp, this.title, this.uploadedBy, this.photoUrl,});
}