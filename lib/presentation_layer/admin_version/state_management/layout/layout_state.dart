part of 'layout_bloc.dart';

class LayoutState extends Equatable {
  final int currentIndex;
  const LayoutState({this.currentIndex = 0});

  @override
  List<Object> get props => [currentIndex];
}
