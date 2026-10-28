class Word {
  final String en, uz, example, level;
  Word(this.en, this.uz, this.example, this.level);

  
  Map<String, String> toJson() => {
        'en': en,
        'uz': uz,
        'example': example,
        'level': level,
      };

  
  factory Word.fromJson(Map<String, dynamic> json) => Word(
        json['en'] as String,
        json['uz'] as String,
        json['example'] as String,
        json['level'] as String,
      );
}