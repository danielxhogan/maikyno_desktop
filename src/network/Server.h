#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class Server : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString ip READ get_ip WRITE set_ip NOTIFY ip_changed)
    Q_PROPERTY(QVariantList libraries READ get_libraries NOTIFY libraries_changed);

public:
    explicit Server(QObject *parent = nullptr);
    QString get_ip() const;
    void set_ip(const QString &ip_prop);
    QVariantList get_libraries() const;

private:
    QString ip;
    QNetworkAccessManager *net_mgr;
    QVariantList libraries;

signals:
    void ip_changed();
    void req_libraries_sucess();
    void req_libraries_error(QString message);
    void libraries_changed();

public slots:
    void req_libraries(const QString &ip);

private slots:
    void on_result(QNetworkReply *reply);
};
