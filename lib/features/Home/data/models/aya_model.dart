// Aya Model
import 'package:noor_aliman/features/Home/domain/entites/aya.dart' show Aya;


class AyaModel extends Aya {
  AyaModel({required super.surah, required super.ayah, required super.text});

  factory AyaModel.fromJson(Map<String, dynamic> json) {
    return AyaModel(
      surah: json['surah'],
      ayah: json['ayah'],
      text: json['text'],
    );
  }
}