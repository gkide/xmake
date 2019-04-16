#include <QUdpSocket>
#include <QTcpSocket>
#include <QTcpServer>
#include <QNetworkDatagram>

#include <QApplication>

#include "mainwindow.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
