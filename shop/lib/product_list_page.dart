import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;

  final pb = PocketBase('http://127.0.0.1:8090'); // แก้ IP ตาม platform

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      // Login Admin
      await pb.admins.authWithPassword(
          'anna.sa.65@ubu.ac.th', 'anat123456');

      // ดึงทั้งหมด
      final records = await pb.collection('products').getFullList(batch: 50);
      setState(() {
        _products.clear();
        _products.addAll(records.map((r) => r.data as Map<String, dynamic>));
      });
    } catch (e) {
      print('❌ Failed to fetch products: $e');
    }
    setState(() => _isLoading = false);
  }

  // เพิ่ม product ใหม่
  Future<void> _addProduct() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final imageController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Image URL')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () async {
            try {
              await pb.collection('products').create(body: {
                'name': nameController.text,
                'price': double.tryParse(priceController.text) ?? 0,
                'imageUrl': imageController.text,
              });
              Navigator.pop(context);
              _fetchProducts();
            } catch (e) {
              print('❌ Failed to add product: $e');
            }
          }, child: const Text('Add')),
        ],
      ),
    );
  }

  // แก้ไข product
  Future<void> _editProduct(Map<String, dynamic> product) async {
    final nameController = TextEditingController(text: product['name']);
    final priceController = TextEditingController(text: product['price'].toString());
    final imageController = TextEditingController(text: product['imageUrl']);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Image URL')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () async {
            try {
              await pb.collection('products').update(product['id'], body: {
                'name': nameController.text,
                'price': double.tryParse(priceController.text) ?? 0,
                'imageUrl': imageController.text,
              });
              Navigator.pop(context);
              _fetchProducts();
            } catch (e) {
              print('❌ Failed to edit product: $e');
            }
          }, child: const Text('Save')),
        ],
      ),
    );
  }

  // ลบ product
  Future<void> _deleteProduct(String id) async {
    try {
      await pb.collection('products').delete(id);
      _fetchProducts();
    } catch (e) {
      print('❌ Failed to delete product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addProduct),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  leading: product['imageUrl'] != null
                      ? Image.network(product['imageUrl'], width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image),
                  title: Text(product['name'] ?? 'No name'),
                  subtitle: Text('Price: ${product['price'] ?? 'N/A'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editProduct(product)),
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteProduct(product['id'])),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
