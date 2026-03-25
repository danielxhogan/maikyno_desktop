#pragma once

#include <QString>

typedef void (*UpdateCallback) (void *ctx);

class PlayerBackend {
public:
    virtual ~PlayerBackend() = default;
    virtual void set_update_callback(UpdateCallback cb, void *ctx) = 0;
    virtual void render(int fbo_id, int width, int height) = 0;
    virtual int render_context_initialized() = 0;

    QString src = "";
    int pending_src = 0;
    virtual void load_src() = 0;
    virtual void pause_play() = 0;
    virtual void seek(double sec) = 0;

protected:
    UpdateCallback update_cb = nullptr;
    void *update_ctx = nullptr;
};
