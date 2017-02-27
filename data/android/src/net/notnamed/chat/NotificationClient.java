package net.notnamed.chat;

import android.app.PendingIntent;
import android.content.Intent;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;

public class NotificationClient extends org.qtproject.qt5.android.bindings.QtActivity
{
    private static NotificationManager m_notificationManager;
    private static Notification.Builder m_builder;
    private static NotificationClient m_instance;

    public NotificationClient()
    {
        m_instance = this;
    }

    public static void notify(String s)
    {
        if (m_notificationManager == null) {
            m_notificationManager = (NotificationManager)m_instance.getSystemService(Context.NOTIFICATION_SERVICE);
            m_builder = new Notification.Builder(m_instance);
            m_builder.setSmallIcon(R.drawable.icon);

            Intent intent = new Intent(m_instance, NotificationClient.class);
            PendingIntent pIntent = PendingIntent.getActivity(m_instance, 0, intent, 0);
            m_builder.setContentIntent(pIntent);
            m_builder.addAction(R.drawable.icon, "تماس", pIntent);
            m_builder.addAction(R.drawable.icon, "پیام", pIntent);
        }
        m_builder.setContentTitle("یک پیام از " + s.substring(0,s.indexOf(":")) + " دارید");
        m_builder.setStyle(new Notification.BigTextStyle().bigText(s.substring(s.indexOf(":")+2,s.length())));
        m_builder.setContentText(s);
        m_notificationManager.notify(1, m_builder.build());
    }
}
