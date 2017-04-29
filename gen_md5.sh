#!/bin/bash

IMS_FILES="vendor/lib/lib-ims* vendor/lib/lib-rcs* framework/ims* vendor/lib/lib-dplmedia.so vendor/lib/libvcel.so vendor/lib/libvoice-svc.so etc/permissions/imscm.xml etc/permissions/qti* bin/ims* vendor/app/ims*/*"

md5sum $IMS_FILES > proprietary-ims.txt
