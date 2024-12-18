FILESEXTRAPATHS:append := "${THISDIR}/${PN}:"

PACKAGECONFIG_CONFARGS = ""

SRC_URI += " \
    file://09-swupdate-args \
    file://swupdate.cfg \
    "

SRC_URI:append:beaglebone-yocto = " file://10-remove-force-ro"

# additional dependencies required to run swupdate on the target
RDEPENDS:${PN} += "u-boot-fw-utils"

do_install:append() {
    install -m 0644 ${UNPACKDIR}/09-swupdate-args ${D}${libdir}/swupdate/conf.d/
    sed -i "s#@MACHINE@#${MACHINE}#g" ${D}${libdir}/swupdate/conf.d/09-swupdate-args

    install -d ${D}${sysconfdir}
    install -m 644 ${UNPACKDIR}/swupdate.cfg ${D}${sysconfdir}
}

do_install:append:beaglebone-yocto() {
    # Recent swupdate as well as libubootenv handles force_ro flags automatically
    if ${@bb.utils.contains('DEPENDS','libubootenv','false','true',d)}; then
        install -m 0644 ${UNPACKDIR}/10-remove-force-ro ${D}${libdir}/swupdate/conf.d/
    fi
}
