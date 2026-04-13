#include "Server.h"

#include <QSettings>
#include <QJsonDocument>
#include <QJsonArray>

Server::Server(QObject *parent) : QObject(parent)
{
    QSettings settings("maikyno", "maikyno");
    ip = settings.value("ip").toString();
    net_mgr = new QNetworkAccessManager(this);
}

QString Server::get_ip() const
{
    return ip;
}

void Server::set_ip(const QString &ip_prop)
{
    if (ip_prop == ip)
        return;
    ip = ip_prop;
    QSettings settings("maikyno", "maikyno");
    settings.setValue("ip", ip);
    emit ip_changed();
}

QVariantList Server::get_libraries() const
{
    return libraries;
}

void Server::req_libraries(const QString &ip)
{
    QUrl url(QString("http://%1:8080/get_libraries").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QNetworkReply *reply = net_mgr->post(request, "{}");
    connect(reply, &QNetworkReply::finished,
        this, [this, reply]() { on_libraries_result(reply);});
}

void Server::on_libraries_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit req_libraries_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        libraries = doc.array().toVariantList();
        emit libraries_changed();
        emit req_libraries_success();
    } else {
        emit req_libraries_error("Invalid data recieved from server.");
    }
}

void Server::req_library_contents(const QString &libary_id,
    const QString &media_type)
{
    if (media_type == "movie") {
        QUrl url(QString("http://%1:8080/get_movies").arg(ip));
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader,
            "application/json");
        QString body = QString("{\"library_id\": \"%1\"}").arg(libary_id);
        QNetworkReply *reply = net_mgr->post(request, body.toUtf8());
        connect(reply, &QNetworkReply::finished,
            this, [this, reply]() { on_movies_result(reply);});
    } else if (media_type == "show") {
        QUrl url(QString("http://%1:8080/get_shows").arg(ip));
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader,
            "application/json");
        QString body = QString("{\"library_id\": \"%1\"}").arg(libary_id);
        QNetworkReply *reply = net_mgr->post(request, body.toUtf8());
        connect(reply, &QNetworkReply::finished,
            this, [this, reply]() { on_shows_result(reply);});
    }
}

QVariantList Server::get_shows() const
{
    return shows;
}

void Server::on_shows_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit req_shows_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        shows = doc.array().toVariantList();
        emit shows_changed();
        emit req_shows_success();
    } else {
        emit req_shows_error("Invalid data recieved from server.");
    }
}

void Server::req_seasons(const QString &show_id)
{
    QUrl url(QString("http://%1:8080/get_seasons").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader,
        "application/json");
    QString body = QString("{\"show_id\": \"%1\"}").arg(show_id);
    QNetworkReply *reply = net_mgr->post(request, body.toUtf8());
    connect(reply, &QNetworkReply::finished,
        this, [this, reply]() { on_seasons_result(reply);});
}

QVariantList Server::get_media_dirs() const
{
    return media_dirs;
}

void Server::on_seasons_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit req_seasons_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        media_dirs = doc.array().toVariantList();
        emit media_dirs_changed();
        emit req_seasons_success();
    } else {
        emit req_seasons_error("Invalid data recieved from server.");
    }
}

void Server::on_movies_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit req_movies_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        media_dirs = doc.array().toVariantList();
        emit media_dirs_changed();
        emit req_movies_success();
    } else {
        emit req_movies_error("Invalid data recieved from server.");
    }
}

QVariantList Server::get_videos() const
{
    return videos;
}

void Server::req_videos(const QString &media_dir_id)
{
    QUrl url(QString("http://%1:8080/get_videos").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString body = QString("{\"media_dir_id\": \"%1\"}").arg(media_dir_id);
    QNetworkReply *reply = net_mgr->post(request, body.toUtf8());
    connect(reply, &QNetworkReply::finished,
        this, [this, reply]() { on_videos_result(reply);});
}

void Server::on_videos_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit req_videos_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        videos = doc.array().toVariantList();
        emit videos_changed();
        emit req_videos_success();
    } else {
        emit req_videos_error("Invalid data recieved from server.");
    }
}
