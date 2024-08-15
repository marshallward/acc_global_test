module loop_mod

use grid_mod, only : grid

implicit none

contains

subroutine loop_with_g(G, field)
  type(grid), intent(in) :: G
  real, intent(inout) :: field(G%ni, G%nj)

  integer :: i, j

  field(:,:) = 0.

  !!! This compiles but  does not work
  !!!$acc kernels

  !!! This works, but copies G on every function call
  !!!$acc enter data copyin(G)
  !!!$acc kernels

  ! This works, if I copy both G and its contents outside of the function
  !$acc kernels present(G)
  do j = 1, G%nj
    do i = 1, G%ni
      field(i,j) = field(i,j) + (i - 1) * (j - 1) * G%Idx(i,j) * G%Idy(i,j)
    enddo
  enddo
  !$acc end kernels
end subroutine loop_with_g


! This more closely resembles the MOM6 case, but does not appear to behave any
! differently than the function above.
subroutine masked_loop_with_g(G, field)
  type(grid), intent(in) :: G
  real, intent(inout) :: field(G%ni, G%nj)

  integer :: i, j
  real :: val

  field(:,:) = 0.

  !!! This alone does not work
  !!!$acc kernels

  !!! This works, but copies G on every function call
  !!!$acc enter data copyin(G)
  !!!$acc kernels

  ! This works, if I copy both G and its contents outside of the function
  !$acc kernels present(G)
  do j = 1, G%nj
    do i = 1, G%ni
      val = field(i,j) + (i - 1) * (j - 1) * G%Idx(i,j) * G%Idy(i,j)
      field(i,j) = val * G%mask(i,j)
    enddo
  enddo
  !$acc end kernels
end subroutine masked_loop_with_g

end module loop_mod
