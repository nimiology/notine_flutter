import 'package:flutter/material.dart';
import 'package:notine_flutter/widgets/appbar.dart';

import '../models/sync_queue.dart';

class SyncQueueScreen extends StatefulWidget {
  static const routeName = '/sync-queue-screen';

  @override
  _SyncQueueScreenState createState() => _SyncQueueScreenState();
}

class _SyncQueueScreenState extends State<SyncQueueScreen> {
  List<SyncQueue> _syncQueueList = [];

  @override
  void initState() {
    super.initState();
    _loadSyncQueue();
  }

  Future<void> _loadSyncQueue() async {
    List<SyncQueue> syncQueueList = await SyncQueue.getSyncQueue();
    setState(() {
      _syncQueueList = syncQueueList;
    });
  }

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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              title: 'Sync Queue',
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
