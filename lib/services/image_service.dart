import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:party/services/service_notifier.dart';

class ImageService extends ServiceNotifier {
  Future<void> uploadFile(
    String uid,
    ImageSource imageSource,
  ) async {
    try {
      toggleLoading();
      Reference ref = FirebaseStorage.instance.ref().child(uid);
      XFile? file = await ImagePicker().pickImage(source: imageSource);
      if (file == null) {
        print("No file was selected");
        return;
      }
      ref.putFile(File(file.path));
      //     .then((_) async => await ProviderContainer()
      //         .read(userProvider)
      //         .updateImgUrl(uid: uid))
      //     .onError((error, stackTrace) {
      //   print('error: ' +
      //       error.toString() +
      //       'stackTrace: ' +
      //       stackTrace.toString());
      //   _error = error.toString();
      // });
    } catch (e) {
      setError(e);
      return;
    } finally {
      toggleLoading();
    }
  }

  Future<String?> getDownloadUrl(String uid) async {
    try {
      toggleLoading();
      Reference ref = FirebaseStorage.instance.ref().child(uid);
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      setError(e);
      return null;
    } finally {
      toggleLoading();
    }
  }
}
