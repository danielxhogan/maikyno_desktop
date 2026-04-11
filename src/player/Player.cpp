#include "Player.h"
#include "PlayerRenderNode.h"

#ifdef USE_MPV
#include "MpvBackend.h"
#endif
#ifdef USE_MKP
#include "MkpBackend.h"
#endif

#include <QQuickWindow>

Player::Player(QQuickItem *parent) : QQuickItem(parent)
{
    setFlag(ItemHasContents);
    connect(this, &Player::new_frame, this, &QQuickItem::update,
        Qt::QueuedConnection);

#ifdef USE_MPV
    backend = std::make_unique<MpvBackend>();
    backend_type = PLAYER_BACKEND_TYPE_MPV;
#endif

#ifdef USE_MKP
    backend = std::make_unique<MkpBackend>();
    backend_type = PLAYER_BACKEND_TYPE_MKP;
#endif

    backend->set_update_callback(on_update, this);
}

void Player::on_update(void *ctx)
{
    Player *player = static_cast<Player *>(ctx);
    emit player->new_frame();
}

QString Player::get_src() const
{
    return backend->src;
}

int Player::get_v_stream_idx() const
{
    return backend->v_stream_idx;
}

int Player::get_a_stream_idx() const
{
    return backend->a_stream_idx;
}

void Player::set_src(const QString &src_prop)
{
    if (src_prop == backend->src || src_prop.isEmpty())
        return;
    backend->src = src_prop;
    emit src_changed();
    if (backend->render_context_initialized()) {
        backend->load_src();
    } else {
        backend->pending_src = 1;
    }
}

void Player::set_v_stream_idx(int v_stream_idx_prop)
{
    if (v_stream_idx_prop == backend->v_stream_idx)
        return;
    backend->v_stream_idx = v_stream_idx_prop;
    emit v_stream_idx_changed();
}

void Player::set_a_stream_idx(int a_stream_idx_prop)
{
    if (a_stream_idx_prop == backend->a_stream_idx)
        return;
    backend->a_stream_idx = a_stream_idx_prop;
    emit a_stream_idx_changed();
}

QSGNode *Player::updatePaintNode(QSGNode             *old_node,
                                 UpdatePaintNodeData *update_paint_node_data)
{
    if (!backend || !window())
        return old_node;

    auto *node = static_cast<PlayerRenderNode *>(old_node);
    if (!node)
        node = new PlayerRenderNode(backend.get());

    QRectF logical_rect = mapRectToScene(boundingRect());
    qreal dpr = window()->devicePixelRatio();
    QRectF rect = boundingRect();
    QRectF physical_rect(
        logical_rect.x() * dpr,
        logical_rect.y() * dpr,
        logical_rect.width() * dpr,
        logical_rect.height() * dpr
    );
    node->set_rect(physical_rect);
    return node;
}

void Player::pause_play()
{
    backend->pause_play();
}

void Player::seek(double sec)
{
    backend->seek(sec);
}
