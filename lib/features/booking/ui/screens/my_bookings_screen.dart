import 'package:booking/core/di/dependency_injection.dart';
import 'package:booking/core/localization/app_strings.dart';
import 'package:booking/features/booking/logic/cubit/booking_cubit.dart';
import 'package:booking/features/booking/logic/cubit/booking_state.dart';
import 'package:booking/features/booking/logic/cubit/my_bookings_cubit.dart';
import 'package:booking/features/booking/logic/cubit/my_bookings_state.dart';
import 'package:booking/features/booking/ui/widgets/booking_item.dart';
import 'package:booking/features/booking/ui/widgets/cancel_bloc_listener.dart';
import 'package:booking/core/widgets/empty_state_view.dart';
import 'package:booking/core/widgets/failure_retry_card.dart';
import 'package:booking/core/error/firebase_error_mapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// My bookings — live stream of the user's bookings (stream cubit) with the
/// cancel ACTION on a separate BookingCubit (BlocListener over BlocBuilder).
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final String _userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<MyBookingsCubit>(
            create: (_) => getIt<MyBookingsCubit>()..load(_userId)),
        BlocProvider<BookingCubit>(create: (_) => getIt<BookingCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(AppStrings.myBookingsTitle)),
        body: BlocConsumer<BookingCubit, BookingState>(
          listener: (BuildContext context, BookingState state) =>
              CancelBlocListener.handle(context, state),
          builder: (BuildContext context, BookingState bookingState) =>
              BlocBuilder<MyBookingsCubit, MyBookingsState>(
            builder: (BuildContext context, MyBookingsState state) =>
                switch (state) {
              BookingsConnecting() =>
                const Center(child: CircularProgressIndicator()),
              BookingsEmpty() => EmptyStateView(
                  title: AppStrings.myBookingsTitle,
                  subtitle: AppStrings.bookingSuccessSubtitle,
                ),
              BookingsFailed() => Column(
                  children: [
                    FailureRetryCard(
                      message: FirebaseErrorMapper.message(state.failure),
                      onRetry: () =>
                          context.read<MyBookingsCubit>().load(_userId),
                    ),
                  ],
                ),
              BookingsLive() => ListView.builder(
                  itemCount: state.bookings.length,
                  itemBuilder: (BuildContext context, int index) => BookingItem(
                    key: ValueKey<String>(state.bookings[index].id),
                    booking: state.bookings[index],
                    cancelling: bookingState is Cancelling,
                    onCancel: () => context
                        .read<BookingCubit>()
                        .cancel(state.bookings[index]),
                  ),
                ),
            },
          ),
        ),
      ),
    );
  }
}
