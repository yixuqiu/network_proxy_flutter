import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network/ui/toolbar/setting/theme.dart';

import '../../../network/util/host_filter.dart';
import 'filter.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: "设置",
      icon: const Icon(Icons.settings),
      surfaceTintColor: Colors.white70,
      offset: const Offset(10, 30),
      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
              child: Row(children: [
            const Padding(padding: EdgeInsets.only(left: 18)),
            const Text("端口号：", style: TextStyle(fontSize: 15)),
            SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: "8888",
                  textAlign: TextAlign.center,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(5),
                    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                  ],
                  decoration: const InputDecoration(),
                ))
          ])),
          const PopupMenuItem(
            child: ThemeSetting(),
          ),
          PopupMenuItem<String>(
            child: ListTile(title: const Text("域名过滤"), trailing: const Icon(Icons.arrow_right), onTap: () => _filter()),
          )
        ];
      },
    );
  }

  void _filter() {
    final ValueNotifier<bool> hostEnableNotifier = ValueNotifier(false);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
            scrollable: true,
            actions: [
              FilledButton(
                  child: const Text("关闭"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    hostEnableNotifier.dispose();
                  }),
            ],
            title: const Text("域名过滤", style: TextStyle(fontSize: 18)),
            content: SizedBox(
              width: 680,
              height: 450,
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                      flex: 1,
                      child: DomainFilter(
                          title: "白名单",
                          subtitle: "只代理白名单中的域名, 白名单启用黑名单将会失效",
                          hostList: HostFilter.whites,
                          hostEnableNotifier: hostEnableNotifier)),
                  const SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: DomainFilter(
                          title: "黑名单",
                          subtitle: "黑名单中的域名不会代理",
                          hostList: HostFilter.blacklist,
                          hostEnableNotifier: hostEnableNotifier)),
                ],
              ),
            ));
      },
    );
  }
}
