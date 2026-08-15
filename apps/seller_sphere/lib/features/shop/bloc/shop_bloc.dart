import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seller_sphere/features/shop/repositories/shop_repository.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository _shopRepository;

  ShopBloc({required this._shopRepository})
      : super(ShopInitial()) {
    on<CreateShopRequested>(_onCreateShopRequested);
  }

  Future<void> _onCreateShopRequested(
    CreateShopRequested event,
    Emitter<ShopState> emit,
  ) async {
    emit(ShopLoading());
    try {
      // Panggil repository untuk menyimpan data ke Firestore
      await _shopRepository.createShop(
        name: event.name,
        description: event.description,
      );
      
      // Jika berhasil, pancarkan status sukses
      emit(ShopCreationSuccess());

    } catch (e) {
      // Jika terjadi error dari repository, pancarkan status kegagalan
      emit(ShopCreationFailure(error: e.toString()));
    }
  }
}
