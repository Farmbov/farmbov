import 'package:mobx_triple/mobx_triple.dart';

abstract class CommonBaseStore<T> extends MobXStore
    implements ICommonBaseStore {
  CommonBaseStore(super.initialState);

  @override
  void disposeStore() {
    // TODO: implement disposeStore
  }

  @override
  void init() {
    //setLoading(true);
  }
}

abstract class ICommonBaseStore {
  void init();
  void disposeStore();
}
