// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('appsettings_list.html')
library mobiledeviceadmin.lib.appsettings_list;

import 'dart:html';
import 'dart:core';
import 'dart:async';

import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_material.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/paper_icon_item.dart';
import 'package:polymer_elements/paper_item_body.dart';
import 'package:polymer_elements/paper_menu.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/iron_ajax.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'package:mobiledeviceadmin/appsettings_item.dart';
import 'package:custom_elements/iron_data_table.dart';

//paper dialog imports
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/neon_animation.dart';
import 'package:polymer_elements/neon_animatable.dart';
import 'package:polymer_elements/neon_animation/animations/scale_up_animation.dart';
import 'package:polymer_elements/neon_animation/animations/fade_out_animation.dart';

import 'package:polymer_elements/paper_toast.dart';
import 'dart:convert';
import 'package:mobiledeviceadmin/config_settings.dart';

/// Uses [PaperInput]
@PolymerRegister('appsettings-list')
class AppsettingsList extends PolymerElement {
  IronAjax _appsettingsRequest;
  PaperDialog _bindDialog;
  PaperDropdownMenu _deviceDropdown;
  PaperToast _bindToast;

  @Property(observer: 'configChanged')
  Environment environment;

  @Property(observer: 'userChanged')
  User user;


  @property
  String url; //=   "http://equipmentmanager.service.sitstlproxy.gpsllab.local/v1/appsettings";

  @Property(observer: 'ajaxErrorChanged')
  Object ajaxError;

  @property
  String error = "";

  @property
  List<Map> devices;

  @property
  String currentAppSettingsId;

  @reflectable
  void configChanged(Environment newValue, oldValue) {
    print("Appsettings element - Envirnment settings changed: ${newValue}  + ${oldValue}");
    //load devices if config is available - a bit dirty
    set('url', newValue.appSettingsUrl);

    if (user!=null){
      loadList();
    }

  }

  @reflectable
  void userChanged(_,__){
    if (environment != null){
      loadList();
    }
  }



  @reflectable
  void ajaxErrorChanged(newValue, oldValue) {
    print("AjaxError_new: ${newValue}  + ${oldValue}");
    set('error', _appsettingsRequest.lastError);
    print("Ajax Error2 : ${_appsettingsRequest.lastError}");
  }

  @reflectable
  void handleRequestError(event, target) {
    print("handle Error $event - $target");
  }

  @reflectable
  void showBindToDeviceDialog(Event event, var target){
    String appSettingsId = (event.currentTarget as PaperButton).dataset['id'];
    //Show Dialog
    print ("AppSettingsID: ${appSettingsId}");
    set('currentAppSettingsId', appSettingsId);
    print ("available Devices: ${devices}");
    _bindDialog.open();
  }

  @reflectable
  void bind(Event event, var target){
    String internalDeviceId = (_deviceDropdown.selectedItem as PaperItem).dataset['id'];
    print("selected item: ${_deviceDropdown.selectedItemLabel}");
    print("internal id: $internalDeviceId");
    BindDeviceRequest(currentAppSettingsId, internalDeviceId);
  }

  void BindDeviceRequest(String appSettingsId, String deviceId) {
    String bindUrl = url + '/' + appSettingsId + '/devices/' + deviceId;
    var httpRequest = new HttpRequest();
    httpRequest
      ..open('PUT', bindUrl)
      ..setRequestHeader("Authorization", user.authorizationToken) //todo fix with settings
      ..onLoadEnd.listen((e) => bindRequestComplete(httpRequest))
      ..send('');
  }

  bindRequestComplete(HttpRequest request) {
    if (request.status == 200) {
      var response = JSON.decode(request.responseText);
      print("Binding Completed! $response");
      _bindToast.text = "Binding Sucessful";
      _bindToast.open();
      set('error', "");
    } else {
      set('error', 'Request failed, status= ${request.status}');
    }
  }



  @reflectable
  releaseAppSettings(Event event, var target) {
    print("show App settings details $event - $target");
    String appSettingsId = (event.currentTarget as PaperButton).dataset['id'];
    print("appsettings id $appSettingsId");
    PaperButton b = event.currentTarget;
    if (releaseRequest(appSettingsId) == true) {
      b.disabled;
      b.text = "Released :)";
    } else {
      b.text = "Oops...Retry";
    }
  }

  bool releaseRequest(String appSettingsId) {
    HttpRequest.request(url + '/' + appSettingsId,
        method: 'PUT',
        requestHeaders: {
          "Authorization": user.authorizationToken
        }).then((roadFeatureRequest) {
          if (roadFeatureRequest.status == 200) {
            return true;
          }
          else {
            return false;
      }
    });
    return true;
  }


  @reflectable
  loadList() {
    print ("Loading appsettingslist headers");
    print (user.authorizationHeader);
    this._appsettingsRequest.headers = {"Authorization": user.authorizationToken};
    this._appsettingsRequest.generateRequest();
  }

  /// Constructor used to create instance of MainApp.
  AppsettingsList.created() : super.created();

  /// Called when main-app has been fully prepared (Shadow DOM created,
  /// property observers set up, event listeners attached).
  ready() {
    _appsettingsRequest = $$('#appsettingsRequest');
    _bindDialog = $$('#BindDialog');
    _deviceDropdown = $$('#deviceDropdown');
    _bindToast = $$('#bindtoast');
    print("App Settings List init done");
  }
}
