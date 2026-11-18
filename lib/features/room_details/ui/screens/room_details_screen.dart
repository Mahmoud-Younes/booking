import 'package:booking/core/di/dependency_injection.dart';
import 'package:booking/core/helpers/stay_date.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/routing/routes.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:booking/core/widgets/app_network_image.dart';
import 'package:booking/core/widgets/app_text_button.dart';
import 'package:booking/features/room_details/data/repos/room_details_repo.dart';
import 'package:booking/features/search/data/models/room.dart';
import 'package:booking/features/search/ui/widgets/results_list.dart';
import 'package:booking/features/search/data/models/search_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Room details — one-shot load exercising the load-from-ID path for shared
/// links; the availability check runs against the night documents for the
/// requested window before the book CTA is enabled.
class RoomDetailsScreen extends StatefulWidget {
  const RoomDetailsScreen({super.key, required this.args});

  final RoomDetailsArgs args;

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  Room? _room;
  bool? _nightsFree;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final Room? room =
        await getIt<RoomDetailsRepo>().getRoom(widget.args.roomId);
    final bool? free = room == null
        ? null
        : await getIt<RoomDetailsRepo>()
            .areNightsFree(widget.args.roomId, widget.args.query.stayRange);
    if (!mounted) {
      return;
    }
    setState(() {
      _room = room;
      _nightsFree = free;
      _loading = false;
    });
  }

  void _goToConfirm() {
    Navigator.pushNamed(
      context,
      Routes.bookingConfirmScreen,
      arguments: ConfirmBookingArgs(room: _room!, query: widget.args.query),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_room == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('الغرفة غير موجودة', style: TextStyles.font16DarkBlueBold),
        ),
      );
    }
    final Room room = _room!;
    final StayDateRange stayRange = widget.args.query.stayRange;
    return Scaffold(
      appBar: AppBar(title: Text(room.city)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppNetworkImage(imageUrl: room.imageUrl, height: 220.h, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.title, style: TextStyles.font24BlueBold),
                  SizedBox(height: 8.h),
                  Text('${room.city} · ${room.capacity} ${AppStrings.guestsLabel}',
                      style: TextStyles.font14GrayRegular),
                  SizedBox(height: 8.h),
                  Text('${stayRange.checkIn.display} → ${stayRange.checkOut.display}',
                      style: TextStyles.font14DarkBlueMedium),
                  SizedBox(height: 8.h),
                  Text('${stayRange.nights} ${AppStrings.nightsLabel}',
                      style: TextStyles.font13BlueRegular),
                  SizedBox(height: 16.h),
                  if (_nightsFree == false)
                    Text('هذه التواريخ محجوزة — جرّب تواريخ أخرى',
                        style: TextStyles.font13ErrorRedRegular),
                  SizedBox(height: 16.h),
                  AppTextButton(
                    buttonText: AppStrings.bookButton,
                    backgroundColor: ColorsManager.mainBlue,
                    textStyle: TextStyles.font16WhiteSemiBold,
                    width: double.infinity,
                    onPressed: _nightsFree == true ? _goToConfirm : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Typed argument carrier to the confirm screen.
class ConfirmBookingArgs {
  const ConfirmBookingArgs({required this.room, required this.query});

  final Room room;
  final SearchQuery query;
}
