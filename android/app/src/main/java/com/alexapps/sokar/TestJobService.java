package com.alexapps.sukar;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.job.JobParameters;
import android.app.job.JobService;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Build;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.Toast;

import androidx.annotation.RequiresApi;
//import androidx.appcompat.app.AlertDialog;
import androidx.core.app.NotificationCompat;
//import com.ahmed.eldakhakhny.softexpert.bootcomplete.R;

import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;
//import io.flutter.embedding.android.FlutterActivity;

@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
public class TestJobService extends JobService {
    private static final String TAG = "SyncService";
    public static final String CHANNEL_DAKHAKHNY = "channed_dakhakhny";

    private String CHANNEL_ID ="dakhakhny ID";
    @Override
    public boolean onStartJob(JobParameters params) {
        Log.e("TestJobService","onStartJob");
        //startFlutterActivity();
        //Toast.makeText(getApplicationContext(),"Service Toast",Toast.LENGTH_LONG).show();
        createNotificationChannel();
        startActivity(new Intent(this, com.alexapps.sukar.MainActivity.class).addFlags(FLAG_ACTIVITY_NEW_TASK));
        showNotification();
        //createDialog();
        Log.e("TestJobService","your code shall go here");
        // make sure that you return false
        return false;
    }

//    private void startFlutterActivity() {
//        Intent i = FlutterActivity.createDefaultIntent(getBaseContext());
//        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        getBaseContext().startActivity(i);
//    }

    @Override
    public void onCreate() {
        Log.e("TestJobService","onCreate");
        super.onCreate();
    }

    @Override
    public boolean onUnbind(Intent intent) {
        Log.e("TestJobService","onUnbind");
        return super.onUnbind(intent);

    }

    @Override
    public void onRebind(Intent intent) {
        super.onRebind(intent);
        Log.e("TestJobService","onRebind");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.e("TestJobService","onDestroy");
    }

    @Override
    public boolean onStopJob(JobParameters params) {
        Log.e("TestJobService","onStopJob");
        return true;
    }

    private void showNotification() {
        Intent notificationIntent = new Intent(this, com.alexapps.sukar.MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0,
                notificationIntent, 0);

        Log.v("TestJobService","showNotification");
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(R.drawable.app_icon)
                .setContentTitle("سكر")
                .setContentText("اضغط هنا لفتح سكر لحساب الخطوات")
                .setContentIntent(pendingIntent)
                .setPriority(NotificationCompat.PRIORITY_MAX);

        NotificationManager notificationManager= (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.notify(1,builder.build());
    }

    private void createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = CHANNEL_DAKHAKHNY;
            String description = "desc";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription(description);
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

//    private void createDialog(){
//        final WindowManager manager = (WindowManager) getApplicationContext().getSystemService(Context.WINDOW_SERVICE);
//        WindowManager.LayoutParams layoutParams = new WindowManager.LayoutParams();
//        layoutParams.gravity = Gravity.CENTER;
//        layoutParams.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
//        layoutParams.width = WindowManager.LayoutParams.WRAP_CONTENT;
//        layoutParams.height = WindowManager.LayoutParams.WRAP_CONTENT;
//        layoutParams.alpha = 1.0f;
//        layoutParams.packageName = getApplicationContext().getPackageName();
//        layoutParams.buttonBrightness = 1f;
//        layoutParams.windowAnimations = android.R.style.Animation_Dialog;
//
//        final View view = View.inflate(getApplicationContext(),R.layout.dialog, null);
//        Button yesButton = view.findViewById(R.id.yesButton);
//        Button noButton = view.findViewById(R.id.noButton);
//        yesButton.setOnClickListener(v -> manager.removeView(view));
//        noButton.setOnClickListener(v -> manager.removeView(view));
//        manager.addView(view, layoutParams);
//        /*AlertDialog.Builder builder = new AlertDialog.Builder(this);
//        builder.setMessage("R.string.dialog_fire_missiles")
//                .setPositiveButton("R.string.fire", new DialogInterface.OnClickListener() {
//                    public void onClick(DialogInterface dialog, int id) {
//                        // FIRE ZE MISSILES!
//                    }
//                })
//                .setNegativeButton("R.string.cancel", new DialogInterface.OnClickListener() {
//                    public void onClick(DialogInterface dialog, int id) {
//                        // User cancelled the dialog
//                    }
//                });
//        // Create the AlertDialog object and return it
//        builder.create();
//        builder.getContext().getWindow().setType(WindowManager.LayoutParams.TYPE_TOAST);*/
//    }
}