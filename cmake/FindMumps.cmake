###############################################################################
# Copyright (c) 2016 The University of Tokyo
# This software is released under the MIT License, see License.txt
###############################################################################

# Variables:
#
# env MUMPS_ROOT
# MUMPS_FOUND
# MUMPS_INCLUDE_PATH
# MUMPS_LIBRARIES
#
set(LIB_SEARCH_PATH
  $ENV{MUMPS_ROOT}
  ${CMAKE_SOURCE_DIR}/../MUMPS_5.0.1/lib
  $ENV{HOME}/local/lib
  $ENV{HOME}/.local/lib
  /usr/local/lib
  /usr/lib
)

find_library(MUMPS_D_LIB
  NAMES dmumps
  PATHS ${LIB_SEARCH_PATH} NO_DEFAULT_PATH
)
find_library(MUMPS_COMMON_LIB
  NAMES mumps_common
  PATHS ${LIB_SEARCH_PATH} NO_DEFAULT_PATH
)
find_library(MUMPS_PORD_LIB
  NAMES pord
  PATHS ${LIB_SEARCH_PATH} NO_DEFAULT_PATH
)
find_path(MUMPS_INCLUDE_PATH
  NAMES mumps_compat.h
  PATHS $ENV{MUMPS_ROOT}
    ${CMAKE_SOURCE_DIR}/../MUMPS_5.0.1/include
    $ENV{HOME}/local/include
    $ENV{HOME}/.local/include
    /usr/local/include
    /usr/include
    NO_DEFAULT_PATH
)
if(MUMPS_D_LIB AND MUMPS_COMMON_LIB AND MUMPS_PORD_LIB AND MUMPS_INCLUDE_PATH)
  set(MUMPS_LIBRARIES ${MUMPS_D_LIB} ${MUMPS_COMMON_LIB} ${MUMPS_PORD_LIB} ${SCALAPACK_LIBRARIES} ${BLAS_LIBRARIES} ${METIS_LIBRARIES})
  set(MUMPS_FOUND ON)
else()
  set(MUMPS_D_LIB "MUMPS_D_LIB-NOTFOUND" CACHE FILEPATH "libdmumps")
  set(MUMPS_COMMON_LIB "MUMPS_COMMON_LIB-NOTFOUND" CACHE FILEPATH "libmumps_common")
  set(MUMPS_PORD_LIB "MUMPS_PORD_LIB-NOTFOUND" CACHE FILEPATH "libpord")
  set(MUMPS_INCLUDE_PATH "MUMPS_INCLUDE_PATH-NOTFOUND" CACHE FILEPATH "mumps include directory")
  set(MUMPS_FOUND OFF)
endif()
