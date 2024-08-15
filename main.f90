use grid_mod, only : grid, create_grid
use loop_mod, only : loop_with_g

implicit none

type(grid), target :: G_in
type(grid), pointer :: G
real, allocatable :: field(:,:)

call create_grid(G_in, 64, 128)
allocate(field(G_in%ni, G_in%nj))

G => G_in

! NOTE: Both G and G_in appear to work here
!$acc enter data copyin(G_in)
!$acc enter data copyin(G_in%Idx)
!$acc enter data copyin(G_in%Idy)
call loop_with_g(G, field)

print *, sum(field)
end
