// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
// ignore: Unused import
@HtmlImport('add_appsettings.html')
library mobiledeviceadmin.lib.add_appsettings;

import 'dart:html';
import 'dart:core';

import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_icon_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
import 'package:polymer_elements/paper_spinner.dart';
import 'package:polymer_elements/paper_progress.dart';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/hardware_icons.dart';
import 'package:polymer_elements/maps_icons.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

//paper dialog imports
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/neon_animation.dart';
import 'package:polymer_elements/neon_animatable.dart';
import 'package:polymer_elements/neon_animation/animations/scale_up_animation.dart';
import 'package:polymer_elements/neon_animation/animations/fade_out_animation.dart';


import 'package:mobiledeviceadmin/file_upload.dart';
import 'package:mobiledeviceadmin/config_settings.dart';
import 'dart:convert';



/// Uses [PaperInput]
@PolymerRegister('add-appsettings')
class AddAppsettings extends PolymerElement {

  PaperDialog dialog;
  PaperInput descriptionElement;

  @property
  String description; //description field used for the upload to the proxy

  @property
  String url; //converion service URL (JSON 2 protobuf dat file, base64 encoded)

  @property
  String addDeviceSettingsUrl;

  @property
  User user;

  @property
  String error;

  @Property(observer: 'convertedConfigUpdate')
  Map convertedConfig;

  // @Property(notify: true, observer: 'uploadFilesChanged')
  // var files;

  /// Constructor used to create instance of MainApp.
  AddAppsettings.created() : super.created();


  @reflectable
  convertedConfigUpdate(Map convertedConfig, oldValue){
    var config = convertedConfig['base64AppConfig'];
    print ("APP config to be uploaded: ${config}");
    // print ("Trigger upload!");
    // uploadAppSettingsToProxy();
    return;
  }

  @reflectable
  uploadAppSettingsToProxy(_,__){
    if (descriptionElement.validate() == false){
      set ('error', descriptionElement.errorMessage);
      return;
    }
    if (convertedConfig == null){
      set ('error', "No app config available for submission");
    }

    final blob = new Blob([convertedConfig['base64AppConfig']]);
    FormData fdata = new FormData(); // from dart:html
    fdata.append("description", description);
    fdata.appendBlob("file", blob, "filename");
    // fdata.append("fileName", f.fileName);
    // fdata.append("fileSize", f.fileSize.toString());

    //fdata.appendBlob("file2", data, "file2 super filename.txt"); //I thought this would set the filename... but it does not.

    HttpRequest req = new HttpRequest();
    req.open("POST", addDeviceSettingsUrl, async: true);
    req.setRequestHeader('Authorization', user.authorizationToken);
    //req.setRequestHeader("Content-type", "multipart/form-data");  //this works on chrome and firefox, but edge doubles the "multipart/form-adat" entry)
    req.onReadyStateChange.listen((Event e) {
      if (req.readyState == HttpRequest.DONE &&
          (req.status == 200 || req.status == 0)) {
        var  result = JSON.decode(req.responseText);
        print (result);

      }
      if (req.readyState == HttpRequest.DONE &&(req.status == 500)){
        var errorResult = JSON.decode(req.responseText);
        set('error',errorResult);
        print (errorResult);
      }
    });
    req.send(fdata);

  }

 /// Called when main-app has been fully prepared (Shadow DOM created,
 /// property observers set up, event listeners attached).
  ready() {
    print ("ADD App Settings Dialog item created");
    dialog = this.$$('#dialog');
    descriptionElement = this.$$('#description');
    print ("PAPER DIALOG ${dialog}");
  }
}
