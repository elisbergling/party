import 'package:flutter/material.dart';

@immutable
class ServiceData {
  final String error;
  final bool isLoading;

  const ServiceData({
    required this.error,
    required this.isLoading,
  });

  ServiceData copyWith({
    String? error,
    bool? isLoading,
  }) {
    return ServiceData(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  ServiceData toggle() {
    return ServiceData(
      error: error,
      isLoading: !isLoading,
    );
  }

  ServiceData setError({required Object error}) {
    String e = error as String;
    print(e);
    return ServiceData(
      error: e,
      isLoading: isLoading,
    );
  }
}
