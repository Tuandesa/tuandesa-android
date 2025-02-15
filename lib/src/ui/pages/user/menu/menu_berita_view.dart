import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:tuandesa/src/models/aduan_model.dart';
import 'package:tuandesa/src/models/berita_model.dart';
import 'package:tuandesa/src/models/jenis_model.dart';
import 'dart:convert';

import 'package:tuandesa/src/models/profile_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/cek_koneksi.dart';

class MenuBeritaView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MenuBeritaViewState();
}

class _MenuBeritaViewState extends State<MenuBeritaView> {
  @override
  void initState() {
    super.initState();
    ProfileModel.getProfileFromSh().then((value) {
      setState(() {
        name = value.name;
      });
    });
    JenisModel.getJenis("berita").then((value) {
      if (value.status) {
        List<dynamic> data = json.decode(value.data);
        List<Map<String, dynamic>> hasil = [];
        for (var i = 0; i < data.length; i++) {
          hasil.insert(i, {"id": data[i]['id'], "jenis": data[i]["name"]});
        }
        setState(() {
          _jenisBerita = hasil;
        });
      }
    });
  }

  Color buttonColor = Color(0xff00B894);
  String name = "";
  String komentar = "";
  bool loading = false;
  Map<String, dynamic> jenisBeritaSelected;
  List<Map<String, dynamic>> _jenisBerita = [];
  List<Map<String, dynamic>> _status = [
    {"id": 0, "text": "Proses"},
    {"id": 1, "text": "Selesai"}
  ];
  Map<String, dynamic> statusSelected;
  List<Asset> lampiran = [];
  String _error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomStyle.headerColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Berita Masyarakat",
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              name,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            )
          ],
        ),
      ),
      body: Container(
          color: CustomStyle.bgColor,
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  text("Jenis Berita"),
                  FutureBuilder(
                    future: JenisModel.getJenis("berita"),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 20, top: 10),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<Map<String, dynamic>>(
                                  isExpanded: true,
                                  hint: Text('--Pilih Jenis Berita--'),
                                  value: jenisBeritaSelected,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  items: _jenisBerita.map<
                                          DropdownMenuItem<
                                              Map<String, dynamic>>>(
                                      (Map<String, dynamic> value) {
                                    return DropdownMenuItem<
                                            Map<String, dynamic>>(
                                        value: value,
                                        child: Text(value['jenis']));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      jenisBeritaSelected = value;
                                    });
                                  }),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                            child: Center(
                                child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator())));
                      }
                    },
                  ),
                  text("Komentar"),
                  Container(
                    height: 170,
                    child: Card(
                      margin: EdgeInsets.only(bottom: 20, top: 10),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: TextField(
                          maxLines: 10,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Masukkan Komentar Anda'),
                          onChanged: (value) {
                            setState(() {
                              komentar = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  text("Status"),
                  Card(
                    margin: EdgeInsets.only(bottom: 20, top: 10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<Map<String, dynamic>>(
                            isExpanded: true,
                            hint: Text('--Pilih Status--'),
                            value: statusSelected,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            items: _status
                                .map<DropdownMenuItem<Map<String, dynamic>>>(
                                    (Map<String, dynamic> value) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                  value: value, child: Text(value['text']));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                statusSelected = value;
                              });
                            }),
                      ),
                    ),
                  ),
                  text("Lampiran"),
                  FlatButton(
                    onPressed: () {
                      loadAssets();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          "images/upload.png",
                          width: 30,
                          height: 30,
                        ),
                        Text(
                            lampiran.length == 0
                                ? "Belum ada lampiran yang dipilih"
                                : "${lampiran.length} lampiran",
                            style: TextStyle(fontWeight: FontWeight.w600))
                      ],
                    ),
                  ),
                  Center(
                    child: ButtonTheme(
                      minWidth: 200.0,
                      height: 40.0,
                      child: RaisedButton(
                          onPressed: loading
                              ? null
                              : () {
                                  if (jenisBeritaSelected == null ||
                                      komentar == null ||
                                      lampiran.length == 0 ||
                                      statusSelected == null) {
                                    ShowAlert.show(context, "Validasi",
                                        "Semua data harus diisi!");
                                  } else {
                                    postBerita(context);
                                  }
                                },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20)),
                          color: buttonColor,
                          child: !loading
                              ? Text("Simpan",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                              : CircularProgressIndicator()),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget text(text) {
    return Text(
      text,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  void postBerita(BuildContext context) async {
    CekKoneksi.cek().then((val) async {
      if (val) {
        setState(() {
          loading = true;
        });
        List<String> files = [];
        for (var i = 0; i < lampiran.length; i++) {
          ByteData image = await lampiran[i].getByteData();
          Uint8List imageUint8List = image.buffer
              .asUint8List(image.offsetInBytes, image.lengthInBytes);
          List<int> imageListInt = imageUint8List.cast<int>();
          String base64Image =
              "data:image/jpeg;base64,${base64Encode(imageListInt)}";
          files.insert(i, base64Image);
        }
        await BeritaModel.postBerita(jenisBeritaSelected['id'], komentar, files,
                statusSelected['id'].toString())
            .then((value) {
          setState(() {
            loading = false;
          });
          if (value.status) {
            Navigator.pop(context);
            ShowAlert.show(context, "Berhasil", value.messages);
          } else {
            ShowAlert.show(context, "Gagal", value.messages);
          }
        });
      } else {
        ShowAlert.show(context, "Koneksi", "Cek Koneksi internet anda");
      }
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: lampiran,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Pilih Gambar",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      lampiran = resultList;
      _error = error;
    });
  }
}
