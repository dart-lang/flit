import 'dart:io' as io;
import 'package:flutter_tools/src/device.dart';
import 'package:flutter_tools/src/doctor.dart';
import 'package:flutter_tools/src/base/context.dart';
import 'package:flutter_tools/src/base/logger.dart';

// import 'package:flutter_tools/src/commands/run.dart';
// import 'package:flutter_tools/src/commands/install.dart';

import 'package:flutter_server/run_command.dart';


main(List<String> args) async {

  // Initialize globals.
  context[Logger] = new StdoutLogger();
  context[DeviceManager] = new DeviceManager();
  Doctor.initGlobal();

  // DeviceManager dm = context[DeviceManager];
  // var devices = await dm.getDevices();

  // print(devices);

  // print ("Devices enum complete");

  print ("About to create Run");

  RunCommand runCmd = new RunCommand();


// InstallCommand installCommand = new InstallCommand();
// installCommand.run();
  //
  // RunCommand runCommand = new RunCommand();
  // runCommand.argResults = new
  // runCommand.argResults['hot'] = true;
  // runCommand.run();

}
