import 'dart:convert';

import 'package:http/http.dart' as http;

import '../helper/auth_jwt_token_helper.dart';
import '../helper/db_helpers.dart';
import 'category.dart';

class SyncQueue {
  int id;
  String action;
  String tableName;
  Map<String, dynamic>? data;
  bool synced;

  SyncQueue({required this.id,
    required this.action,
    required this.tableName,
    this.data,
    required this.synced});

  static SyncQueue syncQueueFromMap(Map<String, dynamic> map) {
    return SyncQueue(
      id: map['id'],
      action: map['action'],
      tableName: map['table_name'],
      data: map['data'],
      synced: map['synced'] == 1,
    );
  }

  static Future<SyncQueue> queueSyncRequest({required String action,
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

  static Future<void> processSyncQueue() async {
    final token = await AuthToken.accessToken();
    if (token != null) {
      final db = await DBHelper.database();
      final List<Map<String, dynamic>> queuedRequests =
      await db.query('sync_queue', where: 'synced = 0');

      for (Map<String, dynamic> request in queuedRequests) {
        final syncQueue = SyncQueue.syncQueueFromMap(request);
        if (syncQueue.tableName == 'category') {
          final statusCode = Category.
              createCategoryAPI(syncQueue.data!['title']);
          if (statusCode == 201) {
            syncQueue.sync();
          }
        } else if (syncQueue.tableName == 'note') {
          switch (syncQueue.action) {
            case 'create':
              break;
            case 'update':
              break;
            case 'delete':
              break;
          }
        }
      }
    }
  }
}
