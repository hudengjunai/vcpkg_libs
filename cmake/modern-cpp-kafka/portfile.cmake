vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO morganstanley/modern-cpp-kafka
    REF 040d4c2b258ee2d5d7a9ceec90fac781eace7ca9
    SHA512 bfd0984015ce13910f03ddc4abff74d720fa5b93ce37d292d698aa146328bb28e6d8fd20d8aaba9e9d57adaedf305e16aab12ee97e7492231eba4361fc618bc1 
    HEAD_REF master
)

file(INSTALL
    "${SOURCE_PATH}/include/kafka"
    DESTINATION "${CURRENT_PACKAGES_DIR}/include/"
)

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright )

