import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/service_data.dart';

abstract class ServiceNotifier extends Notifier<ServiceData> {
  @override
  ServiceData build() {
    return const ServiceData(
      error: '',
      isLoading: false,
    );
  }

  void toggleLoading() {
    state = state.toggle();
  }

  void setError(Object error) {
    state = state.setError(error: error);
  }
}
