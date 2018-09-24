#include <QDebug>
#include "CloudDetector.h"

CloudDetector::CloudDetector(QObject *parent) : QObject(parent)
{

}

QUrl CloudDetector::url() const
{
	return _url;
}

void CloudDetector::setUrl(const QUrl &url)
{
	_url = url;
}

void CloudDetector::submit()
{
	qDebug() << "Submitting" << _url;
}
