#include <QUdpSocket>
#include <QTcpSocket>
#include <QTcpServer>

#if QT_VERSION >= QT_VERSION_CHECK(5, 8, 0)
#include <QNetworkDatagram>
#endif

#include <QApplication>

#include "mainwindow.h"

// QApplication::setWindowIcon()
//
// Set the default window icon
// - https://doc.qt.io/qt-5/qapplication.html#windowIcon-prop
//
// QWidget::setWindowIcon()
//
// Set widget's icon, use default window icon if not set
// - https://doc.qt.io/qt-5/qwidget.html#windowIcon-prop

// QWindow::setIcon()
//
// The Application Icon, top-left corner of top-level windows
// - https://doc.qt.io/qt-5/appicon.html

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    //QString appDir = QCoreApplication::applicationDirPath();
    //qDebug() << "appDir=[" + appDir + "]";

    QApplication::setApplicationDisplayName("qt5app");

    // use `qt5_add_resources` convert related resource to C++
    // code, make the ICON file hard-coded into output binary
    QApplication::setWindowIcon(QIcon(":/qt5app.png"));

    MainWindow w;
    w.show();
    return a.exec();
}
