import 'package:firebase_database/firebase_database.dart';
import 'package:plant_management/models/records.dart';

class RecordsApi{
  Future getRecords() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('records');
    ref.onValue.listen((DatabaseEvent event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.exists) {
        final data = dataSnapshot.value;
        if (data is Map) {
          recordsModel.update(data: data.values.toList());
          recordsModel.updateSearch(data: data.values.toList());
          print("RECORDS ${data.values.toList()}");
        } else if (data is List) {
          recordsModel.update(data: data);
          recordsModel.updateSearch(data: data);
        }
      } else {
        recordsModel.update(data: []);
        recordsModel.updateSearch(data: []);
      }
    });
  }
}

