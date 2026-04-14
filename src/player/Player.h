#pragma once

#include "PlayerBackend.h"
#include "network/Server.h"

#include <QQuickItem>
#include <QSGNode>

class Player : public QQuickItem {
    Q_OBJECT
    Q_PROPERTY(QString src
        READ get_src WRITE set_src NOTIFY src_changed);

    Q_PROPERTY(QString video_id
        READ get_video_id WRITE set_video_id NOTIFY video_id_changed);

    Q_PROPERTY(int ts
        READ get_ts WRITE set_ts NOTIFY ts_changed);

    Q_PROPERTY(int v_stream_idx
        READ get_v_stream_idx WRITE set_v_stream_idx
        NOTIFY v_stream_idx_changed);

    Q_PROPERTY(int a_stream_idx
        READ get_a_stream_idx WRITE set_a_stream_idx
        NOTIFY a_stream_idx_changed);

    Q_PROPERTY(int s_stream_idx
        READ get_s_stream_idx WRITE set_s_stream_idx
        NOTIFY s_stream_idx_changed);

    Q_PROPERTY(int s_pos
        READ get_s_pos WRITE set_s_pos
        NOTIFY s_pos_changed);

public:
    explicit Player(QQuickItem *parent = nullptr);
    virtual ~Player() = default;

    enum PlayerBackendType {
        PLAYER_BACKEND_TYPE_MPV,
        PLAYER_BACKEND_TYPE_MKP,
        PLAYER_BACKEND_TYPE_NONE
    };
    Q_ENUM(PlayerBackendType)

    QString get_src() const;
    void set_src(const QString &src_prop);
    QString get_video_id() const;
    void set_video_id(const QString &src_prop);
    int get_ts() const;
    void set_ts(int set_ts_prop);
    int get_v_stream_idx() const;
    void set_v_stream_idx(int set_v_stream_idx_prop);
    int get_a_stream_idx() const;
    void set_a_stream_idx(int set_a_stream_idx_prop);
    int get_s_stream_idx() const;
    void set_s_stream_idx(int set_s_stream_idx_prop);
    int get_s_pos() const;
    void set_s_pos(int set_s_pos_prop);

private:
    std::unique_ptr<PlayerBackend> backend;
    PlayerBackendType backend_type = PLAYER_BACKEND_TYPE_NONE;
    static void on_update(void *ctx);

signals:
    void new_frame();
    void player_backend_changed();
    void src_changed();
    void video_id_changed();
    void ts_changed();
    void v_stream_idx_changed();
    void a_stream_idx_changed();
    void s_stream_idx_changed();
    void s_pos_changed();

public slots:
    void pause_play();
    void seek(double sec);
    void seek_start();
    void prev_chapter();
    void next_chapter();

    void prev_v_stream();
    void next_v_stream();
    void prev_a_stream();
    void next_a_stream();
    void prev_s_stream();
    void next_s_stream();

    void sub_pos_up();
    void sub_pos_down();

    void save_state();

protected:
    QSGNode *updatePaintNode(QSGNode             *old_node,
                             UpdatePaintNodeData *update_paint_node_data) override;
};
