import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../helper/auth_jwt_token_helper.dart';
import '../helper/db_helpers.dart';
import '../helper/internet_connection.dart';
import 'category.dart';
import 'note.dart';

class SyncQueue {
  int id;
  String action;
  String tableName;
  Map<String, dynamic> data;
  bool synced;

  SyncQueue(
      {required this.id,
      required this.action,
      required this.tableName,
      required this.data,
      required this.synced});

  static SyncQueue syncQueueFromMap(Map<String, dynamic> map) {
    return SyncQueue(
      id: map['id'],
      action: map['action'],
      tableName: map['table_name'],
      data: json.decode(map['data']),
      synced: map['synced'] == 1,
    );
  }

  static Future<SyncQueue> queueSyncRequest(
      {required String action,
      required String tableName,
      required Map<String, dynamic> data}) async {
    final id = await DBHelper.insert(
      'sync_queue',
      {
        'action': action,
        'table_name': tableName,
        'data': json.encode(data),
        'synced': 0,
      },
    );
    return SyncQueue(
        id: id,
        action: action,
        tableName: tableName,
        data: data,
        synced: false);
  }

  Future<SyncQueue> sync() async {
    final instanceMap = {
      'id': id,
      'action': action,
      'table_name': tableName,
      'data': json.encode(data),
      'synced': 1,
    };
    await DBHelper.insert('sync_queue', instanceMap);
    return SyncQueue.syncQueueFromMap(instanceMap);
  }

  static Future<List<SyncQueue>> getSyncQueue() async {
    final List<SyncQueue> syncQueueList = [];
    final isLogin = await AuthToken.isLogin();
    if (isLogin && await isInternetConnected()) {
      final db = await DBHelper.database();
      final List<Map<String, dynamic>> queuedRequests =
          await db.query('sync_queue', where: 'synced = 0');
      print(queuedRequests);

      for (Map<String, dynamic> request in queuedRequests) {
        syncQueueList.add(SyncQueue.syncQueueFromMap(request));
      }
    }
    return syncQueueList;
  }

  static Future<void> processSyncQueue() async {
    final syncQueueList = await getSyncQueue();
    print('syncing');
    for (SyncQueue syncQueue in syncQueueList) {
      if (syncQueue.tableName == 'category') {
        final statusCode =
            await Category.createCategoryAPI(syncQueue.data['title']);
        if (statusCode == 201) {
          syncQueue.sync();
        }
      } else if (syncQueue.tableName == 'note') {
        switch (syncQueue.action) {
          case 'create':
            final statusCode = await Note.createNoteAPI(syncQueue.data);
            if (statusCode == 201) {
              syncQueue.sync();
            }
            break;
          case 'update':
            final statusCode = await Note.updateNoteAPI(syncQueue.data);
            if (statusCode == 200) {
              syncQueue.sync();
            }
            break;
          case 'delete':
            final statusCode = await Note.deleteNoteAPI(syncQueue.data);
            if (statusCode == 204) {
              syncQueue.sync();
            }
            break;
        }
      }
    }
  }
}
