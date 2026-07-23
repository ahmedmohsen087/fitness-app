import 'package:flutter_bloc/flutter_bloc.dart';

enum AppTab { home, chat, workout, profile }

class SectionTabCubit extends Cubit<AppTab> {
  SectionTabCubit() : super(AppTab.home);

  void changeTab(AppTab tab) {
    if (state != tab) emit(tab);
  }
}
