import 'dart:convert';

import 'package:farmbov/src/domain/models/firestore/serializers.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// SERIALIZATION HELPERS

String dateTimeRangeToString(DateTimeRange dateTimeRange) {
  final startStr = dateTimeRange.start.millisecondsSinceEpoch.toString();
  final endStr = dateTimeRange.end.millisecondsSinceEpoch.toString();
  return '$startStr|$endStr';
}

// String placeToString(FFPlace place) => jsonEncode({
//       'latLng': place.latLng.serialize(),
//       'name': place.name,
//       'address': place.address,
//       'city': place.city,
//       'state': place.state,
//       'country': place.country,
//       'zipCode': place.zipCode,
//     });

// String uploadedFileToString(FFUploadedFile uploadedFile) =>
//     uploadedFile.serialize();

const _kDocIdDelimeter = '|';
String _serializeDocumentReference(DocumentReference ref) {
  final docIds = <String>[];
  DocumentReference? currentRef = ref;
  while (currentRef != null) {
    docIds.add(currentRef.id);
    // Get the parent document (catching any errors that arise).
    currentRef = safeGet<DocumentReference?>(() => currentRef?.parent.parent);
  }
  // Reverse the list to get the correct ordering.
  return docIds.reversed.join(_kDocIdDelimeter);
}

String? serializeParam(
  dynamic param,
  ParamType paramType, [
  bool isList = false,
]) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final serializedValues = (param as Iterable)
          .map((p) => serializeParam(p, paramType, false))
          .where((p) => p != null)
          .map((p) => p!)
          .toList();
      return json.encode(serializedValues);
    }
    switch (paramType) {
      case ParamType.int:
        return param.toString();
      case ParamType.double:
        return param.toString();
      case ParamType.String:
        return param;
      case ParamType.bool:
        return param ? 'true' : 'false';
      case ParamType.DateTime:
        return (param as DateTime).millisecondsSinceEpoch.toString();
      case ParamType.DateTimeRange:
        return dateTimeRangeToString(param as DateTimeRange);
      // case ParamType.LatLng:
      //   return (param as LatLng).serialize();
      // case ParamType.Color:
      //   return (param as Color).toCssString();
      // case ParamType.FFPlace:
      //   return placeToString(param as FFPlace);
      // case ParamType.FFUploadedFile:
      //   return uploadedFileToString(param as FFUploadedFile);
      case ParamType.JSON:
        return json.encode(param);
      case ParamType.DocumentReference:
        return _serializeDocumentReference(param as DocumentReference);
      case ParamType.Document:
        final reference = (param as dynamic).reference as DocumentReference;
        return _serializeDocumentReference(reference);

      default:
        return null;
    }
  } catch (e) {
    Logger().e('Error serializing parameter: $e');
    return null;
  }
}

/// END SERIALIZATION HELPERS

/// DESERIALIZATION HELPERS

DateTimeRange? dateTimeRangeFromString(String dateTimeRangeStr) {
  final pieces = dateTimeRangeStr.split('|');
  if (pieces.length != 2) {
    return null;
  }
  return DateTimeRange(
    start: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.first)),
    end: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.last)),
  );
}

// FFUploadedFile uploadedFileFromString(String uploadedFileStr) =>
//     FFUploadedFile.deserialize(uploadedFileStr);

DocumentReference _deserializeDocumentReference(
  String refStr,
  List<String> collectionNamePath,
) {
  var path = '';
  final docIds = refStr.split(_kDocIdDelimeter);
  for (int i = 0; i < docIds.length && i < collectionNamePath.length; i++) {
    path += '/${collectionNamePath[i]}/${docIds[i]}';
  }
  return FirebaseFirestore.instance.doc(path);
}

enum ParamType {
  int,
  double,
  String,
  bool,
  DateTime,
  DateTimeRange,
  LatLng,
  Color,
  FFPlace,
  FFUploadedFile,
  JSON,
  Document,
  DocumentReference,
  AnimalRecord,
}

dynamic deserializeParam<T>(
  String? param,
  ParamType paramType,
  bool isList, [
  List<String>? collectionNamePath,
]) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final paramValues = json.decode(param);
      if (paramValues is! Iterable || paramValues.isEmpty) {
        return null;
      }
      return paramValues
          .whereType<String>()
          .map((p) => p)
          .map((p) =>
              deserializeParam<T>(p, paramType, false, collectionNamePath))
          .where((p) => p != null)
          .map((p) => p! as T)
          .toList();
    }
    switch (paramType) {
      case ParamType.int:
        return int.tryParse(param);
      case ParamType.double:
        return double.tryParse(param);
      case ParamType.String:
        return param;
      case ParamType.bool:
        return param == 'true';
      case ParamType.DateTime:
        final milliseconds = int.tryParse(param);
        return milliseconds != null
            ? DateTime.fromMillisecondsSinceEpoch(milliseconds)
            : null;
      case ParamType.DateTimeRange:
        return dateTimeRangeFromString(param);
      // case ParamType.LatLng:
      //   return latLngFromString(param);
      // case ParamType.Color:
      //   return fromCssColor(param);
      // case ParamType.FFPlace:
      //   return placeFromString(param);
      // case ParamType.FFUploadedFile:
      //   return uploadedFileFromString(param);
      case ParamType.JSON:
        return json.decode(param);
      case ParamType.DocumentReference:
        return _deserializeDocumentReference(param, collectionNamePath ?? []);

      default:
        return null;
    }
  } catch (e) {
    debugPrint('Error deserializing parameter: $e');
    return null;
  }
}

Future<dynamic> Function(String) getDoc(
  List<String> collectionNamePath,
  Serializer serializer,
) {
  return (String ids) => _deserializeDocumentReference(ids, collectionNamePath)
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));
}

Future<List<T>> Function(String) getDocList<T>(
  List<String> collectionNamePath,
  Serializer<T> serializer,
) {
  return (String idsList) {
    List<String> docIds = [];
    try {
      final ids = json.decode(idsList) as Iterable;
      docIds = ids.whereType<String>().map((d) => d).toList();
    } catch (_) {}
    return Future.wait(
      docIds.map(
        (ids) => _deserializeDocumentReference(ids, collectionNamePath)
            .get()
            .then(
              (s) => serializers.deserializeWith(serializer, serializedData(s)),
            ),
      ),
    ).then((docs) => docs.where((d) => d != null).map((d) => d!).toList());
  };
}
