#pragma once

#include <QObject>

class Config : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString ip READ get_ip WRITE set_ip NOTIFY ip_changed)

public:
    Config();
    void set_ip(const QString &ip_prop);
    QString get_ip() const;

private:
    QString ip;

signals:
    void ip_changed();
};
