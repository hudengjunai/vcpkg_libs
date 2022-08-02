vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO apache/datasketches-cpp
    REF 5c6aa2ba37aca24a9802697c2fa7c117d630dc42 
    SHA512 7b4f8052d459133e4157d5fcb53f75dc64b52059a1ccf7a7ed0b54db7eb5557e26bf201dc64d324ea59d7217e26c524da4b3422756b39386c269b8ce9edf490a 
    HEAD_REF master
)

file(INSTALL
    "${SOURCE_PATH}/common/include/"
    "${SOURCE_PATH}/cpc/include/"
    "${SOURCE_PATH}/fi/include/"
    "${SOURCE_PATH}/hll/include/"
    "${SOURCE_PATH}/kll/include/"
    "${SOURCE_PATH}/req/include/"
    "${SOURCE_PATH}/sampling/include/"
    "${SOURCE_PATH}/theta/include/"
    "${SOURCE_PATH}/tuple/include/"
    DESTINATION "${CURRENT_PACKAGES_DIR}/include/DataSketches"
)

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright )

