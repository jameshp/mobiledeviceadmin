// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('features_map.html')
library mobiledeviceadmin.lib.features_map;

import 'dart:html';
import 'dart:core';
import 'package:google_maps/google_maps.dart';

// import 'package:polymer_elements/paper_input.dart';
// import 'package:polymer_elements/paper_card.dart';
// import 'package:polymer_elements/paper_button.dart';
// import 'package:polymer_elements/paper_item.dart';
// import 'package:polymer_elements/paper_icon_item.dart';
// import 'package:polymer_elements/paper_item_body.dart';
// import 'package:polymer_elements/paper_spinner.dart';
// import 'package:polymer_elements/iron_ajax.dart';
// import 'package:polymer_elements/iron_icon.dart';
// import 'package:polymer_elements/iron_icons.dart';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

// import 'package:polymer_elements/google_map.dart';
// import 'package:polymer_elements/google_map_poly.dart';
// import 'package:polymer_elements/google_map_point.dart';
// import 'package:polymer_elements/google_map_marker.dart';

//import 'package:polymer_elements/iron_flex_layout.dart'; // to allow flexbox styling

/// Uses [PaperInput]
@PolymerRegister('features-map')
class FeatureMap extends PolymerElement {
  GMap map;
  List<Polyline> lines = [];
  List<Marker> markers = [];
  List<Circle> circles = [];
  LatLngBounds bounds;

  @Property(notify: true, observer: 'roadFeaturesChanged')
  List roadFeatures;

  @Property(notify: true, observer: 'virtualGantryDetectionsChanged')
  List virtualGantryDetections;

  @reflectable
  void roadFeaturesChanged(newValue, oldValue) {
    cleanMap();
    print("New Road Features: $roadFeatures");
    bounds = new LatLngBounds();
    for (Map f in roadFeatures) {
      drawPolyLine(f);
      drawMarker(f);
      drawCircle(f);
    }
    //roadFeatures.forEach( (f) => drawPolyLine(f) );
    map.fitBounds(bounds);
  }

  @reflectable
  void virtualGantryDetectionsChanged(newVirtualGantries, oldVirtualGandries) {
    //TODO --> implement
  }

  drawPolyLine(Map roadFeature) {
    var lineCoords = new List();
    var coordinates = roadFeature['geometry']['coordinates'];

    for (var c in coordinates) {
      var point = new LatLng(c['lat'], c['lon']);
      lineCoords.add(point);
      bounds.extend(point);
    }

    print("line Coords $lineCoords");
    var pbaFeature = new Polyline(new PolylineOptions()
          ..path = lineCoords
          ..geodesic = true
          ..strokeColor = '#33CC66'
          ..strokeOpacity = 0.8
          ..strokeWeight = 5
          ..editable = false
        // ..fillColor = '#FF0000'
        // ..fillOpacity = 0.35
        );
    pbaFeature.map = map;
    lines.add(pbaFeature);

    print("polygon drawn");
  }

  drawCircle(Map roadFeature) {
    int triggerIndex = roadFeature['properties']['triggerIndex'];
    int maxDistance = roadFeature['properties']['maxDistance'];
    // String id = roadFeature['properties']['id'];
    // String directions = roadFeature['properties']['direction'] == 0 ? "one direction": "both directions";
    // String actions = roadFeature['properties']['actions'];

    var markerCoordinates =
        roadFeature['geometry']['coordinates'][triggerIndex];
    var point = new LatLng(markerCoordinates['lat'], markerCoordinates['lon']);

    //entrance circle marker
    var entranceCoordinates =
        roadFeature['geometry']['coordinates'][0];
    var entrancePoint = new LatLng(entranceCoordinates['lat'], entranceCoordinates['lon']);
    CircleOptions enrance_o = new CircleOptions()
      ..map = map
      ..radius = 1
      ..center = entrancePoint
      ..strokeColor = "#c44444";
    Circle ec = new Circle(enrance_o);
    circles.add(ec);

    CircleOptions o = new CircleOptions()
      ..map = map
      ..radius = maxDistance
      ..center = point
      ..strokeColor = "#4475c4";


    Circle c = new Circle(o);
    circles.add(c);
  }

  drawMarker(Map roadFeature) {
    print("draw marker $roadFeature");
    int triggerIndex = roadFeature['properties']['triggerIndex'];
    String name = roadFeature['properties']['name'];
    String id = roadFeature['properties']['id'];
    String directions = roadFeature['properties']['direction'] == 0
        ? "one direction"
        : "both directions";
    String actions = roadFeature['properties']['actions'];

    var markerCoordinates =
        roadFeature['geometry']['coordinates'][triggerIndex];
    var point = new LatLng(markerCoordinates['lat'], markerCoordinates['lon']);

    InfoWindow info = new InfoWindow(new InfoWindowOptions()
      ..content = """<div>Zone Id: $id </div>
                     <div> Name: $name </div>
                     <div> Directions: $directions</div>
                     <div> Actions: $actions</div>""");

    Marker m = new Marker(new MarkerOptions()
      ..position = point
      ..map = map
      ..title = name);
    m.onClick.listen((e) {
      info.open(map, m);
    });
    //m.addListener('click', () => info.open(map,m));

    markers.add(m);
  }

  void clearLines() {
    for (Polyline l in lines) {
      l.map = null;
    }
  }

  void clearMarkers() {
    for (Marker m in markers) {
      m.map = null;
    }
  }

  void clearCircles() {
    for (Circle m in circles) {
      m.map = null;
    }
  }

  void cleanMap() {
    clearLines();
    clearMarkers();
    lines = [];
    markers = [];
  }

  /// Constructor used to create instance of MainApp.
  FeatureMap.created() : super.created();

  // @reflectable
  // void mapReady(event,target){
  //     gmap.GMap m = _fmap.map as gmap.GMap;
  //     print ("Maps API Object ?: $m");
  //
  //     final myLatLng = new gmap.LatLng(-33.890542, 151.274856);
  //     new gmap.Marker(new gmap.MarkerOptions()
  //         ..position = myLatLng
  //         ..map = m);
  // }

  /// Called when main-app has been fully prepared (Shadow DOM created,
  /// property observers set up, event listeners attached).
  ready() {
    print("features-map was created!");
    // _fmap = $$('#fmap');
    // print ("Map Object: $_fmap");
    // _fmap.zoom = 15;

    final mapOptions = new MapOptions()
      ..zoom = 4
      ..center = new LatLng(48.1636157, 16.3546595);
    print("map options created");

    map = new GMap($$('#map-canvas'), mapOptions);
    print("map initialized");
    //final image = '${IMAGE_URL}/images/beachflag.png';
    final myLatLng = new LatLng(48.1636157, 16.3546595);
    print("latlong initalized");
    new Marker(new MarkerOptions()
      ..position = myLatLng
      ..map = map
      ..title = "Hello World!");
    print("marker added");
  }
}
