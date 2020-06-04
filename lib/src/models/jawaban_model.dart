import 'package:equatable/equatable.dart';

class JawabanModel extends Equatable {
  final String id, jawaban, nilai;
  JawabanModel({this.id, this.jawaban, this.nilai});
  factory JawabanModel.createJawaban(Map<String, dynamic> data) {
    return JawabanModel(
        id: data['id'].toString(),
        jawaban: data['jawaban'],
        nilai: data['nilai'].toString());
  }

  @override
  // TODO: implement props
  List<Object> get props => null;
}
