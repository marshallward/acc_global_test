module grid_mod
implicit none

type :: grid
  integer :: ni
  integer :: nj
end type grid

contains

!subroutine create_grid(G, ni, nj)
!  type(grid), intent(inout) :: G
!  integer, intent(in) :: ni
!  integer, intent(in) :: nj
!
!  G%ni = ni
!  G%nj = nj
!end subroutine create_grid

end module grid_mod
