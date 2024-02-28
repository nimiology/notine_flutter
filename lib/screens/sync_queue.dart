import 'package:flutter/material.dart';
import 'package:notine_flutter/widgets/appbar.dart';
import 'package:provider/provider.dart';

import '../models/sync_queue.dart';

class SyncQueueScreen extends StatefulWidget {
  static const routeName = '/sync-queue-screen';

  @override
  _SyncQueueScreenState createState() => _SyncQueueScreenState();
}

class _SyncQueueScreenState extends State<SyncQueueScreen> {
  List<SyncQueue> _syncQueueList = [];

  Future<void> _deleteAllSyncQueue() async {
    for (SyncQueue syncQueue in _syncQueueList) {
      syncQueue.sync();
    }
    setState(() {
      _syncQueueList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final syncQueueProvider = Provider.of<SyncQueueProvider>(context);
    _syncQueueList = syncQueueProvider.syncQueueList;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Sync Queue',
            ),
            Text(
              'process status: ${syncQueueProvider.processing.toString()}',
              style: textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: _syncQueueList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _syncQueueList.length,
                      itemBuilder: (context, index) {
                        SyncQueue syncQueue = _syncQueueList[index];
                        return Container(
                          margin: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                syncQueue.tableName,
                                style: textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                syncQueue.action,
                                style: textTheme.labelSmall,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                syncQueue.data.toString(),
                                style: textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('Sync Queue is empty'),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _deleteAllSyncQueue,
        tooltip: 'Delete All',
        child: Icon(Icons.delete),
      ),
    );
  }
}
