import 'package:party/services/image_service.dart';
import 'package:hooks_riverpod/all.dart';

final imageProvider = Provider<ImageService>((_) => ImageService());
