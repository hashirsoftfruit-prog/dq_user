class MeditationVideosModel {
  bool? status;
  String? message;
  List<VideoFiles>? videoFiles;
  int? count;
  int? next;
  int? previous;
  int? currentPage;
  int? totalPages;
  int? pageSize;

  MeditationVideosModel(
      {this.status,
      this.message,
      this.videoFiles,
      this.count,
      this.next,
      this.previous,
      this.currentPage,
      this.totalPages,
      this.pageSize});

  MeditationVideosModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['video_files'] != null) {
      videoFiles = <VideoFiles>[];
      json['video_files'].forEach((v) {
        videoFiles!.add(VideoFiles.fromJson(v));
      });
    }
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (videoFiles != null) {
      data['video_files'] = videoFiles!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    data['page_size'] = pageSize;
    return data;
  }
}

class VideoFiles {
  int? id;
  String? title;
  String? subTitle;
  String? mediaType;
  String? thumbnailImage;
  int? mediaSource;
  String? mediaDuration;
  String? youtubeLink;
  String? file;

  VideoFiles(
      {this.id,
      this.title,
      this.mediaType,
      this.subTitle,
      this.mediaSource,
      this.thumbnailImage,
      this.mediaDuration,
      this.youtubeLink,
      this.file});

  VideoFiles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mediaType = json['media_type'];
    thumbnailImage = json['thumbnail_image'];
    subTitle = json['sub_title'];
    mediaSource = json['media_source'];
    mediaDuration = json['media_duration'];
    // artist = json['artist'];
    youtubeLink = json['youtube_link'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['media_type'] = mediaType;
    data['thumbnail_image'] = thumbnailImage;
    data['media_source'] = mediaSource;
    data['media_duration'] = mediaDuration;
    data['sub_title'] = subTitle;
    // data['artist'] = this.artist;
    data['youtube_link'] = youtubeLink;
    data['file'] = file;
    return data;
  }
}

class MeditationAudiosModel {
  bool? status;
  String? message;
  List<AudioFile>? audioFiles;
  int? count;
  int? next;
  int? previous;
  int? currentPage;
  int? totalPages;
  int? pageSize;

  MeditationAudiosModel(
      {this.status,
      this.message,
      this.audioFiles,
      this.count,
      this.next,
      this.previous,
      this.currentPage,
      this.totalPages,
      this.pageSize});

  MeditationAudiosModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['audio_files'] != null) {
      audioFiles = <AudioFile>[];
      json['audio_files'].forEach((v) {
        audioFiles!.add(AudioFile.fromJson(v));
      });
    }
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (audioFiles != null) {
      data['audio_files'] = audioFiles!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    data['page_size'] = pageSize;
    return data;
  }
}

class AudioFile {
  int? id;
  String? title;
  String? subTitle;
  String? mediaType;
  String? artist;
  String? thumbnailImage;
  int? mediaSource;
  String? mediaDuration;
  String? file;

  AudioFile(
      {this.id,
      this.title,
      this.mediaType,
      this.subTitle,
      this.mediaSource,
      this.thumbnailImage,
      this.mediaDuration,
      this.artist,
      this.file});

  AudioFile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mediaType = json['media_type'];
    thumbnailImage = json['thumbnail_image'];
    subTitle = json['sub_title'];
    mediaSource = json['media_source'];
    mediaDuration = json['media_duration'];
    // artist = json['artist'];
    artist = json['artist'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['media_type'] = mediaType;
    data['thumbnail_image'] = thumbnailImage;
    data['media_source'] = mediaSource;
    data['media_duration'] = mediaDuration;
    data['sub_title'] = subTitle;
    // data['artist'] = this.artist;
    data['artist'] = artist;
    data['file'] = file;
    return data;
  }
}
