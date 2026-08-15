part of 'shop_bloc.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

// Event yang dikirim saat pengguna menekan tombol "Buat Toko"
class CreateShopRequested extends ShopEvent {
  final String name;
  final String description;

  const CreateShopRequested({required this.name, required this.description});

  @override
  List<Object> get props => [name, description];
}
