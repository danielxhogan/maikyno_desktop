#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

typedef struct UpdateVideoPlaybackStateParams {
    QString video_id;
    int ts;
    int v_stream;
    int a_stream;
    int s_stream;
    int s_pos;
} UpdateVideoPlaybackStateParams;

class Server : public QObject {
    Q_OBJECT
    Q_PROPERTY( QString ip READ get_ip WRITE set_ip NOTIFY ip_changed)

    Q_PROPERTY( QVariantList libraries
        READ get_libraries NOTIFY libraries_changed);

    Q_PROPERTY( QVariantList shows
        READ get_shows NOTIFY shows_changed);

    Q_PROPERTY( QVariantList media_dirs
        READ get_media_dirs NOTIFY media_dirs_changed);

    Q_PROPERTY( QVariantList videos
        READ get_videos NOTIFY videos_changed);

public:
    explicit Server(QObject *parent = nullptr);
    QString get_ip() const;
    void set_ip(const QString &ip_prop);
    QVariantList get_libraries() const;
    QVariantList get_shows() const;
    QVariantList get_media_dirs() const;
    QVariantList get_videos() const;
    void update_video_playback_state(UpdateVideoPlaybackStateParams *params);

private:
    QString ip;
    QNetworkAccessManager *net_mgr;
    QVariantList libraries;
    QVariantList shows;
    QVariantList media_dirs;
    QVariantList videos;

signals:
    void ip_changed();

    void req_libraries_success();
    void req_libraries_error(QString message);
    void libraries_changed();

    void req_shows_success();
    void req_shows_error(QString message);
    void shows_changed();

    void req_seasons_success();
    void req_seasons_error(QString message);
    void seasons_changed();

    void req_movies_success();
    void req_movies_error(QString message);
    void media_dirs_changed();

    void scan_library_success();
    void scan_library_error(QString message);

    void media_dirs_req_videos_success();
    void media_dirs_req_videos_error(QString message);
    void player_req_videos_success();
    void player_req_videos_error(QString message);
    void videos_changed();

    void save_state_success();
    void save_state_error(QString message);

public slots:
    void req_libraries(const QString &ip);
    void req_library_contents(const QString &library_id,
        const QString &media_type);
    void scan_library(const QString &library_id);
    void req_seasons(const QString &show_id);
    void req_videos(const QString &media_dir_id, const QString &callee);

private slots:
    void on_libraries_result(QNetworkReply *reply);
    void on_shows_result(QNetworkReply *reply);
    void on_seasons_result(QNetworkReply *reply);
    void on_movies_result(QNetworkReply *reply);
    void on_scan_library_result(QNetworkReply *reply);
    void on_media_dirs_videos_result(QNetworkReply *reply);
    void on_player_videos_result(QNetworkReply *reply);
    void on_save_state_result(QNetworkReply *reply);
};
