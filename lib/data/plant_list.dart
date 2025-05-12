import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';

class PlantList {
  final String nameKey;
  final double lat;
  final double lng;

  PlantList({
    required this.nameKey,
    required this.lat,
    required this.lng,
  });

  String getLocalizedPlantName(BuildContext context, String key) {
    final localizations = AppLocalizations.of(context)!;
    final Map<String, String> allKeys = {
      'plantName_brotowali': localizations.brotowali,
      'plantName_pegagan': localizations.pegagan,
      'plantName_rambusa': localizations.rambusa,
      'plantName_rumputMinjangan': localizations.rumput_minjangan,
      'plantName_sembungRambat': localizations.sembung_rambat,
      'plantName_tumpangAir': localizations.tumpang_air,
      // Tambah key lainnya di sini
    };
    return allKeys[key] ?? key; // fallback jika key tidak ditemukan
  }
}

final random = Random();

List<PlantList> plantData = [
  PlantList(
    nameKey: "plantName_sembungRambat",
    lat: -8.1706070,
    lng: 113.7229250,
  ),
  PlantList(
    nameKey: "plantName_tumpangAir",
    lat: -8.1706060,
    lng: 113.7229350,
  ),
  // 50 di Jember
  for (int i = 0; i < 50; i++)
    PlantList(
      nameKey: i % 3 == 0
          ? "plantName_sembungRambat"
          : i % 3 == 1
              ? "plantName_tumpangAir"
              : "plantName_rumputMinjangan",
      lat: -8.170000 + (i * random.nextDouble() * 0.3),
      lng: 113.722000 + (i * random.nextDouble() * -0.3),
    ),

  // 50 di Californiaw
  for (int i = 0; i < 50; i++)
    PlantList(
      nameKey: i % 3 == 0
          ? "plantName_pegagan"
          : i % 3 == 1
              ? "plantName_rambusa"
              : "plantName_brotowali",
      lat: 36.7783 + (i * random.nextDouble() * 0.3),
      lng: -119.4179 + (i * random.nextDouble() * -0.3),
    ),
];
