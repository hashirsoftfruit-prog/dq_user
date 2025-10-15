class ChatMsgModel {
  Author? author;
  int? createdAt;
  String? id;
  String? mimeType;
  String? name;
  int? size;
  String? status;
  String? text;
  String? type;
  String? uri;
  int? height;
  int? width;

  ChatMsgModel(
      {this.author,
      this.createdAt,
      this.id,
      this.mimeType,
      this.name,
      this.size,
      this.status,
      this.text,
      this.type,
      this.uri,
      this.height,
      this.width});

  ChatMsgModel.fromJson(Map<String, dynamic> json) {
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    createdAt = json['createdAt'];
    id = json['id'];
    mimeType = json['mimeType'];
    name = json['name'];
    size = json['size'];
    status = json['status'];
    text = json['text'];
    type = json['type'];
    uri = json['uri'];
    height = json['height'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['mimeType'] = mimeType;
    data['name'] = name;
    data['size'] = size;
    data['status'] = status;
    data['text'] = text;
    data['type'] = type;
    data['uri'] = uri;
    data['height'] = height;
    data['width'] = width;
    return data;
  }
}

class Author {
  String? firstName;
  String? id;
  String? lastName;

  Author({this.firstName, this.id, this.lastName});

  Author.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    id = json['id'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['id'] = id;
    data['lastName'] = lastName;
    return data;
  }
}

class ApiChatModel {
  bool? status;
  String? message;
  String? next;
  List<Messages>? messages;

  ApiChatModel({this.status, this.message, this.next, this.messages});

  ApiChatModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    message = json['next'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['status'] = next;
    data['message'] = message;
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  String? id;
  String? contentType;
  String? textMessage;
  String? imageMessage;
  String? userId;
  String? createdAt;
  String? fileName;
  int? fileSize;

  Messages(
      {this.id,
      this.contentType,
      this.textMessage,
      this.imageMessage,
      this.userId,
      this.fileName,
      this.fileSize,
      this.createdAt});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    contentType = json['content_type'];
    textMessage = json['text_message'];
    imageMessage = json['image_message'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    fileName = json['file_name'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content_type'] = contentType;
    data['text_message'] = textMessage;
    data['image_message'] = imageMessage;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['file_name'] = fileName;
    data['file_size'] = fileSize;

    return data;
  }
}
