#include "customquickwindow.h"

customQuickWindow::customQuickWindow (QWindow *parent)
    : QQuickWindow(parent)
{
    //QQuickWindow asddsa = QQuickWindow()
}
/*void customQuickWindow::keyPressEvent(QKeyEvent * event1)
{
    // don't close on escape

        if(event1->key() == Qt::Key_Escape)
        {
            hide();
            event1->ignore();
            return;
        }

}*/
/*void customQuickWindow::resizeEvent(QResizeEvent *Event)
{
    qDebug((QString::number(size().width())).toLatin1());
    if (Event->ApplicationStateChange == SIZE_MINIMIZED)
    {
        hide();
        Event->ignore();
    }
}
*/
/*
customQuickWindow::~customQuickWindow()
{

}*/
