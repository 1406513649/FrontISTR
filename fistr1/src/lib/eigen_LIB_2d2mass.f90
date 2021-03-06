!-------------------------------------------------------------------------------
! Copyright (c) 2016 The University of Tokyo
! This software is released under the MIT License, see LICENSE.txt
!-------------------------------------------------------------------------------
!>  This module contains subroutines used in 2d eigen analysis for elements
!!  232, 242
module m_eigen_LIB_2d2mass
contains

  !----------------------------------------------------------------------*
  subroutine MASS_C2D8(XX,YY,EE,PP,RHO,PARAM1,SS,ISET,fstrEIG)
    !----------------------------------------------------------------------*
    !
    ! CALCULATION 2D 8 NODE PLANE ELEMENT
    !
    use hecmw
    use m_fstr
    use gauss_integration
    implicit none
    ! I/F VARIABLES
    real(kind=kreal)   :: XX(*), YY(*), SS(*), EE, PP, PARAM1
    integer(kind=kint) :: ISET
    ! LOCAL VARIABLES
    integer(kind=kint), parameter :: NN = 8, NDOF = 2, ISIZE = (NN*NDOF)*(NN*NDOF + 1)/2
    integer(kind=kint), parameter :: NG = 3
    !parameter(NN=8, NDOF=2, ISIZE=(NN*NDOF)*(NN*NDOF + 1)/2, NG=3)
    real(kind=kreal)   :: D(4, 4), B(4, NDOF*NN), DB(4, NDOF*NN)
    real(kind=kreal)   :: H(NN), HR(NN), HS(NN)
    real(kind=kreal)   :: RHO, THICK, COEF1, COEF2, PAI
    real(kind=kreal)   :: RI, SI, RP, SP, RM, SM
    real(kind=kreal)   :: XJ11, XJ21, XJ12, XJ22, DET, RR, WG, DUM
    real(kind=kreal)   :: XJI11, XJI21, XJI12, XJI22
    integer(kind=kint) :: I, J, J2, K, LX, LY, NUM
    real(kind=kreal)   :: totdiag, totmass
    integer(kind=kint) :: ind1, ind2
    !REAL(kind=kreal) RX(8),SX(8)
    !DATA RX/-1., 1.,1.,-1., 0., 1., 0., -1./
    !DATA SX/-1.,-1.,1., 1.,-1., 0., 1.,  0./
    type(fstr_eigen) :: fstrEIG

    totdiag = 0.0
    totmass = 0.0
    !*************************
    !  CONSTANT
    !*************************
    PAI=4.0*atan(1.0)
    do I=1,ISIZE
      SS(I)=0.0
    enddo
    ! THICKNESS
    THICK=PARAM1
    !  FOR AX-SYM. ANALYSIS
    if(ISET.EQ.2) then
      THICK=1.0
    end if
    !* LOOP OVER ALL INTEGRATION POINTS
    do LX=1,NG
      RI=XG(NG,LX)
      do LY=1,NG
        SI=XG(NG,LY)
        RP=1.0+RI
        SP=1.0+SI
        RM=1.0-RI
        SM=1.0-SI
        H(1)=0.25*RM*SM*(-1.0-RI-SI)
        H(2)=0.25*RP*SM*(-1.0+RI-SI)
        H(3)=0.25*RP*SP*(-1.0+RI+SI)
        H(4)=0.25*RM*SP*(-1.0-RI+SI)
        H(5)=0.5*(1.0-RI*RI)*(1.0-SI)
        H(6)=0.5*(1.0-SI*SI)*(1.0+RI)
        H(7)=0.5*(1.0-RI*RI)*(1.0+SI)
        H(8)=0.5*(1.0-SI*SI)*(1.0-RI)
        HR(1)=-.25*SM*(-1.0-RI-SI)-0.25*RM*SM
        HR(2)= .25*SM*(-1.0+RI-SI)+0.25*RP*SM
        HR(3)= .25*SP*(-1.0+RI+SI)+0.25*RP*SP
        HR(4)=-.25*SP*(-1.0-RI+SI)-0.25*RM*SP
        HR(5)=-RI*(1.0-SI)
        HR(6)= 0.5*(1.0-SI*SI)
        HR(7)=-RI*(1.0+SI)
        HR(8)=-0.5*(1.0-SI*SI)
        HS(1)=-.25*RM*(-1.0-RI-SI)-0.25*RM*SM
        HS(2)=-.25*RP*(-1.0+RI-SI)-0.25*RP*SM
        HS(3)= .25*RP*(-1.0+RI+SI)+0.25*RP*SP
        HS(4)= .25*RM*(-1.0-RI+SI)+0.25*RM*SP
        HS(5)=-0.5*(1.0-RI*RI)
        HS(6)=-SI *(1.0+RI)
        HS(7)= 0.5*(1.0-RI*RI)
        HS(8)= -SI*(1.0-RI)
        XJ11=0.0
        XJ21=0.0
        XJ12=0.0
        XJ22=0.0
        do I=1,NN
          XJ11=XJ11+HR(I)*XX(I)
          XJ21=XJ21+HS(I)*XX(I)
          XJ12=XJ12+HR(I)*YY(I)
          XJ22=XJ22+HS(I)*YY(I)
        enddo
        DET=XJ11*XJ22-XJ21*XJ12
        if(ISET.EQ.2) then
          RR=0.0
          do I=1,NN
            RR=RR+H(I)*XX(I)
          enddo
          WG=WGT(NG,LX)*WGT(NG,LY)*DET*RR*2.0*PAI
        else
          RR=THICK
          WG=WGT(NG,LX)*WGT(NG,LY)*DET*RR
        end if

        ind1 = 1
        do J=1,NN*NDOF
          ind2 = 1
          do J2=1,J
            NUM=(J-1)*J/2+J2
            !DEBUG
            !               IF(fstrEIG%mastyp.EQ.2) THEN
            !                IF(MOD(j,ndof).EQ.MOD(j2,ndof)) THEN
            !                 SS(NUM)=SS(NUM)+H(ind2)*H(ind1)*WG*RHO
            !!*EHM CONSISTENT MASS MATRIX 22 Apr 2004: Uncomment for debug
            !!                 sstest(j,j2) = SS(NUM)
            !                 ENDIF
            !               ELSE IF(fstrEIG%mastyp.EQ.1) THEN
            if(j.EQ.j2) then
              SS(NUM)=SS(NUM)+H(ind1)*H(ind2)*WG*RHO
              totdiag=totdiag+H(ind1)*H(ind2)*WG*RHO
            endif
            if(mod(j2,ndof).EQ.mod(j,ndof)) then
              totmass=totmass+H(ind1)*H(ind2)*WG*RHO
            endif
            !               ENDIF
            if(mod(J2,NDOF).EQ.0) ind2 = ind2 + 1
          enddo
          if(mod(J,NDOF).EQ.0) ind1 = ind1 + 1
        enddo


      enddo
    enddo
    !DEBUG
    !      IF(fstrEIG%mastyp.EQ.1) THEN
    do j = 1,nn*ndof
      num = j*(j+1)/2
      ss(num) = ss(num)*(2*totmass-totdiag)/(totdiag)
    end do
    if(2*totmass-totdiag .LT. 0) stop "Mass error 232!"
    !      ENDIF

    return
  end subroutine MASS_C2D8
  !----------------------------------------------------------------------*
  subroutine MASS_C2D6(XX,YY,EE,PP,RHO,PARAM1,SS,ISET,fstrEIG)
    !----------------------------------------------------------------------*
    !
    ! CALCULATION 2D 6 NODE PLANE ELEMENT
    !
    use hecmw
    use m_fstr
    use gauss_integration
    implicit none
    ! I/F VARIABLES
    real(kind=kreal)   :: XX(*), YY(*), SS(*), EE, PP, PARAM1
    integer(kind=kint) :: ISET
    ! LOCAL VARIABLES
    integer(kind=kint), parameter :: NN = 6, NDOF = 2, ISIZE = (NN*NDOF)*(NN*NDOF + 1)/2
    integer(kind=kint), parameter :: NG = 3
    !parameter(NN=6, NDOF=2, ISIZE=(NN*NDOF)*(NN*NDOF + 1)/2, NG=3)
    real(kind=kreal)   :: D(4, 4), B(4, NDOF*NN), DB(4, NDOF*NN)
    real(kind=kreal)   :: H(NN), HL1(NN), HL2(NN), HL3(NN)
    integer(kind=kint) :: L1, L2
    real(kind=kreal)   :: X1, X2, X3, XL1, XL2
    real(kind=kreal)   :: DNDX, DNDY
    real(kind=kreal)   :: RHO, THICK, COEF1, COEF2, PAI
    real(kind=kreal)   :: RI, SI, RP, SP, RM, SM
    real(kind=kreal)   :: XJ11, XJ21, XJ12, XJ22, DET, RR, WG, DUM
    real(kind=kreal)   :: XJI11, XJI21, XJI12, XJI22
    integer(kind=kint) :: I, J, J2, K, NUM
    real(kind=kreal)   :: totdiag, totmass
    integer(kind=kint) :: ind1, ind2
    type(fstr_eigen)   :: fstrEIG
    totdiag = 0.0
    totmass = 0.0
    !*************************
    !  CONSTANT
    !*************************
    PAI=4.0*atan(1.0)
    do I=1,ISIZE
      SS(I)=0.0
    enddo
    ! THICKNESS
    THICK=PARAM1
    !  FOR AX-SYM. ANALYSIS
    if(ISET.EQ.2) then
      THICK=1.0
    end if
    !* LOOP OVER ALL INTEGRATION POINTS
    do L2=1,NG
      XL2=XG(NG,L2)
      X2 =(XL2+1.0)*0.5
      do L1=1,NG
        XL1=XG(NG,L1)
        X1=0.5*(1.0-X2)*(XL1+1.0)
        !  INTERPOLATION FUNCTION
        X3=1.0-X1-X2
        H(1)= X1*(2.0*X1-1.)
        H(2)= X2*(2.0*X2-1.)
        H(3)= X3*(2.0*X3-1.)
        H(4)= 4.0*X1*X2
        H(5)= 4.0*X2*X3
        H(6)= 4.0*X1*X3
        !  DERIVATIVE OF INTERPOLATION FUNCTION
        !  FOR L1-COORDINATE
        HL1(1)=4.0*X1-1.0
        HL1(2)= 0.0
        HL1(3)= 0.0
        HL1(4)= 4.0*X2
        HL1(5)= 0.0
        HL1(6)= 4.0*X3
        !  FOR L2-COORDINATE
        HL2(1)= 0.0
        HL2(2)= 4.0*X2-1.0
        HL2(3)= 0.0
        HL2(4)= 4.0*X1
        HL2(5)= 4.0*X3
        HL2(6)= 0.0
        !  FOR L3-COORDINATE
        HL3(1)= 0.0
        HL3(2)= 0.0
        HL3(3)= 4.0*X3-1.0
        HL3(4)= 0.0
        HL3(5)= 4.0*X2
        HL3(6)= 4.0*X1
        !  JACOBI MATRIX
        XJ11=0.0
        XJ21=0.0
        XJ12=0.0
        XJ22=0.0
        do I=1,NN
          XJ11=XJ11+(HL1(I)-HL3(I))*XX(I)
          XJ21=XJ21+(HL2(I)-HL3(I))*XX(I)
          XJ12=XJ12+(HL1(I)-HL3(I))*YY(I)
          XJ22=XJ22+(HL2(I)-HL3(I))*YY(I)
        enddo
        DET=XJ11*XJ22-XJ21*XJ12
        if(ISET.EQ.2) then
          RR=0.0
          do I=1,NN
            RR=RR+H(I)*XX(I)
          enddo
          WG=WGT(NG,L1)*WGT(NG,L2)*DET*RR*2.0*PAI*(1.0-X2)*0.25
        else
          RR=THICK
          WG=WGT(NG,L1)*WGT(NG,L2)*DET*RR*(1.0-X2)*0.25
        end if

        ind1 = 1
        do J=1,NN*NDOF
          ind2 = 1
          do J2=1,J
            NUM=(J-1)*J/2+J2
            !DEBUG
            !               IF(fstrEIG%mastyp.EQ.2) THEN
            !                IF(MOD(j,ndof).EQ.MOD(j2,ndof)) THEN
            !                 SS(NUM)=SS(NUM)+H(ind2)*H(ind1)*WG*RHO
            !!*EHM CONSISTENT MASS MATRIX 22 Apr 2004: Uncomment for debug
            !!                 sstest(j,j2) = SS(NUM)
            !                 ENDIF
            !               ELSE IF(fstrEIG%mastyp.EQ.1) THEN
            if(j.EQ.j2) then
              SS(NUM)=SS(NUM)+H(ind1)*H(ind2)*WG*RHO
              totdiag=totdiag+H(ind1)*H(ind2)*WG*RHO
            endif
            if(mod(j2,ndof).EQ.mod(j,ndof)) then
              totmass=totmass+H(ind1)*H(ind2)*WG*RHO
            endif
            !               ENDIF
            if(mod(J2,NDOF).EQ.0) ind2 = ind2 + 1
          enddo
          if(mod(J,NDOF).EQ.0) ind1 = ind1 + 1
        enddo


      enddo
    enddo

    !DEBUG
    !      IF(fstrEIG%mastyp.EQ.1) THEN
    do j = 1,nn*ndof
      num = j*(j+1)/2
      ss(num) = ss(num)*(2*totmass-totdiag)/(totdiag)
    end do
    if(2*totmass-totdiag .LT. 0) stop "Mass error 242!"
    !      ENDIF

    return
  end subroutine MASS_C2D6

end module m_eigen_LIB_2d2mass
