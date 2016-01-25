#include <string>
#include <obs-module.h>
#include <portaudio.h>

OBS_DECLARE_MODULE()
OBS_MODULE_USE_DEFAULT_LOCALE("portaudio", "en-US")

bool obs_module_load(void) {
	PaError error = Pa_Initialize();
	if (error == paNoError) {
		//NOOP
	} else {
		//log error
		std::string reason = Pa_GetErrorText(error);
		blog(LOG_WARNING, "Error calling Pa_Initialize(): %s", reason.c_str());
	}

	return error == paNoError;
}

void obs_module_unload(void) {
	PaError error = Pa_Terminate();
	if (error != paNoError) {
		std::string reason = Pa_GetErrorText(error);
		blog(LOG_WARNING, "Error calling Pa_Terminate(): %s", reason.c_str());
	}
}