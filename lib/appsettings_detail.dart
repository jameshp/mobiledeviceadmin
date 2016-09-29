// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('appsettings_detail.html')
library mobiledeviceadmin.lib.appsettings_detail;

import 'dart:html';
import 'dart:core';
import 'dart:convert';

import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_icon_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
import 'package:polymer_elements/paper_material.dart';
import 'package:polymer_elements/paper_spinner.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_toast.dart';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/hardware_icons.dart';
import 'package:polymer_elements/maps_icons.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:custom_elements/paper_chip.dart';



//import 'package:polymer_elements/iron_flex_layout.dart'; // to allow flexbox styling

/// Uses [PaperInput]
@PolymerRegister('appsettings-detail')
class AppsettingsDetail extends PolymerElement {

  IronAjax settingsRequest;
  PaperToast toast;
  PaperDialog appSettingsContentDialog;

  @property
  String url;

  @property
  Map data;  //shown app settings content

  @property
  Map device; //input for the rest

  @property
  String appsettingscontent;

  @property
  Map appsettings;

  //called when a app settings response is received
  @reflectable
  processSettingsResponse(_, __) async {
    //if i process it as text
    String content = settingsRequest.lastResponse;

    //set('appsettingscontent', UTF8.decode(BASE64.decode(content), allowMalformed: true));

    final blob = new Blob([content], 'text/plain');
    final form = new FormData()
        //..append('field1', 'hello')
        ..appendBlob('appConfig', blob, 'appsettings.b64');

    final response = await HttpRequest.request(
          url, //'http://localhost:4242/appconfigapi/v1/appconfig',
          method: 'POST',
          sendData: form);
    final result = JSON.decode(response.responseText);
    //print (result);
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(result['appConfigJson']);
    print (prettyprint);
    set('appsettings', result);
    set('appsettingscontent', prettyprint);
    print("Processing done");
    //Blob version - if i set iron ajax element to blob
    // Blob content = settingsRequest.lastResponse;
    // FileReader r = new FileReader();
    // r.onLoad.listen((e) => set('appsettingscontent', BASE64.decode(r.result)));
    // r.readAsText(content);

  }

  @reflectable
  showFileContentDialog(_,__){
    appSettingsContentDialog.open();
  }

  @reflectable
  downloadJsonFile(_,__){
    var blob = new Blob([appsettingscontent], 'text/plain', 'native');

    AnchorElement tl = document.createElement('a');
    tl..attributes['href'] = Url.createObjectUrlFromBlob(blob).toString()//'data:text/plain;charset=utf-8,' + Uri.encodeComponent(text)
      ..attributes['download'] = "appSettings_" + device['deviceId'].toString() + "_" + device['appsettingsVersion'].toString() + ".json"
      ..click();
    }

  /// Constructor used to create instance of MainApp.
  AppsettingsDetail.created() : super.created();

 /// Called when main-app has been fully prepared (Shadow DOM created,
 /// property observers set up, event listeners attached).
  ready() {
    settingsRequest = $$('#settingsRequest');
    appSettingsContentDialog = $$('#FileContentDialog');
    print ("AppSettings Detail ready");
  }
}
