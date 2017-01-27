// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('config_settings.html')
library mobiledeviceadmin.lib.config_settings;

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

class User extends JsProxy {
  @reflectable
  String username;

  @reflectable
  String password;

  @reflectable
  Map authorizationHeader;

  @reflectable
  String authorizationToken;

  User(this.username, this.password, this.authorizationHeader, this.authorizationToken);
}

 class Environment extends JsProxy{
   @reflectable
   String deviceListUrl;

   @reflectable
   String deviceDetailUrl;

   @reflectable
   String appSettingsUrl;

   @reflectable
   String protobufAppconfigConverterUrl;

   @reflectable
   String jsonToProtobufConverterUrl;

   @reflectable
   String name;

   Environment(this.name, this.deviceListUrl, this.deviceDetailUrl, this.appSettingsUrl, this.protobufAppconfigConverterUrl, this.jsonToProtobufConverterUrl);
 }


/// Uses [PaperInput]
@PolymerRegister('config-settings')
class ConfigSettings extends PolymerElement {

  @Property(notify: true)
  Environment environment;

  @Property(notify: true)
  User user;



  /// Constructor used to create instance of MainApp.
  ConfigSettings.created() : super.created();

  /// Called when main-app has been fully prepared (Shadow DOM created,
  /// property observers set up, event listeners attached).
  ready() {
    //set('environment', new Environment("TEST", "test_devices.json", "https://qa.stlproxy.kapschtraffic.com:8443/smartphone/v2/devices", "test_appsettings.json", "http://192.168.99.100:8080/appconfigapi/v1/appconfig"));
    //set('environment', new Environment("SIT", "http://equipmentmanager.service.sitstlproxy.gpsllab.local/v1/devices", "http://equipmentmanager.service.sitstlproxy.gpsllab.local/smartphone/v2/devices", "http://equipmentmanager.service.sitstlproxy.gpsllab.local/v1/appsettings", "http://192.168.99.100:8081/appconfigapi/v1/appconfig", "http://192.168.99.100:8081/appconfigapi/v1/json2base64"));
    set('environment', new Environment("SIT localhost", "http://equipmentmanager.service.sitstlproxy.gpsllab.local/v1/devices", "http://equipmentmanager.service.sitstlproxy.gpsllab.local/smartphone/v2/devices", "http://equipmentmanager.service.sitstlproxy.gpsllab.local/v1/appsettings", "http://localhost:8080/appconfigapi/v1/appconfig", "http://localhost:8080/appconfigapi/v1/json2base64"));
    //set('environment', new Environment("SIT EXT", "https://qa.stlproxy.kapschtraffic.com:8443/eqm/v1/devices", "https://qa.stlproxy.kapschtraffic.com:8443/eqm//smartphone/v2/devices", "https://qa.stlproxy.kapschtraffic.com:8443/eqm/v1/appsettings", "http://138.68.66.69:8081/appconfigapi/v1/appconfig", "http://138.68.66.69:8081/appconfigapi/v1/json2base64"));

    set('user', new User("polt","polt", {"Authorization" : "Basic dXNlcjE6cGFzc3dvcmQ="}, "Basic dXNlcjE6cGFzc3dvcmQ="));
    print("Config Settings Item created");
  }
}
