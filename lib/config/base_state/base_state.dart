import 'package:equatable/equatable.dart';

class BaseState<T> extends Equatable {
  final bool isLoading;
  final T? data;
  final String? msg;

  const BaseState({this.isLoading = false, this.data, this.msg});

  @override
  List<Object?> get props => [isLoading, data, msg];

  factory BaseState.loading() => BaseState<T>(isLoading: true);

  factory BaseState.success(T data) =>
      BaseState<T>(isLoading: false, data: data, msg: null);

  factory BaseState.error(String msg) =>
      BaseState<T>(isLoading: false, msg: msg, data: null);

  BaseState<T> copyWith({bool? isLoading, T? data, String? msg}) {
    return BaseState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      msg: msg ?? this.msg,
    );
  }
}
