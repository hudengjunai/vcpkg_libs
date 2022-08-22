vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/snappy
     REF 1.1.8
    SHA512 efe18ff1b3edda1b4b6cefcbc6da8119c05d63afdbf7a784f3490353c74dced76baed7b5f1aa34b99899729192b9d657c33c76de4b507a51553fa8001ae75c1c
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSNAPPY_BUILD_TESTS=OFF
        -DSNAPPY_ENABLE_RTTI=ON
        -DSNAPPY_BUILD_BENCHMARKS=OFF
        -DCMAKE_DEBUG_POSTFIX=d
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/Snappy)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
