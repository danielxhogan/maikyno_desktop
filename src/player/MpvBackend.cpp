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
        mpv_opengl_init_params gl_init_params[1] = {get_proc_address_mpv, nullptr};
        mpv_render_param params[] {
            {MPV_RENDER_PARAM_API_TYPE, const_cast<char *>(MPV_RENDER_API_TYPE_OPENGL)},
            {MPV_RENDER_PARAM_OPENGL_INIT_PARAMS, &gl_init_params},
            {MPV_RENDER_PARAM_INVALID, nullptr}
        };

        if (mpv_render_context_create(&mpv_render_ctx, mpv, params) < 0)
            throw std::runtime_error("Failed to initalize mpv GL context.");
        mpv_render_context_set_update_callback(mpv_render_ctx, update_cb, update_ctx);

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
    QVariantList loadfile_command;
    loadfile_command.append(loadfile);
    loadfile_command.append(src);
    mpv_utils::command(mpv, loadfile_command);
}

void MpvBackend::pause_play()
{
    QVariantList play_pause_command;
    play_pause_command.append("cycle");
    play_pause_command.append("pause");
    mpv_utils::command(mpv, play_pause_command);
}

void MpvBackend::seek(double sec)
{
    QVariantList seek_command;
    seek_command.append("seek");
    QString sec_str = QString::number(sec);
    seek_command.append(sec_str);
    mpv_utils::command(mpv, seek_command);
}

int MpvBackend::render_context_initialized()
{
    if (mpv_render_ctx)
        return 1;
    return 0;
}
