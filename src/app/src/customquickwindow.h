#ifndef CUSTOMQUICKWINDOW_H
#define CUSTOMQUICKWINDOW_H
#include <QQuickWindow>


class customQuickWindow : public QQuickWindow
{
    Q_OBJECT

public:
    customQuickWindow(QWindow *parent = 0);
    //~customQuickWindow();

protected:
    //void keyPressEvent(QKeyEvent*);
    //void resizeEvent(QResizeEvent *Event);


    //void closeEvent(QCloseEvent* event);

};

#endif // CUSTOMQUICKWINDOW_H
