#pragma once

#include <QQuickItem>

class Config : public QQuickItem {
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
