
class Brand {
  final String brandName;

  Brand({required this.brandName});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Brand && other.brandName == brandName;
  }

  @override
  int get hashCode => brandName.hashCode;
}
