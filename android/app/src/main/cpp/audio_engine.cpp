#include <jni.h>
#include <string>
#include <android/log.h>

#define LOG_TAG "AudioEngine"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

// Implémentation simplifiée pour la compilation
extern "C" {

JNIEXPORT jint JNICALL
Java_com_example_audio_1amplifier_MainActivity_startAudio(JNIEnv *env, jobject thiz) {
    LOGI("startAudio called");
    return 0;
}

JNIEXPORT jint JNICALL
Java_com_example_audio_1amplifier_MainActivity_stopAudio(JNIEnv *env, jobject thiz) {
    LOGI("stopAudio called");
    return 0;
}

JNIEXPORT void JNICALL
Java_com_example_audio_1amplifier_MainActivity_setAmplificationLevel(JNIEnv *env, jobject thiz, jfloat level) {
    LOGI("setAmplificationLevel called: %f", level);
}

JNIEXPORT void JNICALL
Java_com_example_audio_1amplifier_MainActivity_setMorphingPosition(JNIEnv *env, jobject thiz, jfloat position) {
    LOGI("setMorphingPosition called: %f", position);
}

JNIEXPORT void JNICALL
Java_com_example_audio_1amplifier_MainActivity_setMixLevel(JNIEnv *env, jobject thiz, jfloat level) {
    LOGI("setMixLevel called: %f", level);
}

JNIEXPORT jfloat JNICALL
Java_com_example_audio_1amplifier_MainActivity_getLatency(JNIEnv *env, jobject thiz) {
    LOGI("getLatency called");
    return 20.0f;
}

// Fonctions C pour l'interface FFI
int start_audio() {
    LOGI("start_audio called");
    return 0;
}

int stop_audio() {
    LOGI("stop_audio called");
    return 0;
}

void set_amplification(float level) {
    LOGI("set_amplification called: %f", level);
}

void set_morphing_position(float position) {
    LOGI("set_morphing_position called: %f", position);
}

void set_mix_level(float level) {
    LOGI("set_mix_level called: %f", level);
}

float get_latency() {
    LOGI("get_latency called");
    return 20.0f;
}

}
