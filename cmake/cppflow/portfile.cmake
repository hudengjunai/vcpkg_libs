vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO serizba/cppflow
    REF d5abf7b32eb45f4b97ea96e34294d848c1f1198e
    SHA512 e68afa7ba554dc0003211ea6d26fe57d1f16ed8e3a16e39c247aa36bd435ebc5bc69da552d9a19dd19fd09f2768a0bba512dff0a70a926de961dbc53c7b3cd30
    HEAD_REF master
)

file(INSTALL
    "${SOURCE_PATH}/include/cppflow"
    DESTINATION "${CURRENT_PACKAGES_DIR}/include/"
)

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright )

