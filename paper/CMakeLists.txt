list(APPEND THESIS_DEPENDENCIES "")

set(SRC_ROOT_DIR ${PROJECT_SOURCE_DIR}/paper/src)
set(BUILT_IMG_DIR ${SRC_ROOT_DIR}/eps)
set(SVG_DIR ${SRC_ROOT_DIR}/svg)
file(MAKE_DIRECTORY ${BUILT_IMG_DIR})

# Convert SVG files to EPS ones
file(GLOB SVG_FILES "${SVG_DIR}/*.svg")
foreach(file ${SVG_FILES})
    get_filename_component(SVG_FILENAME ${file} NAME_WE)
    set(EPS_FILE ${BUILT_IMG_DIR}/${SVG_FILENAME}.eps)
    message(STATUS "SVG file: " ${SVG_FILENAME})
    message(STATUS "EPS file: " ${EPS_FILE})
    add_custom_command(
        OUTPUT ${EPS_FILE}
        COMMAND inkscape ARGS --without-gui --export-area-page --export-margin=0mm ${file} --export-eps=${EPS_FILE}
        DEPENDS ${file}
    )
    add_custom_target(${SVG_FILENAME}_eps ALL DEPENDS ${EPS_FILE})
    list(APPEND THESIS_DEPENDENCIES ${SVG_FILENAME}_eps)
endforeach()

add_subdirectory(src)
