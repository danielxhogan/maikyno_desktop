#pragma once

#include <QObject>

class Server : public QObject {
    Q_OBJECT

signals:
    void get_libraries_response_sucess();
    void get_libraries_response_error(QString message);

public slots:
    void get_libraries(const QString &ip);
};
