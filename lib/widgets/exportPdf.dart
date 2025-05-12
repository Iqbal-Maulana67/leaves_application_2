import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

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

Future<void> exportAndOpenPdf(
    List<Map<String, dynamic>> data, BuildContext loc_context) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: data.map(
            (item) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        pw.Text(
                            "Plant Name: ${getLocalizedPlantName(loc_context, item['leaf_name'])}"),
                        pw.SizedBox(width: 10),
                        pw.Text("Address: ${item['location_name']}"),
                        pw.SizedBox(width: 10),
                        pw.Text("Accuracy: ${item['accuracy']}"),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    plantWidgets(item['leaf_name'], loc_context)
                  ],
                ),
              );
            },
          ).toList(),
        );
      },
    ),
  );

  // Simpan ke file lokal
  final outputDir = await getApplicationDocumentsDirectory();
  final file = File(
      "${outputDir.path}/history_export_${DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now())}.pdf");
  await file.writeAsBytes(await pdf.save());

  // Buka file PDF
  await OpenFile.open(file.path);
}

pw.Widget plantWidgets(String plantName, BuildContext loc_context) {
  if (plantName == "plantName_brotowali") {
    return brotowaliWidget(loc_context);
  } else if (plantName == "plantName_pegagan") {
    return pegaganWidget(loc_context);
  } else if (plantName == "plantName_rambusa") {
    return rambusaWidget(loc_context);
  } else if (plantName == "plantName_rumputMinjangan") {
    return rumputMinjanganWidget(loc_context);
  } else if (plantName == "plantName_sembungRambat") {
    return sembungRambatWidget(loc_context);
  } else if (plantName == "plantName_tumpangAir") {
    return tumpangAirWidget(loc_context);
  }
  return pw.Container();
}

pw.Widget rambusaWidget(BuildContext loc_context) {
  return pw.Column(children: [
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.rambusa_herbal_drink_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.rambusa_herbal_drink_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '1. ' + AppLocalizations.of(loc_context)!.rambusa_herbal_drink_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '2. ' + AppLocalizations.of(loc_context)!.rambusa_herbal_drink_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '3. ' + AppLocalizations.of(loc_context)!.rambusa_herbal_drink_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '4. ' + AppLocalizations.of(loc_context)!.rambusa_herbal_drink_4)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '5. ' + AppLocalizations.of(loc_context)!.rambusa_herbal_drink_5)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '6. ' + AppLocalizations.of(loc_context)!.rambusa_herbal_drink_6)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '7`. ' + AppLocalizations.of(loc_context)!.rambusa_herbal_drink_7)),
    pw.SizedBox(height: 20),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.rambusa_tea_drink_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child:
            pw.Text(AppLocalizations.of(loc_context)!.rambusa_tea_drink_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '1. ' + AppLocalizations.of(loc_context)!.rambusa_tea_drink_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '2. ' + AppLocalizations.of(loc_context)!.rambusa_tea_drink_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '3. ' + AppLocalizations.of(loc_context)!.rambusa_tea_drink_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '4. ' + AppLocalizations.of(loc_context)!.rambusa_tea_drink_4)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '5. ' + AppLocalizations.of(loc_context)!.rambusa_tea_drink_5)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '6. ' + AppLocalizations.of(loc_context)!.rambusa_tea_drink_6)),
    pw.SizedBox(height: 20),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(AppLocalizations.of(loc_context)!.rambusa_wound_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(AppLocalizations.of(loc_context)!.rambusa_wound_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child:
            pw.Text('1. ' + AppLocalizations.of(loc_context)!.rambusa_wound_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child:
            pw.Text('2. ' + AppLocalizations.of(loc_context)!.rambusa_wound_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child:
            pw.Text('3. ' + AppLocalizations.of(loc_context)!.rambusa_wound_3)),
  ]);
}

pw.Widget brotowaliWidget(BuildContext loc_context) {
  return pw.Column(children: [
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.brotowali_herbal_drink_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.brotowali_herbal_drink_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('1. ' +
            AppLocalizations.of(loc_context)!.brotowali_herbal_drink_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('2. ' +
            AppLocalizations.of(loc_context)!.brotowali_herbal_drink_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('3. ' +
            AppLocalizations.of(loc_context)!.brotowali_herbal_drink_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('4. ' +
            AppLocalizations.of(loc_context)!.brotowali_herbal_drink_4)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('5. ' +
            AppLocalizations.of(loc_context)!.brotowali_herbal_drink_5)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('6. ' +
            AppLocalizations.of(loc_context)!.brotowali_herbal_drink_6)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('7`. ' +
            AppLocalizations.of(loc_context)!.brotowali_herbal_drink_7)),
    pw.SizedBox(height: 20),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.brotowali_tea_drink_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.brotowali_tea_drink_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '1. ' + AppLocalizations.of(loc_context)!.brotowali_tea_drink_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '2. ' + AppLocalizations.of(loc_context)!.brotowali_tea_drink_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '3. ' + AppLocalizations.of(loc_context)!.brotowali_tea_drink_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '4. ' + AppLocalizations.of(loc_context)!.brotowali_tea_drink_4)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '5. ' + AppLocalizations.of(loc_context)!.brotowali_tea_drink_5)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '6. ' + AppLocalizations.of(loc_context)!.brotowali_tea_drink_6)),
    pw.SizedBox(height: 20),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(AppLocalizations.of(loc_context)!.brotowali_wound_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(AppLocalizations.of(loc_context)!.brotowali_wound_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '1. ' + AppLocalizations.of(loc_context)!.brotowali_wound_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '2. ' + AppLocalizations.of(loc_context)!.brotowali_wound_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '3. ' + AppLocalizations.of(loc_context)!.brotowali_wound_3)),
  ]);
}

pw.Widget pegaganWidget(BuildContext loc_context) {
  return pw.Column(children: [
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.pegagan_herbal_drink_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.pegagan_herbal_drink_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '1. ' + AppLocalizations.of(loc_context)!.pegagan_herbal_drink_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '2. ' + AppLocalizations.of(loc_context)!.pegagan_herbal_drink_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '3. ' + AppLocalizations.of(loc_context)!.pegagan_herbal_drink_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '4. ' + AppLocalizations.of(loc_context)!.pegagan_herbal_drink_4)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '5. ' + AppLocalizations.of(loc_context)!.pegagan_herbal_drink_5)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '6. ' + AppLocalizations.of(loc_context)!.pegagan_herbal_drink_6)),
    pw.SizedBox(height: 20),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.pegagan_tea_drink_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child:
            pw.Text(AppLocalizations.of(loc_context)!.pegagan_tea_drink_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '1. ' + AppLocalizations.of(loc_context)!.pegagan_tea_drink_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '2. ' + AppLocalizations.of(loc_context)!.pegagan_tea_drink_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '3. ' + AppLocalizations.of(loc_context)!.pegagan_tea_drink_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '4. ' + AppLocalizations.of(loc_context)!.pegagan_tea_drink_4)),
    pw.SizedBox(height: 20),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(AppLocalizations.of(loc_context)!.pegagan_wound_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(AppLocalizations.of(loc_context)!.pegagan_wound_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child:
            pw.Text('1. ' + AppLocalizations.of(loc_context)!.pegagan_wound_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child:
            pw.Text('2. ' + AppLocalizations.of(loc_context)!.pegagan_wound_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child:
            pw.Text('3. ' + AppLocalizations.of(loc_context)!.pegagan_wound_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child:
            pw.Text('4. ' + AppLocalizations.of(loc_context)!.pegagan_wound_4)),
  ]);
}

pw.Widget rumputMinjanganWidget(BuildContext loc_context) {
  return pw.Column(children: [
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!
                .rumput_minjangan_herbal_drink_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(AppLocalizations.of(loc_context)!
            .rumput_minjangan_herbal_drink_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('1. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_herbal_drink_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('2. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_herbal_drink_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('3. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_herbal_drink_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('4. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_herbal_drink_4)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('5. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_herbal_drink_5)),
    pw.SizedBox(height: 20),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.rumput_minjangan_tea_drink_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.rumput_minjangan_tea_drink_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('1. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_tea_drink_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('2. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_tea_drink_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('3. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_tea_drink_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('4. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_tea_drink_4)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('5. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_tea_drink_5)),
    pw.SizedBox(height: 20),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.rumput_minjangan_wound_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.rumput_minjangan_wound_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('1. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_wound_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('2. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_wound_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('3. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_wound_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('4. ' +
            AppLocalizations.of(loc_context)!.rumput_minjangan_wound_4)),
  ]);
}

pw.Widget sembungRambatWidget(BuildContext loc_context) {
  return pw.Column(children: [
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.sembung_rambat_herbal_drink_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(AppLocalizations.of(loc_context)!
            .sembung_rambat_herbal_drink_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('1. ' +
            AppLocalizations.of(loc_context)!.sembung_rambat_herbal_drink_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('2. ' +
            AppLocalizations.of(loc_context)!.sembung_rambat_herbal_drink_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('3. ' +
            AppLocalizations.of(loc_context)!.sembung_rambat_herbal_drink_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('4. ' +
            AppLocalizations.of(loc_context)!.sembung_rambat_herbal_drink_4)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('5. ' +
            AppLocalizations.of(loc_context)!.sembung_rambat_herbal_drink_5)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('6. ' +
            AppLocalizations.of(loc_context)!.sembung_rambat_herbal_drink_6)),
    pw.SizedBox(height: 20),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.sembung_rambat_tea_drink_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.sembung_rambat_tea_drink_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('1. ' +
            AppLocalizations.of(loc_context)!.sembung_rambat_tea_drink_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('2. ' +
            AppLocalizations.of(loc_context)!.sembung_rambat_tea_drink_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('3. ' +
            AppLocalizations.of(loc_context)!.sembung_rambat_tea_drink_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('4. ' +
            AppLocalizations.of(loc_context)!.sembung_rambat_tea_drink_4)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('5. ' +
            AppLocalizations.of(loc_context)!.sembung_rambat_tea_drink_5)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('6. ' +
            AppLocalizations.of(loc_context)!.sembung_rambat_tea_drink_6)),
    pw.SizedBox(height: 20),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.sembung_rambat_wound_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.sembung_rambat_wound_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '1. ' + AppLocalizations.of(loc_context)!.sembung_rambat_wound_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '2. ' + AppLocalizations.of(loc_context)!.sembung_rambat_wound_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '3. ' + AppLocalizations.of(loc_context)!.sembung_rambat_wound_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '4. ' + AppLocalizations.of(loc_context)!.sembung_rambat_wound_4)),
  ]);
}

pw.Widget tumpangAirWidget(BuildContext loc_context) {
  return pw.Column(children: [
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.tumpang_air_herbal_drink_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.tumpang_air_herbal_drink_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('1. ' +
            AppLocalizations.of(loc_context)!.tumpang_air_herbal_drink_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('2. ' +
            AppLocalizations.of(loc_context)!.tumpang_air_herbal_drink_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('3. ' +
            AppLocalizations.of(loc_context)!.tumpang_air_herbal_drink_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('4. ' +
            AppLocalizations.of(loc_context)!.tumpang_air_herbal_drink_4)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('5. ' +
            AppLocalizations.of(loc_context)!.tumpang_air_herbal_drink_5)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text('6. ' +
            AppLocalizations.of(loc_context)!.tumpang_air_herbal_drink_6)),
    pw.SizedBox(height: 20),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.tumpang_air_tea_drink_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.tumpang_air_tea_drink_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '1. ' + AppLocalizations.of(loc_context)!.tumpang_air_tea_drink_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '2. ' + AppLocalizations.of(loc_context)!.tumpang_air_tea_drink_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '3. ' + AppLocalizations.of(loc_context)!.tumpang_air_tea_drink_3)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '4. ' + AppLocalizations.of(loc_context)!.tumpang_air_tea_drink_4)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '5. ' + AppLocalizations.of(loc_context)!.tumpang_air_tea_drink_5)),
    pw.SizedBox(height: 20),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            AppLocalizations.of(loc_context)!.tumpang_air_wound_title,
            style:
                pw.TextStyle(fontSize: 15.0, fontWeight: pw.FontWeight.bold))),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child:
            pw.Text(AppLocalizations.of(loc_context)!.tumpang_air_wound_desc)),
    pw.SizedBox(height: 5),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '1. ' + AppLocalizations.of(loc_context)!.tumpang_air_wound_1)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '2. ' + AppLocalizations.of(loc_context)!.tumpang_air_wound_2)),
    pw.Container(
        alignment: pw.Alignment.centerLeft,
        child: pw.Text(
            '3. ' + AppLocalizations.of(loc_context)!.tumpang_air_wound_3)),
  ]);
}
