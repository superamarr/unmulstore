class ProductModel {
  final String title;
  final String imagePath;
  final int price;
  final double rating;
  final int stock;
  final String description;

  ProductModel({
    required this.title,
    required this.imagePath,
    required this.price,
    required this.rating,
    this.stock = 24,
    this.description = 'Kaos resmi dengan bahan cotton combed premium, nyaman digunakan untuk aktivitas sehari-hari.',
  });
}

final List<ProductModel> dummyProducts = [
  ProductModel(
    title: 'T-shirt universitas mulawarman dengan model terbaru',
    imagePath: 'assets/images/tshirt.jpeg',
    price: 100000,
    rating: 4.8,
  ),
  ProductModel(
    title: 'Work-Shirt',
    imagePath: 'assets/images/workshirt.jpeg',
    price: 100000,
    rating: 4.8,
  ),
  ProductModel(
    title: 'Almamater Unmul',
    imagePath: 'assets/images/almet.png',
    price: 180000,
    rating: 4.8,
  ),
  ProductModel(
    title: 'Toga Unmul Terbaru',
    imagePath: 'assets/images/toga.png',
    price: 200000,
    rating: 4.8,
  ),
  ProductModel(
    title: 'Work-Shirt',
    imagePath: 'assets/images/tshirt2.png',
    price: 100000,
    rating: 4.8,
  ),
  ProductModel(
    title: 'Gantungan Kunci',
    imagePath: 'assets/images/gantungan.png',
    price: 100000,
    rating: 4.8,
  ),
  ProductModel(
    title: 'Mug Khas Unmul',
    imagePath: 'assets/images/mug.png',
    price: 100000,
    rating: 4.8,
  ),
  ProductModel(
    title: 'Work-Jacket Inforsa',
    imagePath: 'assets/images/jaket.png',
    price: 100000,
    rating: 4.8,
  ),
  ProductModel(
    title: 'Tote Bag',
    imagePath: 'assets/images/totebag.png',
    price: 100000,
    rating: 4.8,
  ),
];

