part of 'layout_bloc.dart';

abstract class LayoutEvent extends Equatable {
  const LayoutEvent();

  @override
  List<Object> get props => [];
}

class ChangeBottomNavIndex extends LayoutEvent {
  final int index;
  const ChangeBottomNavIndex(this.index);

  @override
  List<Object> get props => [index];
}
