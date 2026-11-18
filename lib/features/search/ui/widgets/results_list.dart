import 'package:booking/core/routing/routes.dart';
import 'package:booking/core/helpers/extensions.dart';
import 'package:booking/features/search/data/models/room.dart';
import 'package:booking/features/search/data/models/search_query.dart';
import 'package:booking/features/search/ui/widgets/result_item.dart';
import 'package:flutter/material.dart';

/// Live results list — stable keys by room ID, in-place updates (no
/// clear-refill jump), scroll position preserved across snapshot rebuilds.
class ResultsList extends StatelessWidget {
  const ResultsList({super.key, required this.rooms, required this.query});

  final List<Room> rooms;
  final SearchQuery query;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const PageStorageKey<String>('results-list'),
      itemCount: rooms.length,
      itemBuilder: (BuildContext context, int index) {
        final Room room = rooms[index];
        return ResultItem(
          key: ValueKey<String>(room.id),
          room: room,
          onTap: () => context.pushNamed(
            Routes.roomDetailsScreen,
            arguments: RoomDetailsArgs(roomId: room.id, query: query),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 1,
        color: Colors.grey.shade200,
      ),
    );
  }
}

/// Typed argument class for the details route (cast once in the router).
class RoomDetailsArgs {
  const RoomDetailsArgs({required this.roomId, required this.query});

  final String roomId;
  final SearchQuery query;
}
