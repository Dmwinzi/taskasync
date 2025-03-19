package com.example.task_async

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.Locale

class MainActivity: FlutterActivity(){

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        var channelname  = "task_reminder"

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channelname).setMethodCallHandler {
                call, result ->
            when(call.method){
                "schedulereminder" -> {
                    val id = call.argument<Int>("id") ?: return@setMethodCallHandler
                    val title = call.argument<String>("title") ?: return@setMethodCallHandler
                    val dueDate = call.argument<String>("dueDate") ?: return@setMethodCallHandler

                    Log.d("TaskReminder", "Scheduling reminder: $id, $title, $dueDate")

                    val success = schedulereminder(id, title, dueDate)
                    if (success) {
                        result.success("Reminder Scheduled")
                    } else {
                        result.error("ERROR", "Failed to schedule reminder", null)
                    }
                }
            }


        }

    }

    private fun schedulereminder(id: Int, title: String, dueDate: String?): Boolean {
        return try {
            val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS", Locale.getDefault())
            val dueDateMillis = dateFormat.parse(dueDate)?.time ?: return false
//            val currentTimeMillis = System.currentTimeMillis()
//            val triggerTimeMillis = currentTimeMillis + (2 * 60 * 1000)
//            Log.d("Timer", "Scheduling Timer: $triggerTimeMillis")

            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(this, ReminderReceiver::class.java).apply {
                putExtra("title", title)
            }

            val pendingIntent = PendingIntent.getBroadcast(this, id, intent,PendingIntent.FLAG_IMMUTABLE)

            alarmManager.setExact(AlarmManager.RTC_WAKEUP, dueDateMillis, pendingIntent)

            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }




}
