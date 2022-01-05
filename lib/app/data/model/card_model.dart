final String tableCards = 'cards';

class CardFields {
  static final List<String> values = [
    id,
    name,
    number,
    expDate,
    cvvNumber,
    cardType,
    cardManufacturer,
    cardColor
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String number = 'number';
  static final String expDate = 'expDate';
  static final String cvvNumber = 'cvvNumber';
  static final String cardType = 'cardType';
  static final String cardManufacturer = 'cardManufacturer';
  static final String cardColor = 'cardColor';
} //? db filed names

class CardModel {
  final int? id;
  final String name;
  final int number;
  final String expDate;
  final int cvvNumber;
  final String cardType;
  final String cardManufacturer;
  final String cardColor;

  const CardModel(
      {this.id,
      required this.name,
      required this.number,
      required this.expDate,
      required this.cvvNumber,
      required this.cardType,
      required this.cardManufacturer,
      required this.cardColor});

  CardModel copy({
    int? id,
    String? name,
    int? number,
    String? expDate,
    int? cvvNumber,
    String? cardType,
    String? cardManufacturer,
    String? cardColor,
  }) =>
      CardModel(
        id: id ?? this.id,
        name: name ?? this.name,
        number: number ?? this.number,
        expDate: expDate ?? this.expDate,
        cvvNumber: cvvNumber ?? this.cvvNumber,
        cardType: cardType ?? this.cardType,
        cardManufacturer: cardManufacturer ?? this.cardManufacturer,
        cardColor: cardColor ?? this.cardColor,
      );

  static CardModel fromJson(Map<String, Object?> json) => CardModel(
        id: json[CardFields.id] as int?,
        name: json[CardFields.name] as String,
        number: json[CardFields.number] as int,
        expDate: json[CardFields.expDate] as String,
        cvvNumber: json[CardFields.cvvNumber] as int,
        cardType: json[CardFields.cardType] as String,
        cardManufacturer: json[CardFields.cardManufacturer] as String,
        cardColor: json[CardFields.cardColor] as String,
      );

  Map<String, Object?> toJson() => {
        CardFields.id: id,
        CardFields.name: name,
        CardFields.number: number,
        CardFields.expDate: expDate.toString(),
        CardFields.cvvNumber: cvvNumber,
        CardFields.cardType: cardType,
        CardFields.cardManufacturer: cardManufacturer,
        CardFields.cardColor: cardColor,
      };
}
