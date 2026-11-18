import 'package:booking/core/di/dependency_injection.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/core/theming/colors.dart';
import 'package:booking/core/theming/styles.dart';
import 'package:booking/core/widgets/app_text_button.dart';
import 'package:booking/features/booking/logic/cubit/booking_cubit.dart';
import 'package:booking/features/booking/logic/cubit/booking_state.dart';
import 'package:booking/features/search/data/models/room.dart';
import 'package:booking/features/search/ui/widgets/result_item.dart';
import 'package:booking/features/room_details/ui/screens/room_details_screen.dart';
import 'package:booking/features/booking/ui/widgets/confirm_bloc_listener.dart';
import 'package:booking/features/booking/ui/widgets/booking_success_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Confirm screen — the `submitting` state disables the confirm button so a
/// double-tap cannot race itself (CUJ 2); success swaps the content in place
/// (no separate route); conflict routes to the designed conflict screen.
class BookingConfirmScreen extends StatelessWidget {
  const BookingConfirmScreen({super.key, required this.args});

  final ConfirmBookingArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingCubit>(
      create: (BuildContext context) => getIt<BookingCubit>(),
      child: _BookingConfirmBody(args: args),
    );
  }
}

class _BookingConfirmBody extends StatelessWidget {
  const _BookingConfirmBody({required this.args});

  final ConfirmBookingArgs args;

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (BuildContext context, BookingState state) =>
          ConfirmBlocListener.handle(context, state),
      builder: (BuildContext context, BookingState state) {
        return Scaffold(
          appBar: AppBar(title: Text(args.room.city)),
          body: switch (state) {
            // Success replaces the form content in place (no new route).
            BookingSuccess() => BookingSuccessView(booking: state.booking),
            OfflinePending() => _OfflinePendingView(
                onRetry: () => context.read<BookingCubit>().retry()),
            _ => _ConfirmForm(args: args, userId: currentUser?.uid ?? ''),
          },
        );
      },
    );
  }
}

class _ConfirmForm extends StatelessWidget {
  const _ConfirmForm({required this.args, required this.userId});

  final ConfirmBookingArgs args;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final Room room = args.room;
    final int nights = args.query.stayRange.nights;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResultItem(room: room, onTap: () {}),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${args.query.stayRange.checkIn.display} → '
                  '${args.query.stayRange.checkOut.display}',
                  style: TextStyles.font14DarkBlueMedium,
                ),
                SizedBox(height: 8.h),
                Text(
                  '$nights ${AppStrings.nightsLabel} · '
                  '${room.pricePerNight} ${AppStrings.perNight}',
                  style: TextStyles.font14GrayRegular,
                ),
                SizedBox(height: 24.h),
                BlocBuilder<BookingCubit, BookingState>(
                  buildWhen: (BookingState previous, BookingState current) =>
                      previous is Submitting || current is Submitting,
                  builder: (BuildContext context, BookingState state) =>
                      AppTextButton(
                    buttonText: AppStrings.bookButton,
                    isLoading: state is Submitting,
                    backgroundColor: ColorsManager.mainBlue,
                    textStyle: TextStyles.font16WhiteSemiBold,
                    width: double.infinity,
                    onPressed: userId.isEmpty
                        ? null
                        : () => context.read<BookingCubit>().submit(
                              userId: userId,
                              roomId: room.id,
                              stayRange: args.query.stayRange,
                            ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The honest offline outcome: no nights were taken; retry re-validates.
class _OfflinePendingView extends StatelessWidget {
  const _OfflinePendingView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: ColorsManager.gray),
            SizedBox(height: 16.h),
            Text(AppStrings.offlinePendingTitle,
                style: TextStyles.font16DarkBlueBold,
                textAlign: TextAlign.center),
            SizedBox(height: 8.h),
            Text(AppStrings.offlinePendingBody,
                style: TextStyles.font14GrayRegular, textAlign: TextAlign.center),
            SizedBox(height: 16.h),
            AppTextButton(
              buttonText: AppStrings.retry,
              backgroundColor: ColorsManager.mainBlue,
              textStyle: TextStyles.font16WhiteSemiBold,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
