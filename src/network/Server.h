#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

typedef struct SaveStateParams {
    QString video_id;
    int ts;
    int pct_watched;
    int finished;
    int v_stream;
    int a_stream;
    int s_stream;
    int s_pos;
} SaveStateParams;

class Server : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString ip READ get_ip WRITE set_ip NOTIFY ip_changed)

    Q_PROPERTY(QVariantList libraries
        READ get_libraries NOTIFY libraries_changed);

    Q_PROPERTY(QVariantList collections
        READ get_collections NOTIFY collections_changed);

    Q_PROPERTY(QVariantList shows
        READ get_shows NOTIFY shows_changed);

    Q_PROPERTY(QVariantList collection_shows
        READ get_collection_shows NOTIFY collection_shows_changed);

    Q_PROPERTY(QVariantList media_dirs
        READ get_media_dirs NOTIFY media_dirs_changed);

    Q_PROPERTY(QVariantList collection_movies
        READ get_collection_movies NOTIFY collection_movies_changed);

    Q_PROPERTY(QVariantList videos
        READ get_videos NOTIFY videos_changed);

    Q_PROPERTY(QVariantList video_streams
        READ get_video_streams NOTIFY video_streams_changed);

    Q_PROPERTY(QVariantList process_job_batches
        READ get_process_job_batches NOTIFY process_job_batches_changed);

public:
    explicit Server(QObject *parent = nullptr);
    QString get_ip() const;
    void set_ip(const QString &ip_prop);
    QVariantList get_libraries() const;
    QVariantList get_collections() const;
    QVariantList get_shows() const;
    QVariantList get_collection_shows() const;
    QVariantList get_media_dirs() const;
    QVariantList get_collection_movies() const;
    QVariantList get_videos() const;
    void save_state(SaveStateParams *params);
    QVariantList get_video_streams() const;
    QVariantList get_process_job_batches() const;

    enum LibraryType {
        LIBRARY_TYPE_MOVIE,
        LIBRARY_TYPE_SHOW,
        LIBRARY_TYPE_NONE,
    };
    Q_ENUM(LibraryType);


    enum Callee {
        CALLEE_LIBRARIES,
        CALLEE_SHOWS,
        CALLEE_MEDIA_DIRS,
        CALLEE_VIDEOS,
        CALLEE_PROCESS_JOBS,
        CALLEE_PLAYER,
    };
    Q_ENUM(Callee);

private:
    QString ip;
    QNetworkAccessManager *net_mgr;
    QVariantList libraries;
    QString new_library_id;
    QVariantList library_dirs;
    QVariantList collections;
    QVariantList shows;
    QVariantList collection_shows;
    QVariantList media_dirs;
    QVariantList collection_movies;
    QVariantList videos;
    QVariantList video_streams;
    QVariantList process_job_batches;

signals:
    void ip_changed();

    void req_libraries_success();
    void req_libraries_error(QString message);
    void libraries_changed();

    void create_library_success();
    void create_library_error(QString message);

    void create_library_dir_success();
    void create_library_dir_error(QString message);

    void req_collections_success();
    void req_collections_error(QString message);
    void collections_changed();

    void initial_req_shows_success();
    void initial_req_shows_error(QString message);
    void post_scan_req_shows_success();
    void post_scan_req_shows_error(QString message);
    void shows_changed();

    void req_collection_shows_success();
    void req_collection_shows_error(QString message);
    void collection_shows_changed();

    void req_seasons_success();
    void req_seasons_error(QString message);
    void initial_req_movies_success();
    void initial_req_movies_error(QString message);
    void post_scan_req_movies_success();
    void post_scan_req_movies_error(QString message);
    void media_dirs_changed();

    void req_collection_movies_success();
    void req_collection_movies_error(QString message);
    void collection_movies_changed();

    void scan_library_success();
    void scan_library_error(QString message);
    void videos_scan_library_success();
    void videos_scan_library_error(QString message);

    void media_dirs_req_videos_success();
    void media_dirs_req_videos_error(QString message);
    void videos_req_videos_success();
    void videos_req_videos_error(QString message);
    void player_req_videos_success();
    void player_req_videos_error(QString message);
    void videos_changed();

    void rename_extras_success();
    void rename_extras_error(QString message);

    void save_state_success();
    void save_state_error(QString message);

    void req_video_streams_success();
    void req_video_streams_error(QString message);
    void video_streams_changed();

    void process_media_success();
    void process_media_error(QString message);

    void videos_req_process_jobs_success();
    void videos_req_process_jobs_error(QString message);
    void process_jobs_req_process_jobs_success();
    void process_jobs_req_process_jobs_error(QString message);
    void process_job_batches_changed();

    void abort_batch_success();
    void abort_batch_error(QString message);

public slots:
    enum LibraryType library_type_qstring_to_enum(QString lib_type_qstring);
    void req_libraries();
    void create_library(const QString &library_type,
        const QString &library_name);
    void create_library_dir(const QString &library_id,
        const QString &new_library_dir);
    void req_collections(const QString &library_id);
    void req_library_contents(const QString &library_id,
        LibraryType lib_type, Callee callee);
    void req_collection_shows(const QString &collection_id);
    void req_seasons(const QString &show_id);
    void req_collection_movies(const QString &collection_id);
    void scan_library(const QString &library_id, Callee callee);
    void req_videos(const QString &media_dir_id, Callee callee);
    void rename_extras(const QString &media_dir_id);
    void req_video_streams(const QString &media_dir_id);
    void process_media(const QJsonObject &process_media_info);
    void req_process_jobs(const QString &media_dir_id, Callee callee);
    void abort_batch(const QString &batch_id);

private slots:
    void on_libraries_result(QNetworkReply *reply);
    void on_create_library_result(QNetworkReply *reply);
    void on_create_library_dir_result(QNetworkReply *reply);
    void on_collections_result(QNetworkReply *reply);
    void on_shows_result(QNetworkReply *reply, Callee callee);
    void on_collection_shows_result(QNetworkReply *reply);
    void on_seasons_result(QNetworkReply *reply);
    void on_movies_result(QNetworkReply *reply, Callee callee);
    void on_collection_movies_result(QNetworkReply *reply);
    void on_scan_library_result(QNetworkReply *reply, Callee callee);
    void on_videos_result(QNetworkReply *reply, Callee callee);
    void on_rename_extras_result(QNetworkReply *reply);
    void on_save_state_result(QNetworkReply *reply);
    void on_video_streams_result(QNetworkReply *reply);
    void on_process_media_result(QNetworkReply *reply);
    void on_process_jobs_result(QNetworkReply *reply, Callee callee);
    void on_abort_batch_result(QNetworkReply *reply);
};
