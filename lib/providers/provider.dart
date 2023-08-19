import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final pageControllerProvider = Provider<PageController>(
  (ref) => usePageController(
      /*
    initialPage: ref.watch(pageIndexProvider)?.state,
    keepPage: true,*/
      ),
);

final scaffoldMessengerKeyProvider =
    Provider<GlobalKey<ScaffoldMessengerState>>(
  (ref) => GlobalKey<ScaffoldMessengerState>(),
);
