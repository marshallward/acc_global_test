Passing derived types in OpenACC
================================

This is a simple example to try and understand how data is passed across
files and functions in OpenACC.  It is trying to replicate typical call
patterns in MOM6 (and maybe other ocean models).

Hopefully the code itself is simple enough to understand without explanation.


Test cases
----------

1. ``!$acc kernels``, no other directives.

   First try a simply kernel directive::

      !$acc kernels
      do j = 1, G%nj ; do i = 1, G%ni
      ...
      enddo ; enddo
      !$acc end kernels

   This fails::

      FATAL ERROR: variable in data clause is partially present on the device: name=g
       file:/scratch/cimes/mw0089/openacc/acc_global_test/loop.f90 loop_with_g line:22

   "Partially present" is a common error for incompletely copied derived types.


2. Per-call copy of ``G``::

      !$acc enter data copyin(G)
      !$acc kernels
      ...
      !$add end kernels

   This works!  But we don't want to copy every time.


3. Declare ``G`` as present::

      !$acc kernels present(G)
      ...
      !$acc end kernels

   This fails::

      FATAL ERROR: data in PRESENT clause was not found on device 1: name=g host:0x623a10
       file:/scratch/cimes/mw0089/openacc/acc_global_test/loop.f90 loop_with_g line:25

   Does not actually seem accessible to OpenACC tables.


4. Explicitly copy it after creation (in ``main.f90``)::

      call create_grid(G, M, N)
      !$acc enter data copyin(G)

      allocate(field(G%ni, G%nj))
      call loop_with_g(G, field)

   This works with managed memory (``-gpu=managed``).

   But it **fails** with unmanaged memory::

      Failing in Thread:1
      call to cuStreamSynchronize returned error 700: Illegal address during kernel execution

   Seems to lack any info about the internal data.

   AFAIK managed memory automatically copies the contents of allocated data.
   When this actually happens, I am not sure...


5. Explcitly copy the contents of ``G``::

      !$acc enter data copyin(G)
      !$acc enter data copyin(G%Idx)
      !$acc enter data copyin(G%Idy)

   This appears to work.  This might be as much as I can learn from this
   example.


Summary
=======

This was instructional, and perhaps shows the limits of managed memory.

I am unsure if I can or should rely on managed memory.  Given how massive the
MOM6 data structures become, I may not be able to rely on this feature,
especially for very large jobs.

If I learn anything more, then I will continue to add it to this file.
