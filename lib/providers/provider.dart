import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

final pageControllerProvider = Provider((_) => usePageController());
