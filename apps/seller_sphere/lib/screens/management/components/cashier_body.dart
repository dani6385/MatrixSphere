import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Impor file provider dan dialog yang sudah dipisah di atas
import '../providers/cashier_providers.dart';
import '../dialogs/cashier_dialogs.dart';

class CashierBody extends ConsumerWidget {
  const CashierBody({super.key});

  Future<void> _processPayment(BuildContext context, WidgetRef ref) async {
    CashierDialogs.showLoading(context);

    try {
      final cartItems = ref.read(cartProvider);
      final total = ref.read(cartProvider.notifier).calculateTotal();

      final newTransaction =
          await ref.read(transactionServiceProvider).createTransaction(
                items: cartItems,
                totalAmount: total,
                paymentMethod: 'CASH',
              );
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Tutup loading
      await CashierDialogs.showSuccess(context, newTransaction.id);

      ref.read(cartProvider.notifier).clearCart();
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Tutup loading
      CashierDialogs.showError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final cartItems = ref.watch(cartProvider);
              if (cartItems.isEmpty) {
                return const Center(child: Text('Keranjang kosong'));
              }
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Rp ${item.price} x ${item.quantity}'),
                    trailing: Text('Rp ${item.price * item.quantity}'),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _processPayment(context, ref),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Proses Pembayaran'),
          ),
        ),
      ],
    );
  }
}
