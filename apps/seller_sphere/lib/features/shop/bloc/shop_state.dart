part of 'shop_bloc.dart';

abstract class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object> get props => [];
}

// Status awal, sebelum ada aksi yang diambil
class ShopInitial extends ShopState {}

// Status saat proses pembuatan toko sedang berlangsung
class ShopLoading extends ShopState {}

// Status saat toko berhasil dibuat
class ShopCreationSuccess extends ShopState {}

// Status saat terjadi kegagalan dalam pembuatan toko
class ShopCreationFailure extends ShopState {
  final String error;

  const ShopCreationFailure({required this.error});

  @override
  List<Object> get props => [error];
}
