import 'package:stacked/stacked.dart';
import 'package:task_async/Domain/Usecases/Reminderserviceusecase.dart';


class Reminderviewmodel extends BaseViewModel {
  final Reminderserviceusecase _reminderserviceusecase;


  Reminderviewmodel(this._reminderserviceusecase);

  Future<bool> scheduleReminder(int id, String title, String dueDate) async {
    setBusy(true);
    try {
      await _reminderserviceusecase.scheduleReminder(id, title, dueDate);
      setBusy(false);
      return true;
    } catch (e) {
      setError(e);
      setBusy(false);
      return false;
    }
  }


}
