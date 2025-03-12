after_install install_latest_haranoajifonts

install_latest_haranoajifonts() {
    local arch=$(find "${TLENV_ROOT}/versions/${VERSION_NAME}/bin/" -type d -maxdepth 1|grep '//'|sed "s,.*/,,")
    local tlpath="${TLENV_ROOT}/versions/${VERSION_NAME}/bin/"${arch}
    local __kpsewhich=${tlpath}/kpsewhich
    local __mktexlsr=${tlpath}/mktexlsr
    local __tlmgr=${tlpath}/tlmgr
    local __updmap_sys=${tlpath}/updmap-sys

    ## install collection-langjapanese
    ${__tlmgr} update --self --all
    ${__tlmgr} install collection-langjapanese

    ## install Harano Aji Fonts
    ${__tlmgr} install --file http://mirror.ctan.org/systems/texlive/tlnet/archive/ptex-fontmaps.tar.xz
    ${__tlmgr} install --file http://mirror.ctan.org/systems/texlive/tlnet/archive/haranoaji.tar.xz
    ${__tlmgr} install --file http://mirror.ctan.org/systems/texlive/tlnet/archive/haranoaji-extra.tar.xz

    ## auto-detect TeX Live VERSION_NAME
    local detected_version_name
    case "$VERSION_NAME" in
        [0-9][0-9][0-9][0-9])
            detected_version_name=${VERSION_NAME}
            ;;
        [0-9][0-9][0-9][0-9]-*)
            detected_version_name=${VERSION_NAME%-*}
            ;;
        *-[0-9][0-9][0-9][0-9])
            detected_version_name=${VERSION_NAME#*-}
            ;;
        [0-9][0-9][0-9][0-9].*)
            detected_version_name=${VERSION_NAME%.*}
            ;;
    esac

    ## set install-tl -force-platform <platform>
    case "${detected_version_name}" in
        199[0-9]|200[0-9]|2010|2011)
            ;;
        201[2-6])
            mkdir -p $(${__kpsewhich} --var-value=TEXMFSYSCONFIG)/web2c/
            printf "%s\n" \
                   "kanjiEmbed haranoaji" \
                   "kanjiVariant " \
                   > $(${__kpsewhich} --var-value=TEXMFSYSCONFIG)/web2c/updmap.cfg && \
                ${__mktexlsr} && \
                ${__updmap_sys}
            ;;
        *)
            mkdir -p $(${__kpsewhich} --var-value=TEXMFSYSCONFIG)/web2c/
            printf "%s\n" \
                   "jaEmbed haranoaji" \
                   "kanjiEmbed haranoaji" \
                   "kanjiVariant " \
                   > $(${__kpsewhich} --var-value=TEXMFSYSCONFIG)/web2c/updmap.cfg && \
                ${__mktexlsr} && \
                ${__updmap_sys}
            ;;
    esac
}
