#pragma once

#include "PlayerBackend.h"

extern "C" {
    #include <mkplayer.h>
}

class MkpBackend : public PlayerBackend {
public:
    MkpBackend();
    virtual ~MkpBackend();
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

    virtual void sub_pos_up() override;
    virtual void sub_pos_down() override;

    virtual void save_state() override;

    int render_context_initialized() override;

private:
    MkPlayer *player = nullptr;
};
