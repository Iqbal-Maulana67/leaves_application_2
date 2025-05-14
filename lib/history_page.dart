import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leaves_classification_application_nimas/db/history_db.dart';
import 'package:leaves_classification_application_nimas/widgets/exportPdf.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryPage();
}

class _HistoryPage extends State<HistoryPage> {
  List<Map<String, dynamic>> _historyList = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await HistoryDatabase.getHistory();
    setState(() {
      _historyList = history;
    });
  }

  Future<void> _addHistory() async {
    await HistoryDatabase.insertHistory(
        "plantName_tumpangAir", "Jember", "33.45");
    _loadHistory();
  }

  Future<void> _deleteHistory() async {
    await HistoryDatabase.deleteAllHistory();
    _loadHistory();
  }

  Map<String, List<Map<String, dynamic>>> groupHistoryByDate(
      List<Map<String, dynamic>> historyList) {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final yesterday =
        DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1)));

    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in historyList) {
      final timestamp = item['timestamp'];
      String label;

      if (timestamp == today) {
        label = AppLocalizations.of(context)!.today;
      } else if (timestamp == yesterday) {
        label = AppLocalizations.of(context)!.yesterday;
      } else {
        label = timestamp; // tampilkan tanggal
      }

      if (!grouped.containsKey(label)) {
        grouped[label] = [];
      }
      grouped[label]!.add(item);
    }

    return grouped;
  }

  List<String> getLeafNamesFromHistory() {
    return _historyList
        .map((item) => item['leaf_name'].toString())
        .toSet()
        .toList();
  }

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

  void PrintHistory(int id) async {
    try {
      List<Map<String, dynamic>> historyList =
          await HistoryDatabase.getDetailHistory(id);
      exportAndOpenPdf(historyList, context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported History to PDF file.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error, please try again next time!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedHistory = groupHistoryByDate(_historyList);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 20, 69, 200)),
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1, 1),
                            spreadRadius: 0.5,
                            blurRadius: 1)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.herbal_history,
                style: TextStyle(
                    fontFamily: "DMSans",
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Image.asset(
                "assets/images/bg_language.png",
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: (() {
                    // Cek apakah sedang mencari
                    final isSearching = _searchController.text.isNotEmpty;

                    // Data yang akan ditampilkan
                    final historyToDisplay = isSearching
                        ? _historyList.where((item) {
                            final name = getLocalizedPlantName(
                                    context, item['leaf_name'])
                                .toString()
                                .toLowerCase();
                            return name
                                .contains(_searchController.text.toLowerCase());
                          }).toList()
                        : _historyList;

                    // Kelompokkan hasil berdasarkan tanggal
                    final grouped = groupHistoryByDate(historyToDisplay);

                    // Tampilkan hasilnya
                    return grouped.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              entry
                                  .key, // "Hari Ini", "Kemarin", "2024-04-28", etc.
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...entry.value.map((item) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 185, 199, 230),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Image.asset(
                                      "assets/images/icon_leaves.png",
                                      height: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(getLocalizedPlantName(
                                          context, item["leaf_name"])),
                                      const SizedBox(height: 5),
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 20),
                                          const SizedBox(width: 5),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.55, // atau nilai tetap
                                            ),
                                            child: Text(
                                              item["location_name"] ?? "",
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      PrintHistory(item["id"]);
                                    },
                                    child: Container(
                                      child: Icon(Icons.download),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList();
                  })(),
                ),
              ),
            ),

            // Expanded(
            //   child: Container(
            //     color: Colors.white,
            //     child: ListView.builder(
            //       padding: EdgeInsets.zero, // Hilangkan padding atas ListView
            //       itemCount: _historyList.length,
            //       itemBuilder: (context, index) {
            //         var data = _historyList[index];
            // return Container(
            //   margin: const EdgeInsets.symmetric(
            //       horizontal: 20, vertical: 5),
            //   child: Row(
            //     children: [
            //       Container(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 10, vertical: 15),
            //         decoration: BoxDecoration(
            //           color: const Color.fromARGB(255, 185, 199, 230),
            //           borderRadius: BorderRadius.circular(50),
            //         ),
            //         child: Image.asset(
            //           "assets/images/icon_leaves.png",
            //           height: 20,
            //         ),
            //       ),
            //       const SizedBox(width: 10),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(data["leaf_name"]),
            //           SizedBox(height: 5),
            //           Row(
            //             children: [
            //               Icon(Icons.location_on, size: 20),
            //               SizedBox(width: 5),
            //               Text(
            //                 data["timestamp"],
            //                 style: TextStyle(fontSize: 14),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // );
            //       },
            //     ),
            //   ),
            // ),
            // ElevatedButton(onPressed: PrintHistory, child: Text("Print")),
            // ElevatedButton(onPressed: _deleteHistory, child: Text("HAPUS")),
          ],
        ),
      ),
    );
  }
}
