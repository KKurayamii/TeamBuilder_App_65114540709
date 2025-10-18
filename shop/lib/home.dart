import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  // Dummy data for demonstration
  final List<String> topShops = ['Shop A', 'Shop B', 'Shop C', 'Shop D'];

  final List<Map<String, String>> topProducts = List.generate(20, (index) => {
        'name': 'Product ${index + 1}',
        'price': '\$${(index + 1) * 5}',
        'image': 'https://picsum.photos/seed/product${index + 1}/120/120',
      });

  final List<Map<String, String>> popularReviews = [
    {'user': 'Alice', 'review': 'Great product!'},
    {'user': 'Bob', 'review': 'Fast shipping.'},
    {'user': 'Carol', 'review': 'Excellent quality.'},
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('E-Commerce Home'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Shops
              Text('Top Shops',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: topShops.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      child: Container(
                        width: 100,
                        alignment: Alignment.center,
                        child: Text(topShops[index],
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Top Products
              Text('Top Products',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topProducts.length,
                  itemBuilder: (context, index) {
                    final product = topProducts[index];
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product['image']!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(product['name']!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(product['price']!,
                                  style: const TextStyle(color: Colors.green)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Popular Reviews
              Text('Popular Reviews',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: popularReviews.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final review = popularReviews[index];
                  return Card(
                    elevation: 1,
                    child: ListTile(
                      leading: CircleAvatar(child: Text(review['user']![0])),
                      title: Text(review['user']!),
                      subtitle: Text(review['review']!),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
