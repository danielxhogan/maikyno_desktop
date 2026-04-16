#pragma once
#include "../network/Server.h"

#include <QString>
#include <QQuickWindow>

typedef void (*UpdateCallback) (void *ctx);

class PlayerBackend {
public:
    virtual ~PlayerBackend() = default;
    virtual void set_update_callback(UpdateCallback cb, void *ctx) = 0;
    virtual void render(int fbo_id, int width, int height) = 0;
    virtual int render_context_initialized() = 0;

    Server *server;

    QString src = "";
    QString video_id = "";
    int ts = 0;
    int v_stream_idx = 1;
    int a_stream_idx = 1;
    int s_stream_idx = 1;
    int s_pos = 100;

    int pending_src = 0;
    int pending_seek = 1;

    virtual void load_src() = 0;
    virtual void pause_play() = 0;
    virtual void seek(double sec) = 0;
    virtual void seek_start() = 0;
    virtual void next_chapter() = 0;
    virtual void prev_chapter() = 0;

    virtual void prev_v_stream() = 0;
    virtual void next_v_stream() = 0;
    virtual void prev_a_stream() = 0;
    virtual void next_a_stream() = 0;
    virtual void prev_s_stream() = 0;
    virtual void next_s_stream() = 0;

    virtual void sub_pos_up() = 0;
    virtual void sub_pos_down() = 0;

    virtual void save_state() = 0;

signals:
    void state_saved();

protected:
    UpdateCallback update_cb = nullptr;
    void *update_ctx = nullptr;
};
