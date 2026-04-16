#include "MkpBackend.h"

#include <QVulkanInstance>
#include <QQuickWindow>

MkpBackend::MkpBackend()
{

}

MkpBackend::~MkpBackend()
{
    mkp_destroy_player(&player);
}

void MkpBackend::set_update_callback(UpdateCallback cb, void *ctx)
{
    update_cb = cb;
    update_ctx = ctx;
}

void MkpBackend::render(int fbo_id, int width, int height)
{
    if (!player) {
        player = mkp_create_player(src.toUtf8().data(),
            v_stream_idx, a_stream_idx, update_cb, update_ctx);
    }

    mkp_render_from_fbo(player, fbo_id, width, height);
}

void MkpBackend::load_src()
{

}

void MkpBackend::pause_play()
{

}

void MkpBackend::seek(double sec)
{

}

void MkpBackend::seek_start()
{

}

void MkpBackend::prev_chapter()
{

}

void MkpBackend::next_chapter()
{

}

void MkpBackend::prev_v_stream()
{

}

void MkpBackend::next_v_stream()
{

}

void MkpBackend::prev_a_stream()
{

}

void MkpBackend::next_a_stream()
{

}

void MkpBackend::prev_s_stream()
{

}

void MkpBackend::next_s_stream()
{

}

void MkpBackend::sub_pos_up()
{

}

void MkpBackend::sub_pos_down()
{

}

int MkpBackend::render_context_initialized()
{
    if (player)
        return 1;
    return 0;
}

void MkpBackend::save_state()
{

}
