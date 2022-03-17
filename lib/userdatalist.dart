class userlist {
  String _type;
  String _sId;
  String _userId;
  String _name;
  String _txId;
  String _hash;
  String _originalDocHash;
  String _blockchainId;
  String _code;
  String _createdAt;
  String _updatedAt;

  userlist(
      {String type,
      String sId,
      String userId,
      String name,
      String txId,
      String hash,
      String originalDocHash,
      String blockchainId,
      String code,
      String createdAt,
      String updatedAt}) {
    this._type = type;
    this._sId = sId;
    this._userId = userId;
    this._name = name;
    this._txId = txId;
    this._hash = hash;
    this._originalDocHash = originalDocHash;
    this._blockchainId = blockchainId;
    this.code = code;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  String get type => _type;
  set type(String type) => _type = type;
  String get sId => _sId;
  set sId(String sId) => _sId = sId;
  String get userId => _userId;
  set userId(String userId) => _userId = userId;
  String get name => _name;
  set name(String name) => _name = name;
  String get txId => _txId;
  set txId(String txId) => _txId = txId;
  String get hash => _hash;
  set hash(String hash) => _hash = hash;

  String get originalDocHash => _originalDocHash;
  set originalDocHash(String originalDocHash) =>
      _originalDocHash = originalDocHash;

  String get blockchainId => _blockchainId;
  set blockchainId(String blockchainId) => _blockchainId = blockchainId;
  String get code => _code;
  set code(String code) => _code = code;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;

  userlist.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _sId = json['_id'];
    _userId = json['userId'];
    _name = json['name'];
    _txId = json['txId'];
    _hash = json['hash'];
    _originalDocHash = json['originalDocHash'];
    _blockchainId = json['blockchainId'];
    _code = json['code'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    data['_id'] = this._sId;
    data['userId'] = this._userId;
    data['name'] = this._name;
    data['txId'] = this._txId;
    data['hash'] = this._hash;
    data['originalDocHash'] = this._originalDocHash;
    data['blockchainId'] = this._blockchainId;
    data['code'] = this._code;
    data['createdAt'] = this._createdAt;
    data['updatedAt'] = this._updatedAt;
    return data;
  }
}
