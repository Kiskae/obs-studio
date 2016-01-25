# Set up PORTAUDIO

set(PORTAUDIO_REVISION 1944)
if(WIN32)
	ExternalProject_Add(asiosdk_internal
		URL http://www.steinberg.net/sdk_downloads/asiosdk2.3.zip
		CONFIGURE_COMMAND ""
		BUILD_COMMAND ""
		INSTALL_COMMAND ""
	)

	ExternalProject_Get_Property(asiosdk_internal source_dir)

	ExternalProject_Add(portaudio_internal
		DEPENDS asiosdk_internal
		SVN_REPOSITORY https://subversion.assembla.com/svn/portaudio/portaudio/trunk/
		SVN_REVISION -r${PORTAUDIO_REVISION}
		INSTALL_COMMAND ""
		CMAKE_ARGS -DASIOSDK_PATH_HINT:PATH=${source_dir}
	)
else(WIN32)
	ExternalProject_Add(portaudio_internal
		SVN_REPOSITORY https://subversion.assembla.com/svn/portaudio/portaudio/trunk/
		SVN_REVISION -r${PORTAUDIO_REVISION}
		INSTALL_COMMAND ""
	)
endif(WIN32)

# Copied from portaudio's configuration
IF(CMAKE_CL_64)
	SET(TARGET_POSTFIX x64)
ELSE(CMAKE_CL_64)
	SET(TARGET_POSTFIX x86)
ENDIF(CMAKE_CL_64)

ExternalProject_Get_Property(portaudio_internal binary_dir)
add_library(portaudio STATIC IMPORTED)
if(WIN32)
	set_property(TARGET portaudio PROPERTY IMPORTED_LOCATION_RELEASE "${binary_dir}/Release/portaudio_static_${TARGET_POSTFIX}.lib")
	set_property(TARGET portaudio PROPERTY IMPORTED_LOCATION_DEBUG "${binary_dir}/Debug/portaudio_static_${TARGET_POSTFIX}.lib")
else(WIN32)
	message(FATAL_ERROR "Project not yet configured for non-windows")
endif(WIN32)
add_dependencies(portaudio portaudio_internal) # Ensure portaudio library is built before our project

ExternalProject_Get_Property(portaudio_internal source_dir)
set(PortAudio_INCLUDE_DIR "${source_dir}/include")
set(PortAudio_LIBRARY "portaudio")

set_target_properties(portaudio PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${PortAudio_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)
# Handle the QUIETLY and REQUIRED arguments and set the LM_SENSORS_FOUND to TRUE
# if all listed variables are TRUE
find_package_handle_standard_args(PortAudio DEFAULT_MSG PortAudio_LIBRARY PortAudio_INCLUDE_DIR)

mark_as_advanced(PortAudio_LIBRARY PortAudio_INCLUDE_DIR)