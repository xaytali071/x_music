import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/controller/providers.dart';
import 'package:xmusic/viwe/components/background_widget.dart';
import '../../../../model/message_model.dart';
import '../../../components/style.dart';
import 'in_message.dart';
import 'message_widget.dart';

class MessagesPage extends ConsumerStatefulWidget {
  final List<MessageModel>? listOfMessage;

  const MessagesPage({super.key, required this.listOfMessage});

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    bool mode=ref.watch(appProvider).darkMode;
    return BackGroundWidget(
      child: Column(
        children: [
          30.verticalSpace,
          Text("Messages",style: Style.boldText(color: mode ? Style.primaryColor : Style.blackColor),),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: widget.listOfMessage?.length ?? 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: (){
                      ref.read(userProvider.notifier).daleteMessage(id: widget.listOfMessage?[index].id ?? "");
                    },
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InMessagePage(
                              image: widget.listOfMessage?[index].image ?? "",
                              title: widget.listOfMessage?[index].title ?? "",
                              body: widget.listOfMessage?[index].body ?? "",
                              time: widget.listOfMessage?[index].time
                                  .toString() ??
                                  "",
                              id: widget.listOfMessage?[index].id ?? "",
                            ),
                          ));
                    },
                    child: MessageWidget(
                      image: widget.listOfMessage?[index].image ?? "",
                      title: widget.listOfMessage?[index].title ?? "",
                      body: widget.listOfMessage?[index].body ?? "",
                      time:
                      widget.listOfMessage?[index].time.toString() ?? "",
                      isRead: widget.listOfMessage?[index].isRead ?? false,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}