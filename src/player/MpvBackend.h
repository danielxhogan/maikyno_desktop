#pragma once

#include "PlayerBackend.h"

#include <mpv/client.h>
#include <mpv/render_gl.h>

class MpvBackend : public PlayerBackend {
public:
    MpvBackend();
    virtual ~MpvBackend();
    virtual void set_update_callback(UpdateCallback cb, void *ctx) override;
    virtual void render(int fbo_id, int width, int height) override;

    virtual void play_file(const QString &url) override;
    virtual void pause_play() override;
    virtual void seek(double sec) override;

    int render_context_initialized();

private:
    mpv_handle *mpv;
    mpv_render_context *mpv_render_ctx = nullptr;
};
