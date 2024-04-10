part of 'address_bloc.dart';

@immutable
abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressAddedState extends AddressState {}

class AddressUpdatedState extends AddressState {}

class AddressDeletedState extends AddressState {}