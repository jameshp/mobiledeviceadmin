// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('device_list.html')
library mobiledeviceadmin.lib.device_list;

import 'dart:html';
import 'dart:core';
import 'dart:convert';
import 'dart:async';
import 'package:async/async.dart';


import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_material.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_icon_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/hardware_icons.dart';
import 'package:polymer_elements/maps_icons.dart';

import 'package:polymer_elements/paper_spinner.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:custom_elements/iron_data_table.dart';

import 'package:mobiledeviceadmin/device_item.dart';
import 'package:mobiledeviceadmin/config_settings.dart';



/// Uses [PaperInput]
@PolymerRegister('device-list')
class DeviceList extends PolymerElement {
  IronAjax _deviceRequest;

  @Property(observer: 'configChanged')
  Environment environment;

  @Property(observer: 'userChanged')
  User user;

  @property
  String url; //= "http://equipmentmanager.service.sitstlproxy.gpsllab.local/v1/devices";

  @property
  String detailUrl;// = "http://equipmentmanager.service.sitstlproxy.gpsllab.local/smartphone/v2/devices";

  @Property(observer: 'ajaxErrorChanged')
  Object ajaxError;

  @Property(notify: true, reflectToAttribute: true)
  Map device;

  @property
  String error = "";

  @Property(notify:true)
  List<Map> devicelist;

  @reflectable
  void ajaxErrorChanged(newValue, oldValue) {
    print("AjaxError_new: ${newValue}  + ${oldValue}");
    set('error', _deviceRequest.lastError);
    print("Ajax Error2 : ${_deviceRequest.lastError}");
  }

  @reflectable
  void configChanged(Environment newValue, oldValue) {
    print("Envirnment settings changed: ${newValue}  + ${oldValue}");
    //load devices if config is available - a bit dirty
    set('url', newValue.deviceListUrl);
    set('detailUrl', newValue.deviceDetailUrl);

    print("devicelist config changed!");
    if (user!=null){
      print("load devicelist");
      loadDeviceList();
    }

  }

  @reflectable
  void userChanged(_,__){
    print("devicelist user changed!");
    if (environment != null){
      print("load devicelist");
      loadDeviceList();
    }
  }

  @reflectable
  void handleRequestError(event, target) {
    print("handle Error $event - $target");
  }

  @reflectable
  void showAppSettingsDetails(Event event,var target){
    print("show App settings details $event - $target");
    String deviceId = (event.currentTarget as PaperButton).dataset['id']; //get data-deviceID attribute //.attributes['data-deviceId'];
    print("DeviceID Attribute: $deviceId");
    //get the Map item from the list of devices and set this one as current device
    Map device = devicelist.firstWhere((device)=>device['deviceId'] == deviceId, orElse: () => null);
    print ("Found device: $device");
    set('device', device);
  }
  // @property
  // String headers = '{"Authorization" : "Basic dXNlcjE6cGFzc3dvcmQ="}';
  //'{"Origin" : "http://equipmentmanager.service.sitstlproxy.gpsllab.local"}';

  void loadDeviceList() {
    var httpRequest = new HttpRequest();
    httpRequest
      ..open('GET', url)
      ..setRequestHeader("Authorization", user.authorizationToken)
      ..onLoadEnd.listen((e) => requestComplete(httpRequest))
      ..send('');
  }

  requestComplete(HttpRequest request) async {
    if (request.status == 200) {
      var devices = JSON.decode(request.responseText);
      var updatedDevices = await loadDetails(devices);

      // JsonEncoder encoder = new JsonEncoder.withIndent('  ');
      // String prettyprint = encoder.convert(updatedDevices);
      // print("$prettyprint");
      set('devicelist', updatedDevices);
      print("loaded DeviceList");
    } else {
      set('error', 'Request failed, status=${request.status}');
    }
  }

  loadDetails(List devices) async {
    //var stream = new Stream.fromIterable(devices);
    FutureGroup g = new FutureGroup();
    for (var d in devices){
      g.add(getAppSettingsDetails(d));
      g.add(getRoadFeatureDetails(d));
      // await getAppSettingsDetails(d);
      // await getRoadFeatureDetails(d);
    }
    g.close();
    await g.future;
    //devices.forEach((d) => );
    //devices.forEach((d) => getRoadFeatureDetails(d));
    return devices;
  }

  getRoadFeatureDetails(dev) async{
    var roadFeatureRequest = await HttpRequest.request(
        detailUrl + '/' + dev['deviceId'] + '/roadfeatures/LATEST',
        method: 'GET',
        requestHeaders: {"Authorization": user.authorizationToken});

    if (roadFeatureRequest.status == 200) {
      Map roadFeatures = JSON.decode(roadFeatureRequest.responseText);
      //print ("RoadFeatures: {$roadFeatures}");
      dev['roadFeaturesVersion'] = roadFeatures['roadFeature']['version'];
    }
    return;
  }

  getAppSettingsDetails(dev) async {
    var request = await HttpRequest.request(
        detailUrl + '/' + dev['deviceId'] + '/appsettings/LATEST',
        method: 'GET',
        requestHeaders: {
          "Authorization": user.authorizationToken
        }); //dev['deviceId']
    if (request.status == 200) {
      Map appSettings = JSON.decode(request.responseText);
      // print("Fetched Appsettings for {$dev['deviceId']} : {$appSettings}");
      dev['appsettingsVersion'] = appSettings['version'];
      dev['appsettingsUrl'] = appSettings['url'];
      return;// {'version': appsettings['version'], 'url': appsettings['url']};
    }
    return;
  }


  @reflectable
  reloadList() {
    this._deviceRequest.generateRequest();
  }
  // @Property(computed: 'computeFullName(first, last)')
  // String fullName;

  // @reflectable
  // String computeFullName(String first, String last) {
  //   return '$first $last';
  // }

  /// Constructor used to create instance of MainApp.
  DeviceList.created() : super.created();

  /// Called when main-app has been fully prepared (Shadow DOM created,
  /// property observers set up, event listeners attached).
  ready() {
    _deviceRequest = $$('#deviceRequest');
    print("DevicList init done");
    //loadDeviceList();
  }
}
