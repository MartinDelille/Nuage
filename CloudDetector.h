#ifndef CLOUDDETECTOR_H
#define CLOUDDETECTOR_H

#include <QObject>
#include <QUrl>

class CloudDetector : public QObject
{
	Q_OBJECT

	Q_PROPERTY(QUrl url READ url WRITE setUrl)

	QUrl _url;
public:
	explicit CloudDetector(QObject *parent = nullptr);

	QUrl url() const;
	void setUrl(const QUrl &url);

signals:

public slots:

};

#endif // CLOUDDETECTOR_H
