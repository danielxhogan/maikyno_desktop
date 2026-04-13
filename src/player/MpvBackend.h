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

    virtual void load_src() override;
    virtual void pause_play() override;
    virtual void seek(double sec) override;
    virtual void seek_start() override;
    virtual void next_chapter() override;
    virtual void prev_chapter() override;

    virtual void prev_v_stream() override;
    virtual void next_v_stream() override;
    virtual void prev_a_stream() override;
    virtual void next_a_stream() override;
    virtual void prev_s_stream() override;
    virtual void next_s_stream() override;

    int render_context_initialized() override;

private:
    mpv_handle *mpv;
    mpv_render_context *mpv_render_ctx = nullptr;
};
