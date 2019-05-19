#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QDebug>
#include <QMainWindow>

namespace Ui {
    class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    ~MainWindow();
    explicit MainWindow(QWidget *parent = 0);

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
