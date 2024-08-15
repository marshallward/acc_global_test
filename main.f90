use grid_mod, only : grid, create_grid
use loop_mod, only : loop_with_g

implicit none

type :: main_cs
    type(grid) :: G
end type main_cs

type(main_cs), target :: CS
type(grid), pointer :: G
real, allocatable :: field(:,:)

call create_grid(CS%G, 64, 128)
allocate(field(CS%G%ni, CS%G%nj))

G => CS%G

! NOTE: Both G and G_in appear to work here
!$acc enter data copyin(CS%G)
!$acc enter data copyin(CS%G%Idx)
!$acc enter data copyin(CS%G%Idy)
call loop_with_g(G, field)

print *, sum(field)
end
