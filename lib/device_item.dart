// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('device_item.html')
library mobiledeviceadmin.lib.device_item;

import 'dart:html';
import 'dart:core';
import 'dart:convert';

import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_icon_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
import 'package:polymer_elements/paper_spinner.dart';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/hardware_icons.dart';
import 'package:polymer_elements/maps_icons.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/iron_collapse.dart';

import 'package:web_components/web_components.dart';
import 'features_map.dart';

//import 'package:polymer_elements/iron_flex_layout.dart'; // to allow flexbox styling

/// Uses [PaperInput]
@PolymerRegister('device-item')
class DeviceItem extends PolymerElement {
  IronCollapse collapse;
  IronAjax settingsRequest;
  bool loaded = false;

  @property
  Map data;

  @property
  String appsettingscontent;

  @property
  Map appsettings;

  /// Constructor used to create instance of MainApp.
  DeviceItem.created() : super.created();

  @reflectable
  void showAppSettings(_, __) {
    collapse = this.$$('#AppSettingsCollapse');
    if (!loaded) {
      settingsRequest.generateRequest();
      loaded = true; //dirty, should be set by response event
    }
    collapse.toggle();
  }

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
          'http://localhost:4242/appconfigapi/v1/appconfig',
          method: 'POST',
          sendData: form);
    final result = JSON.decode(response.responseText);
    print (result);

    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String prettyprint = encoder.convert(result);
    set('appsettings', result);
    set('appsettingscontent',prettyprint);
    //Blob version - if i set iron ajax element to blob
    // Blob content = settingsRequest.lastResponse;
    // FileReader r = new FileReader();
    // r.onLoad.listen((e) => set('appsettingscontent', BASE64.decode(r.result)));
    // r.readAsText(content);


  }

  /// Called when main-app has been fully prepared (Shadow DOM created,
  /// property observers set up, event listeners attached).
  ready() {
    print("device Item created");
    settingsRequest = $$('#SettingsRequest');
  }
}
