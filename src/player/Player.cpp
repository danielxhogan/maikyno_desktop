#include "Player.h"
#include "PlayerRenderNode.h"
#include "MpvBackend.h"

#include <QQuickWindow>

Player::Player(QQuickItem *parent) : QQuickItem(parent)
{
    setFlag(ItemHasContents);
    connect(this, &Player::new_frame, this, &QQuickItem::update,
        Qt::QueuedConnection);
    backend = std::make_unique<MpvBackend>();
    backend_type = PLAYER_BACKEND_TYPE_MPV;
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

void Player::set_src(const QString &src_prop)
{
    if (src_prop == backend->src || src_prop.isEmpty())
        return;
    backend->src = src_prop;
    emit src_changed();
    if (backend && backend->render_context_initialized()) {
        backend->load_src();
    } else {
        backend->pending_src = 1;
    }
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
