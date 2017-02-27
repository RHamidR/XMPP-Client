#ifndef IMAGE_PROVIDER_H
#define IMAGE_PROVIDER_H

#include <QImage>
#include <QtQuick/QQuickImageProvider>

class ImageProvider : public QQuickImageProvider
{

    public:
        explicit ImageProvider();
        void clearImages();

        void addImage (const QImage& image, const QString& id);
        QImage requestImage (const QString& id, QSize *size,
                             const QSize& requestedSize);

    private:

        QList<QString> m_id_list;
        QList<QImage> m_image_list;
};

#endif
