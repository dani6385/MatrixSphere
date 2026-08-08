// lib/screens/management/components/cart_items_list.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
//import 'package:shared_ui/shared_ui.dart';

class CartItemsList extends StatelessWidget {
  final List<CartItem> cartItems;

  const CartItemsList({
    super.key,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return const Center(
        child: Text('Pindai produk untuk memulai transaksi.'),
      );
    }

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: item.product.imageUrl != null
                ? NetworkImage(item.product.imageUrl!)
                : null,
            child: item.product.imageUrl == null
                ? Text(item.product.name.substring(0, 1))
                : null,
          ),
          title: Text(item.product.name),
          subtitle: Text(
              '${item.quantity} x ${formatCurrency(item.product.sellingPrice)}'),
          trailing: Text(
            formatCurrency(item.product.sellingPrice * item.quantity),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}