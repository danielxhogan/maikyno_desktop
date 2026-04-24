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

enum Server::LibraryType
Server::library_type_qstring_to_enum(QString lib_type_qstring)
{
    if (strcmp(lib_type_qstring.toUtf8().data(), "movie") == 0) {
        return LIBRARY_TYPE_MOVIE;
    } else if (strcmp(lib_type_qstring.toUtf8().data(), "show") == 0) {
        return LIBRARY_TYPE_SHOW;
    } else {
        return LIBRARY_TYPE_NONE;
    }
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
        this, [this, reply]() { on_libraries_result(reply); });
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

QVariantList Server::get_collections() const
{
    return collections;
}

void Server::req_collections(const QString &library_id)
{
    QUrl url(QString("http://%1:8080/get_collections").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString body = QString("{\"library_id\": \"%1\"}").arg(library_id);
    QNetworkReply *reply = net_mgr->post(request, body.toUtf8());
    connect(reply, &QNetworkReply::finished,
        this, [this, reply]() { on_collections_result(reply); });
}

void Server::on_collections_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit req_collections_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        collections = doc.array().toVariantList();
        emit collections_changed();
        emit req_collections_success();
    } else {
        emit req_collections_error("Invalid data recieved from server.");
    }
}

void Server::req_library_contents(const QString &libary_id,
    LibraryType lib_type, Callee callee)
{
    if (lib_type == LIBRARY_TYPE_MOVIE) {
        QUrl url(QString("http://%1:8080/get_movies").arg(ip));
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader,
            "application/json");
        QString body = QString("{\"library_id\": \"%1\"}").arg(libary_id);
        QNetworkReply *reply = net_mgr->post(request, body.toUtf8());

        if (callee == CALLEE_LIBRARIES) {
            connect(reply, &QNetworkReply::finished,
                this, [this, reply]() { on_initial_movies_result(reply); });
        } else if (callee == CALLEE_MEDIA_DIRS) {
            connect(reply, &QNetworkReply::finished,
                this, [this, reply]() { on_post_scan_movies_result(reply); });
        }
    }
    else if (lib_type == LIBRARY_TYPE_SHOW) {
        QUrl url(QString("http://%1:8080/get_shows").arg(ip));
        QNetworkRequest request(url);
        request.setHeader(QNetworkRequest::ContentTypeHeader,
            "application/json");
        QString body = QString("{\"library_id\": \"%1\"}").arg(libary_id);
        QNetworkReply *reply = net_mgr->post(request, body.toUtf8());

        if (callee == CALLEE_LIBRARIES) {
            connect(reply, &QNetworkReply::finished,
                this, [this, reply]() { on_initial_shows_result(reply); });
        } else if (callee == CALLEE_SHOWS) {
            connect(reply, &QNetworkReply::finished,
                this, [this, reply]() { on_post_scan_shows_result(reply); });
        }
    }
}

QVariantList Server::get_shows() const
{
    return shows;
}

void Server::on_initial_shows_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit initial_req_shows_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        shows = doc.array().toVariantList();
        emit shows_changed();
        emit initial_req_shows_success();
    } else {
        emit initial_req_shows_error("Invalid data recieved from server.");
    }
}

void Server::on_post_scan_shows_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit post_scan_req_shows_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        shows = doc.array().toVariantList();
        emit shows_changed();
        emit post_scan_req_shows_success();
    } else {
        emit post_scan_req_shows_error("Invalid data recieved from server.");
    }
}

QVariantList Server::get_collection_shows() const
{
    return collection_shows;
}

void Server::req_collection_shows(const QString &collection_id)
{
    QUrl url(QString("http://%1:8080/get_collection_shows").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString body = QString("{\"collection_id\": \"%1\"}").arg(collection_id);
    QNetworkReply *reply = net_mgr->post(request, body.toUtf8());
    connect(reply, &QNetworkReply::finished,
        this, [this, reply]() { on_collection_shows_result(reply); });
}

void Server::on_collection_shows_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit req_collection_shows_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        collection_shows = doc.array().toVariantList();
        emit collection_shows_changed();
        emit req_collection_shows_success();
    } else {
        emit req_collection_shows_error("Invalid data recieved from server.");
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

void Server::on_initial_movies_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit initial_req_movies_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        media_dirs = doc.array().toVariantList();
        emit media_dirs_changed();
        emit initial_req_movies_success();
    } else {
        emit initial_req_movies_error("Invalid data recieved from server.");
    }
}

void Server::on_post_scan_movies_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit post_scan_req_movies_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        media_dirs = doc.array().toVariantList();
        emit media_dirs_changed();
        emit post_scan_req_movies_success();
    } else {
        emit post_scan_req_movies_error("Invalid data recieved from server.");
    }
}

QVariantList Server::get_collection_movies() const
{
    return collection_movies;
}

void Server::req_collection_movies(const QString &collection_id)
{
    QUrl url(QString("http://%1:8080/get_collection_movies").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString body = QString("{\"collection_id\": \"%1\"}").arg(collection_id);
    QNetworkReply *reply = net_mgr->post(request, body.toUtf8());
    connect(reply, &QNetworkReply::finished,
        this, [this, reply]() { on_collection_movies_result(reply); });
}

void Server::on_collection_movies_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit req_collection_movies_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        collection_movies = doc.array().toVariantList();
        emit collection_movies_changed();
        emit req_collection_movies_success();
    } else {
        emit req_collection_movies_error("Invalid data recieved from server.");
    }
}

void Server::scan_library(const QString &library_id, Callee callee)
{
    QUrl url(QString("http://%1:8080/scan_library").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader,
        "application/json");
    QString body = QString("{\"library_id\": \"%1\"}").arg(library_id);
    QNetworkReply *reply = net_mgr->post(request, body.toUtf8());
    connect(reply, &QNetworkReply::finished,
        this, [this, reply, callee]() { on_scan_library_result(reply, callee);});
}

void Server::on_scan_library_result(QNetworkReply *reply, Callee callee)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        switch (callee) {
        case CALLEE_MEDIA_DIRS:
        case CALLEE_SHOWS:
            emit scan_library_error(reply->errorString());
            break;
        case CALLEE_VIDEOS:
            emit videos_scan_library_error(reply->errorString());
            break;
        default: break;
        }
        return;
    }

    switch (callee) {
    case CALLEE_MEDIA_DIRS:
    case CALLEE_SHOWS:
        emit scan_library_success();
        break;
    case CALLEE_VIDEOS:
        emit videos_scan_library_success();
        break;
    default: break;
    }
}

QVariantList Server::get_videos() const
{
    return videos;
}

void Server::req_videos(const QString &media_dir_id, Callee callee)
{
    QUrl url(QString("http://%1:8080/get_videos").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString body = QString("{\"media_dir_id\": \"%1\"}").arg(media_dir_id);
    QNetworkReply *reply = net_mgr->post(request, body.toUtf8());

    if (callee == CALLEE_MEDIA_DIRS) {
        connect(reply, &QNetworkReply::finished,
            this, [this, reply]() { on_media_dirs_videos_result(reply); });
    } else if (callee == CALLEE_VIDEOS) {
        connect(reply, &QNetworkReply::finished,
            this, [this, reply]() { on_videos_videos_result(reply); });
    } else if (callee == CALLEE_PLAYER) {
        connect(reply, &QNetworkReply::finished,
            this, [this, reply]() { on_player_videos_result(reply); });
    }
}

void Server::on_media_dirs_videos_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit media_dirs_req_videos_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        videos = doc.array().toVariantList();
        emit videos_changed();
        emit media_dirs_req_videos_success();
    } else {
        emit media_dirs_req_videos_error("Invalid data recieved from server.");
    }
}

void Server::on_videos_videos_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit videos_req_videos_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        videos = doc.array().toVariantList();
        emit videos_changed();
        emit videos_req_videos_success();
    } else {
        emit videos_req_videos_error("Invalid data recieved from server.");
    }
}

void Server::on_player_videos_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit player_req_videos_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        videos = doc.array().toVariantList();
        emit videos_changed();
        emit player_req_videos_success();
    } else {
        emit player_req_videos_error("Invalid data recieved from server.");
    }
}

void Server::rename_extras(const QString &media_dir_id)
{
    QUrl url(QString("http://%1:8080/rename_extras").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader,
        "application/json");
    QString body = QString("{\"media_dir_id\": \"%1\"}").arg(media_dir_id);
    QNetworkReply *reply = net_mgr->post(request, body.toUtf8());
    connect(reply, &QNetworkReply::finished,
        this, [this, reply]() { on_rename_extras_result(reply);});
}

void Server::on_rename_extras_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit rename_extras_error(reply->errorString());
        return;
    }
    emit rename_extras_success();
}

void Server::save_state(SaveStateParams *params)
{
    QUrl url(QString("http://%1:8080/save_state").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QString body = QString("{\
        \"video_id\": \"%1\",\
        \"ts\": %2,\
        \"pct_watched\": %3,\
        \"finished\": %4,\
        \"v_stream\": %5,\
        \"a_stream\": %6,\
        \"s_stream\": %7,\
        \"s_pos\": %8}")
        .arg(params->video_id.toUtf8().data())
        .arg(params->ts - 10)
        .arg(params->pct_watched)
        .arg(params->finished)
        .arg(params->v_stream)
        .arg(params->a_stream)
        .arg(params->s_stream)
        .arg(params->s_pos);

    QNetworkReply *reply = net_mgr->post(request, body.toUtf8());
    connect(reply, &QNetworkReply::finished,
        this, [this, reply]() { on_save_state_result(reply); });
}

void Server::on_save_state_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit save_state_error(reply->errorString());
        return;
    }
    emit save_state_success();
}

QVariantList Server::get_video_streams() const
{
    return video_streams;
}

void Server::req_video_streams(const QString &media_dir_id)
{
    QUrl url(QString("http://%1:8080/scan_media_streams").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString body = QString("{\"media_dir_id\": \"%1\"}").arg(media_dir_id);
    QNetworkReply *reply = net_mgr->post(request, body.toUtf8());

    connect(reply, &QNetworkReply::finished,
        this, [this, reply]() { on_video_streams_result(reply); });
}

void Server::on_video_streams_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit req_video_streams_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        video_streams = doc.array().toVariantList();
        emit video_streams_changed();
        emit req_video_streams_success();
    } else {
        emit req_video_streams_error("Invalid data recieved from server.");
    }
}

void Server::process_media(const QJsonObject &process_media_info)
{
    QUrl url(QString("http://%1:8080/process_media").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString body = QJsonDocument(process_media_info)
        .toJson(QJsonDocument::Compact);
    QNetworkReply *reply = net_mgr->post(request, body.toUtf8());

    connect(reply, &QNetworkReply::finished,
        this, [this, reply]() { on_process_media_result(reply); });
}

void Server::on_process_media_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit process_media_error(reply->errorString());
        return;
    }
    emit process_media_success();
}

QVariantList Server::get_process_jobs() const
{
    return process_jobs;
}

void Server::req_process_jobs(const QString &media_dir_id)
{
    QUrl url(QString("http://%1:8080/get_process_jobs").arg(ip));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QString body = QString("{\"media_dir_id\": \"%1\"}").arg(media_dir_id);
    QNetworkReply *reply = net_mgr->post(request, body.toUtf8());

    connect(reply, &QNetworkReply::finished,
        this, [this, reply]() { on_process_jobs_result(reply); });
}

void Server::on_process_jobs_result(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError) {
        emit req_process_jobs_error(reply->errorString());
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (doc.isArray()) {
        process_jobs = doc.array().toVariantList();
        emit process_jobs_changed();
        emit req_process_jobs_success();
    } else {
        emit req_process_jobs_error("Invalid data recieved from server.");
    }
}
