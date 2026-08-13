
/// A function that takes no arguments and returns nothing.
typedef VoidCallback = void Function();
/// A function that takes one argument of type [T] and returns nothing.
typedef ValueCallback<T> = void Function(T value);
/// A function that takes one argument of type [T] and returns a boolean.
typedef Predicate<T> = bool Function(T value);

/// A function that takes one argument of type [T] and returns a value of type [R].
typedef Mapper<T, R> = R Function(T value);

/// A function that takes no arguments and returns a [Future<void>].
typedef AsyncCallback = Future<void> Function();

/// A function that takes one argument of type [T] and returns a [Future<void>].
typedef AsyncValueCallback<T> = Future<void> Function(T value);

/// A function that takes an index and a value of type [T] and returns nothing.
typedef IndexedValueCallback<T> = void Function(int index, T value);
/// A function that takes an index and returns nothing.
typedef IndexedCallback = void Function(int index);