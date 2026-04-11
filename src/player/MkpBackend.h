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

    int render_context_initialized() override;

private:
    MkPlayer *player = nullptr;
};
