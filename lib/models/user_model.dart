class UserModel {
  late String userName ;
  late String email ;
  late String password ;

  UserModel({
    required this.userName ,
    required this.email ,
    required this.password});

  UserModel.fromJson(Map<String , dynamic> json){
    userName = json['userName'] as String ;
    email = json['email'] as String ;
    password = json['password'] as String ;;
  }

  Future<Map<String, dynamic>> toJson() async {
    return {
        userName: '',
        email: '',
        password: ''
    };
    }
  }



