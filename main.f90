use grid_mod, only : grid
use loop_mod, only : loop_with_g

implicit none

type(grid) :: G
real, allocatable :: field(:,:)

G%ni = 32
G%nj = 64

allocate(field(G%ni, G%nj))

call loop_with_g(G, field)

print *, sum(field)
end
