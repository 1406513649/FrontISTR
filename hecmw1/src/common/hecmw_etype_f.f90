!======================================================================!
!                                                                      !
!   Software Name : HEC-MW Library for PC-cluster                      !
!         Version : 2.8                                                !
!                                                                      !
!     Last Update : 2007/07/04                                         !
!        Category : I/O and Utility                                    !
!                                                                      !
!            Written by Kazuya Goto (AdvanceSoft)                      !
!                                                                      !
!     Contact address :  IIS,The University of Tokyo RSS21 project     !
!                                                                      !
!     "Structural Analysis System for General-purpose Coupling         !
!      Simulations Using High End Computing Middleware (HEC-MW)"       !
!                                                                      !
!======================================================================!

module hecmw_etype
  use hecmw_util
  implicit none

contains

  function hecmw_get_max_node(etype)
    integer(kind=kint) :: hecmw_get_max_node
    integer(kind=kint) :: etype
    external hecmw_get_max_node_if
    integer(kind=kint) :: hecmw_get_max_node_if

    hecmw_get_max_node = hecmw_get_max_node_if(etype)

  end function hecmw_get_max_node

  function hecmw_is_etype_rod(etype)
    logical :: hecmw_is_etype_rod
    integer(kind=kint) :: etype
    external hecmw_is_etype_rod_if
    integer(kind=kint) :: hecmw_is_etype_rod_if

    if (hecmw_is_etype_rod_if(etype) /= 0) then
      hecmw_is_etype_rod = .true.
    else
      hecmw_is_etype_rod = .false.
    endif
  end function hecmw_is_etype_rod

  function hecmw_is_etype_surface(etype)
    logical :: hecmw_is_etype_surface
    integer(kind=kint) :: etype
    external hecmw_is_etype_surface_if
    integer(kind=kint) :: hecmw_is_etype_surface_if

    if (hecmw_is_etype_surface_if(etype) /= 0) then
      hecmw_is_etype_surface = .true.
    else
      hecmw_is_etype_surface = .false.
    endif
  end function hecmw_is_etype_surface

  function hecmw_is_etype_solid(etype)
    logical :: hecmw_is_etype_solid
    integer(kind=kint) :: etype
    external hecmw_is_etype_solid_if
    integer(kind=kint) :: hecmw_is_etype_solid_if

    if (hecmw_is_etype_solid_if(etype) /= 0) then
      hecmw_is_etype_solid = .true.
    else
      hecmw_is_etype_solid = .false.
    endif
  end function hecmw_is_etype_solid

  function hecmw_is_etype_interface(etype)
    logical :: hecmw_is_etype_interface
    integer(kind=kint) :: etype
    external hecmw_is_etype_interface_if
    integer(kind=kint) :: hecmw_is_etype_interface_if

    if (hecmw_is_etype_interface_if(etype) /= 0) then
      hecmw_is_etype_interface = .true.
    else
      hecmw_is_etype_interface = .false.
    endif
  end function hecmw_is_etype_interface

  function hecmw_is_etype_beam(etype)
    logical :: hecmw_is_etype_beam
    integer(kind=kint) :: etype
    external hecmw_is_etype_beam_if
    integer(kind=kint) :: hecmw_is_etype_beam_if

    if (hecmw_is_etype_beam_if(etype) /= 0) then
      hecmw_is_etype_beam = .true.
    else
      hecmw_is_etype_beam = .false.
    endif
  end function hecmw_is_etype_beam

  function hecmw_is_etype_shell(etype)
    logical :: hecmw_is_etype_shell
    integer(kind=kint) :: etype
    external hecmw_is_etype_shell_if
    integer(kind=kint) :: hecmw_is_etype_shell_if

    if (hecmw_is_etype_shell_if(etype) /= 0) then
      hecmw_is_etype_shell = .true.
    else
      hecmw_is_etype_shell = .false.
    endif
  end function hecmw_is_etype_shell

  function hecmw_is_etype_link(etype)
    logical :: hecmw_is_etype_link
    integer(kind=kint) :: etype
    external hecmw_is_etype_link_if
    integer(kind=kint) :: hecmw_is_etype_link_if

    if (hecmw_is_etype_link_if(etype) /= 0) then
      hecmw_is_etype_link = .true.
    else
      hecmw_is_etype_link = .false.
    endif
  end function hecmw_is_etype_link

  function hecmw_is_etype_33struct(etype)
    logical :: hecmw_is_etype_33struct
    integer(kind=kint) :: etype
    external hecmw_is_etype_33struct_if
    integer(kind=kint) :: hecmw_is_etype_33struct_if

    if (hecmw_is_etype_33struct_if(etype) /= 0) then
      hecmw_is_etype_33struct = .true.
    else
      hecmw_is_etype_33struct = .false.
    endif
  end function hecmw_is_etype_33struct

end module hecmw_etype
