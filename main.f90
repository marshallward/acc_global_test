use grid_mod, only : grid, create_grid
use loop_mod, only : loop_with_g

implicit none

type(grid) :: G
real, allocatable :: field(:,:)

call create_grid(G, 64, 128)

allocate(field(G%ni, G%nj))

call loop_with_g(G, field)

print *, sum(field)
end
