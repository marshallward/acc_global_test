module grid_mod
implicit none

type :: grid
  integer :: ni
  integer :: nj

  logical, allocatable :: mask(:,:)

  real, allocatable :: Idx(:,:)
  real, allocatable :: Idy(:,:)
end type grid

contains

subroutine create_grid(G, ni, nj)
  type(grid), intent(inout) :: G
  integer, intent(in) :: ni
  integer, intent(in) :: nj

  G%ni = ni
  G%nj = nj

  allocate(G%Idx(ni,nj))
  allocate(G%Idy(ni,nj))

  allocate(G%mask(ni, nj))

  G%Idx(:,:) = 1. / ni
  G%Idy(:,:) = 1. / nj
end subroutine create_grid

end module grid_mod
