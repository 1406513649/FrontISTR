###############################################################################
# Copyright (c) 2016 FrontISTR Forum, The University of Tokyo
# This software is released under the MIT License, see License.txt
###############################################################################
cmake_minimum_required(VERSION 2.8.11)

list(APPEND hecmw_SOURCES
  ${CMAKE_CURRENT_LIST_DIR}/my_hecmw_util_f_lag.f90
  ${CMAKE_CURRENT_LIST_DIR}/m_irjc_matrix_lag.f90
  ${CMAKE_CURRENT_LIST_DIR}/m_child_matrix_lag.f90
  ${CMAKE_CURRENT_LIST_DIR}/m_crs_matrix_lag.f90
  ${CMAKE_CURRENT_LIST_DIR}/hecmw_solver_direct_serial_lag.f90
)
