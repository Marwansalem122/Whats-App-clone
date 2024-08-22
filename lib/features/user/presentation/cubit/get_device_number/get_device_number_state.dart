part of 'get_device_number_cubit.dart';

sealed class GetDeviceNumberState extends Equatable {
  const GetDeviceNumberState();
}

final class GetDeviceNumberInitial extends GetDeviceNumberState {
  @override
  List<Object> get props => [];
}

class GetDeviceNumberLoading extends GetDeviceNumberState {
  @override
  List<Object> get props => [];
}

class GetDeviceNumberLoaded extends GetDeviceNumberState {
  final List<ContactEntity> contacts;

  const GetDeviceNumberLoaded({required this.contacts});


  @override
  List<Object> get props => [contacts];
}

class GetDeviceNumberFailure extends GetDeviceNumberState {
  @override
  List<Object> get props => [];
}