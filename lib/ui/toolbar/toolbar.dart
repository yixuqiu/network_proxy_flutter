import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_proxy/ui/toolbar/setting/setting.dart';
import 'package:network_proxy/ui/toolbar/ssl/ssl.dart';
import 'package:window_manager/window_manager.dart';

import '../../network/bin/server.dart';
import '../left/domain.dart';
import 'launch/launch.dart';

class Toolbar extends StatefulWidget {
  final ProxyServer proxyServer;
  final GlobalKey<DomainWidgetState> domainStateKey;

  const Toolbar(this.proxyServer, this.domainStateKey, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _ToolbarState();
  }
}

class _ToolbarState extends State<Toolbar> with WindowListener {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: Platform.isMacOS ? 80 : 30)),
        SocketLaunch(proxyServer: widget.proxyServer),
        const Padding(padding: EdgeInsets.only(left: 30)),
        IconButton(
            tooltip: "清理",
            icon: const Icon(Icons.cleaning_services_outlined),
            onPressed: () {
              widget.domainStateKey.currentState?.clean();
            }),
        const Padding(padding: EdgeInsets.only(left: 30)),
        SslWidget(proxyServer: widget.proxyServer),
        const Padding(padding: EdgeInsets.only(left: 30)),
        Setting(proxyServer: widget.proxyServer),
      ],
    );
  }
}
