class Article {
  final String uid;
  Article({this.uid});
}

class ArticleData {
  final String content;
  final date;
  final String title;
  final String uploadedBy;
  final String photoUrl;

  ArticleData({this.content, this.date, this.title, this.uploadedBy, this.photoUrl,});
}