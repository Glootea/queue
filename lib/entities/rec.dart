final class RecEntity {
  final String userName;
  final String lessonName;
  final DateTime time;
  final bool? isUploaded;
  @override
  bool operator ==(Object other) {
    if (other is RecEntity) {
      if (identical(this, other)) return true;
      if (time == other.time && userName == other.userName) return true;
      return false;
    }
    return false;
  }

  RecEntity(this.userName, this.time, this.lessonName, [this.isUploaded]);

  @override
  int get hashCode => userName.hashCode * time.hashCode;
}
