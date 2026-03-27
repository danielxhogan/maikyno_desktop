#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class Server : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString ip READ get_ip WRITE set_ip NOTIFY ip_changed)
    Q_PROPERTY(QVariantList libraries
        READ get_libraries NOTIFY libraries_changed);
    Q_PROPERTY(QVariantList media_dirs
        READ get_media_dirs NOTIFY media_dirs_changed);

public:
    explicit Server(QObject *parent = nullptr);
    QString get_ip() const;
    void set_ip(const QString &ip_prop);
    QVariantList get_libraries() const;
    QVariantList get_media_dirs() const;

private:
    QString ip;
    QNetworkAccessManager *net_mgr;
    QVariantList libraries;
    QVariantList media_dirs;

signals:
    void ip_changed();

    void req_libraries_success();
    void req_libraries_error(QString message);
    void libraries_changed();

    void req_movies_success();
    void req_movies_error(QString message);
    void req_shows_success();
    void req_shows_error(QString message);
    void media_dirs_changed();

public slots:
    void req_libraries(const QString &ip);
    void req_library_contents(const QString &library_id,
        const QString &media_type);

private slots:
    void on_libraries_result(QNetworkReply *reply);
    void on_movies_result(QNetworkReply *reply);
};
