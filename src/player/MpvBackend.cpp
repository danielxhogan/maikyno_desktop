#include "MpvBackend.h"
#include "mpv_utils.h"

#include <QOpenGLContext>

static void *get_proc_address_mpv(void *ctx, const char *name)
{
    Q_UNUSED(ctx)

    QOpenGLContext *gl_ctx = QOpenGLContext::currentContext();
    if (!gl_ctx)
        return nullptr;

    return reinterpret_cast<void *>(gl_ctx->getProcAddress(QByteArray(name)));
}

MpvBackend::MpvBackend()
{
    mpv = mpv_create();
    if (!mpv)
        throw std::runtime_error("Failed to create mpv handle.");

    mpv_set_option_string(mpv, "terminal", "yes");
    mpv_set_option_string(mpv, "msg-level", "all=v");
    mpv_set_option_string(mpv, "vo", "libmpv");

    if (mpv_initialize(mpv) < 0)
        throw std::runtime_error("Failed to initialize mpv handle.");
}

MpvBackend::~MpvBackend()
{
    if (mpv_render_ctx)
        mpv_render_context_free(mpv_render_ctx);
    mpv_terminate_destroy(mpv);
}

void MpvBackend::set_update_callback(UpdateCallback cb, void *ctx)
{
    update_cb = cb;
    update_ctx = ctx;
}

void MpvBackend::render(int fbo_id, int width, int height)
{
    if (!mpv_render_ctx) {
        mpv_opengl_init_params gl_init_params[1] = {
            get_proc_address_mpv,
            nullptr
        };
        mpv_render_param params[] {
            {
                MPV_RENDER_PARAM_API_TYPE,
                const_cast<char *>(MPV_RENDER_API_TYPE_OPENGL)
            },
            {MPV_RENDER_PARAM_OPENGL_INIT_PARAMS, &gl_init_params},
            {MPV_RENDER_PARAM_INVALID, nullptr}
        };

        if (mpv_render_context_create(&mpv_render_ctx, mpv, params) < 0)
            throw std::runtime_error("Failed to initalize mpv GL context.");
        mpv_render_context_set_update_callback(mpv_render_ctx,
            update_cb, update_ctx);

        if (pending_src) {
            load_src();
            pending_src = 0;
        }
    }

    mpv_opengl_fbo fbo{
        .fbo = fbo_id,
        .w = width,
        .h = height
    };
    int flip_y{1};

    mpv_render_param params[] = {
        {MPV_RENDER_PARAM_OPENGL_FBO, &fbo},
        {MPV_RENDER_PARAM_FLIP_Y, &flip_y},
        {MPV_RENDER_PARAM_INVALID, nullptr}
    };
    mpv_render_context_render(mpv_render_ctx, params);
}

void MpvBackend::load_src()
{
    if (src.isEmpty())
        return;
    QVariant loadfile = "loadfile";
    QVariantList loadfile_cmd;
    loadfile_cmd.append(loadfile);
    loadfile_cmd.append(src);
    mpv_utils::command(mpv, loadfile_cmd);
}

void MpvBackend::pause_play()
{
    QVariantList play_pause_cmd;
    play_pause_cmd.append("cycle");
    play_pause_cmd.append("pause");
    mpv_utils::command(mpv, play_pause_cmd);
}

void MpvBackend::seek(double sec)
{
    QVariantList seek_cmd;
    seek_cmd.append("seek");
    QString sec_str = QString::number(sec);
    seek_cmd.append(sec_str);
    mpv_utils::command(mpv, seek_cmd);
}

void MpvBackend::seek_start()
{
    QVariantList seek_start_cmd;
    seek_start_cmd.append("seek");
    seek_start_cmd.append("0");
    seek_start_cmd.append("absolute");
    mpv_utils::command(mpv, seek_start_cmd);
}

void MpvBackend::prev_chapter()
{
    QVariantList next_chapter_cmd;
    next_chapter_cmd.append("add");
    next_chapter_cmd.append("chapter");
    next_chapter_cmd.append("-1");
    mpv_utils::command(mpv, next_chapter_cmd);
}

void MpvBackend::next_chapter()
{
    QVariantList next_chapter_cmd;
    next_chapter_cmd.append("add");
    next_chapter_cmd.append("chapter");
    next_chapter_cmd.append("1");
    mpv_utils::command(mpv, next_chapter_cmd);
}

void MpvBackend::prev_v_stream()
{
    QVariantList prev_v_stream_cmd;
    prev_v_stream_cmd.append("cycle");
    prev_v_stream_cmd.append("video");
    prev_v_stream_cmd.append("down");
    mpv_utils::command(mpv, prev_v_stream_cmd);
}

void MpvBackend::next_v_stream()
{
    QVariantList next_v_stream_cmd;
    next_v_stream_cmd.append("cycle");
    next_v_stream_cmd.append("video");
    mpv_utils::command(mpv, next_v_stream_cmd);
}

void MpvBackend::prev_a_stream()
{
    QVariantList prev_a_stream_cmd;
    prev_a_stream_cmd.append("cycle");
    prev_a_stream_cmd.append("audio");
    prev_a_stream_cmd.append("down");
    mpv_utils::command(mpv, prev_a_stream_cmd);
}

void MpvBackend::next_a_stream()
{
    QVariantList next_a_stream_cmd;
    next_a_stream_cmd.append("cycle");
    next_a_stream_cmd.append("audio");
    mpv_utils::command(mpv, next_a_stream_cmd);
}

void MpvBackend::prev_s_stream()
{
    QVariantList prev_s_stream_cmd;
    prev_s_stream_cmd.append("cycle");
    prev_s_stream_cmd.append("sub");
    prev_s_stream_cmd.append("down");
    mpv_utils::command(mpv, prev_s_stream_cmd);
}

void MpvBackend::next_s_stream()
{
    QVariantList next_s_stream_cmd;
    next_s_stream_cmd.append("cycle");
    next_s_stream_cmd.append("sub");
    mpv_utils::command(mpv, next_s_stream_cmd);
}

void MpvBackend::sub_pos_up()
{
    QVariantList sub_pos_up_cmd;
    sub_pos_up_cmd.append("add");
    sub_pos_up_cmd.append("sub-pos");
    sub_pos_up_cmd.append("-1");
    mpv_utils::command(mpv, sub_pos_up_cmd);
}

void MpvBackend::sub_pos_down()
{
    QVariantList sub_pos_down_cmd;
    sub_pos_down_cmd.append("add");
    sub_pos_down_cmd.append("sub-pos");
    sub_pos_down_cmd.append("+1");
    mpv_utils::command(mpv, sub_pos_down_cmd);
}

int MpvBackend::render_context_initialized()
{
    if (mpv_render_ctx)
        return 1;
    return 0;
}
