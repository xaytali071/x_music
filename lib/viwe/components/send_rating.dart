import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xmusic/model/music_model.dart';
import 'package:xmusic/viwe/components/style.dart';
import 'package:xmusic/viwe/pages/auth/register_page.dart';


import '../../controller/audio_state/audio_state.dart';
import '../../controller/local_store.dart';
import '../../controller/providers.dart';
import '../../model/rating_model.dart';
import 'button/custom_button.dart';

class SendRating extends ConsumerStatefulWidget {
  final MusicModel movie;
  final String docId;
  const SendRating({super.key, required this.movie, required this.docId});

  @override
  ConsumerState<SendRating> createState() => _SendRatingState();
}

class _SendRatingState extends ConsumerState<SendRating> {
  int rating=0;

  @override
  Widget build(BuildContext context) {
    AudioState watch = ref.watch(audioProvider);
    final event = ref.read(audioProvider.notifier);
    bool mode=ref.watch(appProvider).darkMode;
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 200.h,
      decoration: BoxDecoration(
           color: mode ? Style.darkPrimaryColor : Style.primaryColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(10.r),topLeft: Radius.circular(10.r)),

      ),
      child: Column(
            children: [
              50.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (r) {
                      rating=r.toInt();

                    },
                  ),
                ],
              ),
              30.verticalSpace,
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomButton(text: "Send", onTap: ()  {
                  if(LocaleStore.getId()==null){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>const RegisterPage()
                    ));
                  } else if((widget.movie.userIdList ?? [] ).contains(LocaleStore.getId())){
                    Navigator.pop(context);
                  }
                  else {
                    List<String> l = widget.movie.userIdList ?? [];
                    l.add(LocaleStore.getId());
                    int r = (widget.movie.rating?.toInt() ?? 0) + rating;
                    event.sendRating(
                        list: l, docId: widget.docId, rating: r);
                    Navigator.pop(context);
                  }
                }),
              )
            ],
          )
    );
  }
}