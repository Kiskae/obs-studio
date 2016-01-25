project(portaudio-plugin)
include(ExternalProject)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

find_package(Portaudio REQUIRED)

if(WIN32)
	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
endif(WIN32)

set(portaudio-plugin_HEADERS)

set(portaudio-plugin_SOURCES
	plugin-main.cpp)

add_library(portaudio-plugin MODULE
			${portaudio-plugin_SOURCES}
			${portaudio-plugin_HEADERS})
target_link_libraries(portaudio-plugin libobs ${PortAudio_LIBRARY})
set_target_properties(portaudio-plugin PROPERTIES OUTPUT_NAME "portaudio")