import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void successToast(String text) {
  Toastification().show(
    icon: const Icon(Icons.check),
    description: Text(text),
    autoCloseDuration: const Duration(seconds: 2),
    type: ToastificationType.success,
  );
}

void infoToast(String text) {
  Toastification().show(
    icon: const Icon(Icons.info),
    description: Text(text),
    type: ToastificationType.info,
    autoCloseDuration: const Duration(seconds: 3),
  );
}

void errorToast(String text) {
  print(text);

  Toastification().show(
    icon: const Icon(Icons.error),
    description: Text(text),
    type: ToastificationType.error,
  );
}
