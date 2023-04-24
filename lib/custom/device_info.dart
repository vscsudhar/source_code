
import 'package:flutter/material.dart';

class DeviceInfo{
  BuildContext context;
double height,width;

  DeviceInfo(this.context){
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
  }

}