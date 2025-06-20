cmake_minimum_required(VERSION 3.18.1)

project("audio_engine")

# Oboe
set(OBOE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../../../../oboe)
add_subdirectory(${OBOE_DIR} ./oboe-bin)

# Notre bibliothèque audio
add_library(audio_engine SHARED
    audio_engine.cpp
)

# Liaison avec Oboe et les bibliothèques système
target_link_libraries(audio_engine
    oboe
    log
    android
)

# Optimisations pour les performances
target_compile_options(audio_engine PRIVATE
    -Wall
    -Wextra-semi
    -Wshadow
    -Wshadow-field
    -O3
    -ffast-math
    -DNDEBUG
)
