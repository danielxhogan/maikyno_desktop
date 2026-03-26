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
        this, [this, reply]() { on_result(reply);});
}

void Server::on_result(QNetworkReply *reply)
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
        emit req_libraries_sucess();
    } else {
        emit req_libraries_error("Invalid data recieved from server.");
    }
}
