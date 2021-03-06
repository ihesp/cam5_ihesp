#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

module metis_mod
  use kinds, only : real_kind, iulog
  use parallel_mod, only : abortmp
  implicit none
  private 
  integer, parameter :: VertexWeight = 1000
  integer, parameter :: EdgeWeight = 1000

  public  :: genmetispart
  private :: PartitionGraph
  private :: CreateMeshGraph
  private :: PrintMeshGraph
  private :: genLocal2Global
  private :: sort
contains 

  subroutine genmetispart(GridEdge, GridVertex)
    use gridgraph_mod, only : GridVertex_t, GridEdge_t, freegraph, createsubgridgraph, printgridvertex
    use kinds, only : int_kind
    use parallel_mod , only : iam, FrameWeight, PartitionForNodes,&
         PartitionForFrames, FrameCount, numFrames
    use dimensions_mod , only : nmpi_per_node, npart, nnodes, nelem
    use control_mod, only:  partmethod
    use params_mod, only : wrecursive
    
    implicit none

    type (GridVertex_t), intent(inout) :: GridVertex(:)
    type (GridEdge_t),   intent(inout) :: GridEdge(:)

    integer , target, allocatable :: xadj(:),adjncy(:)    ! Adjacency structure for METIS
    integer , target, allocatable :: vwgt(:),adjwgt(:)    ! Weights for the adj struct for METIS

    integer , target, allocatable :: xadj_nl(:),adjncy_nl(:)
    integer , target, allocatable :: vwgt_nl(:),adjwgt_nl(:)

    type (GridVertex_t), allocatable   :: SubVertex(:)

    real(kind=real_kind), allocatable   :: tpwgts(:)
    real(kind=real_kind)                :: tmp

    integer(kind=int_kind), allocatable          :: part(:)
    integer, allocatable          :: part_nl(:),local2global_nl(:)
    integer, allocatable          :: part_fl(:),local2global_fl(:)


    integer, allocatable          :: cnt(:),newnum(:),oldnum(:)

    integer                       :: nelem_edge,numflag,edgecut,wgtflag
    integer                       :: head_part,tail_part
    integer                       :: options(5)
    integer                       :: i,j,ii,ig,in,ip,if
    integer                       :: nelem_nl,nelem_fl,newPartition
    integer                       :: partitionmethod,numpartitions
    integer                       :: nodes_per_frame
    logical , parameter           :: Debug = .true.
    real (kind=real_kind)                 :: dummy(1) 
    nelem_edge = SIZE(GridEdge) 

    print *, "nelem = ", nelem
    print *, "nelem_edge = ", nelem_edge
    allocate(tpwgts(npart))
    allocate(part(nelem))
    allocate(xadj(nelem+1))
    allocate(vwgt(nelem))
    allocate(adjncy(nelem_edge))
    allocate(adjwgt(nelem_edge))

    if(Debug) write(iulog,*)'genmetispart: point #1'
    ! =============================================
    !   Generate Graph for METIS
    ! =============================================
    !DBG  call PrintGridVertex(GridVertex)
    call CreateMeshGraph(GridVertex,xadj,adjncy,adjwgt)
    ! Add weights to all the vertices
    vwgt(:)=VertexWeight
    if(Debug) write(iulog,*)'genmetispart: point #2'

    ! ====================================================
    ! Some cruff from the Weighted partitioning 
    ! experimentation... Remove soon 
    ! ====================================================
    do i=1,npart
       tpwgts(i) = i
    enddo
    tmp = SUM(tpwgts)
    tpwgts = tpwgts/tmp
    if(Debug) write(iulog,*)'genmetispart: point #3'

    !================================================
    !  Setup some options for the METIS partitioning
    !================================================
    options(1) = 0     ! Use Default METIS options
    !  wgtflag    = 1     ! Weights on the Edges only
    wgtflag    = 3     ! Weights on the edges and vertices
    numflag    = 1     ! Use Fortran based numbering

    if(npart > 1) then 

       !     PartitionForFrames=.FALSE.
       if(PartitionForFrames) then 
          numPartitions   = numframes
          PartitionMethod = WRECURSIVE 
       elseif (PartitionForNodes) then 
          numPartitions   = nnodes
          PartitionMethod = partmethod 
       else
          numPartitions   = npart
          PartitionMethod = partmethod 
       endif
       !===========================================
       !  Generate the METIS partitioning
       !===========================================
       if(iam .eq. 1) write(6,100) nelem,PartitionMethod,numPartitions
       if(Debug) write(iulog,*)'genmetispart: point #4'
       if (PartitionMethod==WRECURSIVE) then
          call PartitionGraph(PartitionMethod,nelem,xadj,adjncy, &
               vwgt,adjwgt,wgtflag,numflag, &
               numPartitions,FrameWeight,options,edgecut,part)
       else
          ! FrameWeight has not been allocated in this case, so replace
          ! with dummy argument: 
          call PartitionGraph(PartitionMethod,nelem,xadj,adjncy, &
               vwgt,adjwgt,wgtflag,numflag, &
               numPartitions,dummy,options,edgecut,part)
       endif
       if(Debug) write(iulog,*)'genmetispart: point #5'
       if(PartitionForFrames) then 

          ! =================================================================
          ! Modify the partition array to work with frame based partitioning 
          ! =================================================================
          if(iam .eq. 1) write(iulog,*)'genmetispart: FrameCount is: ',FrameCount

          allocate(cnt(numframes))
          allocate(oldnum(numframes))
          allocate(Newnum(numframes))

          ii = 1
          do i=1,SIZE(FrameCount)
             if(FrameCount(i) .ne. 0) then 
                cnt(ii) = FrameCount(i)
                oldnum(ii) = ii
                ii = ii+1
             endif
          enddo

          if(Debug) write(iulog,*)'genmetispart: point #6'
          call NewPartitionNumber(newnum,oldnum,cnt)
          if(iam .eq. 1) write(iulog,*)'genmetispart: After NewPartitionNumber cnt    : ',cnt
          if(iam .eq. 1) write(iulog,*)'genmetispart: After NewPartitionNumber oldnum : ',oldnum
          if(iam .eq. 1) write(iulog,*)'genmetispart: After NewPartitionNumber newnum : ',newnum

          do ip = 1,nelem
             part(ip)  = NewNum(part(ip))
          enddo

          if(iam .eq. 1) write(iulog,*)'genmetispart: ForFrames: After reassignment  : ',part 

          if(Debug) write(iulog,*)'genmetispart: point #7'
          do if = 1,numframes


             ! =======================================
             !  Figure out the new partitioning number 
             ! =======================================
             newPartition = NewNum(if)

             nelem_fl = COUNT(part .eq. newPartition)

             ! ===================================================
             ! Allocate all the memory for frame level partitioning 
             ! ===================================================

             allocate(local2global_fl(nelem_fl))
             allocate(part_fl(nelem_fl))
             allocate(SubVertex(nelem_fl))
             if(Debug) write(iulog,*)'genmetispart: point #8'

             ! =====================================
             !   Setup the index translation arrays
             ! =====================================
             call genLocal2Global(local2global_fl,part,NewPartition)
             if(Debug) write(iulog,*)'genmetispart: point #9'

             ! ======================================================
             ! Create a set of the Vertices that represent a subgraph 
             ! ======================================================
             call CreateSubGridGraph(GridVertex,SubVertex,local2global_fl)
             if(Debug) write(iulog,*)'genmetispart: point #10'

             ! ==============================
             !  Convert graph to Metis format
             ! ==============================
             call CreateMeshGraph(SubVertex,xadj,adjncy,adjwgt)
             if(Debug) write(iulog,*)'genmetispart: point #11'

             ! =======================
             ! Partition the subgraph 
             ! =======================
             nodes_per_frame = cnt(if)
             if(iam .eq. 1) write(6,100) nelem_fl,partmethod,nodes_per_frame
             if(nodes_per_frame .gt. 1) then 
                call PartitionGraph(partmethod,nelem_fl,xadj,adjncy, &
                     vwgt,adjwgt,wgtflag,numflag, &
                     nodes_per_frame,tpwgts,options,edgecut,part_fl)
             else
                part_fl(:) = 1
             endif
             if(Debug) write(iulog,*)'genmetispart: point #12'

             ! ========================================================= 
             ! Apply the Frame partitioning the the overall partitioning 
             ! ========================================================= 
             do i=1,nelem_fl
                ig = local2global_fl(i)
                part(ig) = part(ig) + (part_fl(i)-1)
             enddo

             ! ======================================
             ! Free up the temporaries that were used
             ! ======================================
             deallocate(local2global_fl)
             deallocate(part_fl)


             call FreeGraph(SubVertex)
             deallocate(SubVertex)

          enddo
          if(Debug) write(iulog,*)'genmetispart: point #13'

          deallocate(newnum)
          deallocate(oldnum)
          deallocate(cnt)

          if(iam .eq. 1) write(iulog,*)'genmetispart: Partitioning after Frame partitioning: ',part
          !JMD call haltmp('genmetispart: After Frame based partitioning:')
       endif
       ! ===============================
       !  Do not partitiion for nodes 
       ! ===============================
       !     PartitionForNodes=.FALSE.
       if(PartitionForNodes)  then 
          ! =========================================
          ! Partition the graph on each compute node 
          ! =========================================
          if(nmpi_per_node .ne. 1 ) then 

             do ip = 1,nelem
                part(ip) = nmpi_per_node*(part(ip)-1) + 1
             enddo

             if(Debug) write(iulog,*)'genmetispart: point #14'

             ! ====================
             ! Loop over each node 
             ! ====================
             do in = 1,nnodes

                newPartition = nmpi_per_node*(in -1) + 1
                nelem_nl = COUNT(part .eq. newPartition)

                ! ===================================================
                ! Allocate all the memory for node level partitioning 
                ! ===================================================

                allocate(local2global_nl(nelem_nl))
                allocate(part_nl(nelem_nl))

                if(Debug) write(iulog,*)'genmetispart: point #15'
                allocate(xadj_nl(nelem_nl+1))
                allocate(vwgt_nl(nelem_nl))
                allocate(adjncy_nl(8*nelem_nl))
                allocate(adjwgt_nl(8*nelem_nl))
                adjncy_nl(:) = 0
                adjwgt_nl(:) = 0
                part_nl(:)   = 0

                if(Debug) write(iulog,*)'genmetispart: point #16'
                !Add vertex weights to the subgraphs
                vwgt_nl(:) = VertexWeight
                allocate(SubVertex(nelem_nl))

                ! =====================================
                !   Setup the index translation arrays
                ! =====================================
                call genLocal2Global(local2global_nl,part,newPartition)

                if(Debug) write(iulog,*)'genmetispart: point #17'
                ! ======================================================
                ! Create a set of the Vertices that represent a subgraph 
                ! ======================================================
                if(Debug) write(iulog,*)'genmetispart: local2global_nl',local2global_nl
                if(Debug) call PrintGridVertex(GridVertex)
                call CreateSubGridGraph(GridVertex,SubVertex,local2global_nl)
                !JMD call CheckGridNeighbors(SubVertex)
                if(Debug) call PrintGridVertex(SubVertex)
                if(Debug) write(iulog,*)'genmetispart: point #18'

                ! ==============================
                !  Convert grep to Metis format
                ! ==============================
                call CreateMeshGraph(SubVertex,xadj_nl,adjncy_nl,adjwgt_nl)

                !debug     call PrintMetisgraph(xadj_nl,adjncy_nl,adjwgt_nl)
                ! =======================
                ! Partition the subgraph 
                ! =======================
                if(iam .eq. 1) write(6,100) nelem_nl,partmethod,nmpi_per_node
                call PartitionGraph(partmethod,nelem_nl,xadj_nl,adjncy_nl, &
                     vwgt_nl,adjwgt_nl,wgtflag,numflag, &
                     nmpi_per_node,tpwgts,options,edgecut,part_nl)
                if(Debug) write(iulog,*)'genmetispart: point #19'

                ! ========================================================= 
                ! Apply the node partitioning the the overall partitioning 
                ! ========================================================= 
                do i=1,nelem_nl
                   ig = local2global_nl(i)
                   part(ig) = part(ig) + (part_nl(i)-1)
                enddo

                ! ======================================
                ! Free up the temporaries that were used
                ! ======================================
                deallocate(local2global_nl)
                deallocate(part_nl)
                deallocate(xadj_nl)
                deallocate(vwgt_nl)
                deallocate(adjncy_nl)
                deallocate(adjwgt_nl)


                if(Debug) write(iulog,*)'genmetispart: point #20'
                call FreeGraph(SubVertex)
                deallocate(SubVertex)
                if(Debug) write(iulog,*)'genmetispart: point #21'

             enddo


          endif  ! if node based partitioning 

       endif   ! if multilevel 

    else   ! else no partitioning needed
       !======================================================================
       ! It appears that Metis will set part(:) = 2 if nnodes == 1, 
       ! which messes stuff up, so set it myself
       !======================================================================
       part(:)=1 
    endif

    if(Debug) write(iulog,*)'genmetispart: point #22'
    ! ===========================================
    !  Add the partitioning information into the 
    !    Grid Vertex and Grid Edge structures
    ! ===========================================

    GridVertex(:)%processor_number = part
    if(Debug) write(iulog,*)'genmetispart: point #23'
    !=================================================
    !  Output the partitioning information 
    !=================================================
#if 0

    write(iulog,*)'Metis Parititioning: '
    write(iulog,*)part

    write(iulog,*)'Metis Parititioning: '
    do k=1,nelem
       write(iulog,*) k,part(k)
    enddo
    call abortmp(' at the end of genmetispart')

    if(OutputFiles) then
       do k=1,nelem
          write(10,*) GridVertex(k)%processor_number
       end do
       close(10)
    end if
#endif

100 format("genmetispart:  Partitioning ",i4," elements, using method: ",i2," into ",i4," pieces")

  end subroutine genmetispart

  subroutine NewPartitionNumber(newnum,oldnum,cnt)

    implicit none

    integer, intent(in)           :: oldnum(:)
    integer, intent(in)           :: cnt(:)
    integer, intent(out)          :: newnum(:)

    integer                       :: i,n

    n = SIZE(cnt)

    newnum(1) = oldnum(1)
    do i=2,n
       newnum(i) = newnum(i-1) + cnt(i-1)
    enddo

  end subroutine NewPartitionNumber

  subroutine genLocal2Global(local2Global,part,newP)

    implicit none 

    integer,intent(inout)      :: local2Global(:)
    integer,intent(in)         :: part(:)
    integer,intent(in)         :: newP

    integer                    :: i,ii,nelem

    nelem = SIZE(part)
    ii = 1
    do i=1,nelem
       if( part(i) .eq. newP) then 
          local2global(ii) = i
          ii = ii + 1
       endif
    enddo

  end subroutine genLocal2Global

  subroutine PartitionGraph(partmethod,nelem,xadj,adjncy,vwgt,adjwgt, &
       wgtflag,numflag,npart,tpwgts,options,edgecut,part)

    implicit none

    integer                               :: partmethod,nelem
    integer                               :: xadj(:),adjncy(:)
    integer                               :: vwgt(:),adjwgt(:)
    integer                               :: wgtflag,numflag,edgecut
    real(kind=real_kind)                  :: tpwgts(:)
    integer                               :: options(5)
    integer                               :: npart
    integer                               :: part(:)


#ifdef _USEMETIS

    if (partmethod .eq. KWAY) then 
       call metis_partgraphkway(nelem,xadj,adjncy, &
            vwgt,adjwgt,wgtflag,numflag,npart,options,edgecut,part)
    else if (partmethod .eq. RECURSIVE) then  
       call METIS_PartGraphRecursive(nelem,xadj,adjncy, &
            vwgt,adjwgt,wgtflag,numflag,npart,options,edgecut,part)
    else if (partmethod .eq. WRECURSIVE) then  
       call METIS_WPartGraphRecursive(nelem,xadj,adjncy, &
            vwgt,adjwgt,wgtflag,numflag,npart,tpwgts,options,edgecut,part)
    else if (partmethod .eq. VOLUME) then  
       call METIS_PartGraphVKway(nelem,xadj,adjncy, &
            vwgt,adjwgt,wgtflag,numflag,npart,options,edgecut,part)
    endif
#endif

  end subroutine PartitionGraph

  subroutine CreateMeshGraph(GridVertex,xadj,adjncy,adjwgt)
    use gridgraph_mod, only : GridVertex_t, num_neighbors
    use kinds, only : real_kind, int_kind
    type (GridVertex_t), intent(in) :: GridVertex(:)
    integer,intent(out)           :: xadj(:),adjncy(:),adjwgt(:)

    integer                         :: i,j,k,ii,jj
    integer                         :: degree,nelem
    !integer(kind=int_kind),allocatable  :: neigh_list(:),sort_indices(:)
    !real(kind=REAL_KIND),allocatable    :: neigh_wgt(:)
    integer(kind=int_kind) :: neigh_list(num_neighbors), &
                              sort_indices(num_neighbors)
    real(kind=REAL_KIND) :: neigh_wgt(num_neighbors)
    integer                         :: max_neigh

    integer :: start, cnt

    nelem = SIZE(GridVertex)

    degree = 0
    ii     = 1

    max_neigh = num_neighbors

    do i=1,nelem
       print *, "i = ", i
       xadj(i)      = ii
       degree = 0
       neigh_list=0


       do j=1,num_neighbors
          cnt = GridVertex(i)%nbrs_ptr(j+1) -  GridVertex(i)%nbrs_ptr(j) 
          start =  GridVertex(i)%nbrs_ptr(j) 
          print *, "j,cnt,start = ", j, cnt, start
          do k=0, cnt-1
             print *, "k,wgt = ", k, GridVertex(i)%nbrs_wgt(start+k)
             if(GridVertex(i)%nbrs_wgt(start+k) .gt. 0) then 
                degree = degree + 1
                !adjncy(ii+degree-1)   = GridVertex(i)%nbrs(start+k)
                neigh_list(degree)    = GridVertex(i)%nbrs(start+k)
                !adjwgt(ii+degree-1)   = GridVertex(i)%nbrs_wgt(start+k)*EdgeWeight
                neigh_wgt(degree)     = GridVertex(i)%nbrs_wgt(start+k)*EdgeWeight
             endif
          enddo
       enddo
       if (degree > max_neigh) call abortmp( "number of neighbors found exceeds expected max")

       call sort(degree,neigh_list,sort_indices)
       !degree       = COUNT(GridVertex(i)%nbrs_wgt(:) .gt. 0) 
       ! Copy the sorted adjncy list in
       do j=1,degree
          adjncy(ii+j-1) = neigh_list(sort_indices(j))
          adjwgt(ii+j-1) = neigh_wgt(sort_indices(j))
       enddo
       print *, "degree = ", degree
       !print *, "wgts = ", GridVertex(i)%nbrs_wgt(:) 
       ii           = ii + degree
    enddo
    xadj(nelem+1)     = ii
    !open(unit=11, file="csr.txt")
    !write(11,*) xadj
    !write(11,*) adjncy
    !write(11,*) adjwgt
    !close(11)

  end subroutine CreateMeshGraph

  subroutine sort(n,list,index)
    use kinds, only : int_kind
    implicit none
    integer, intent(in) :: n
    integer(kind=int_kind), intent(in) :: list(n)
    integer(kind=int_kind), intent(inout) :: index(n)

    ! Local variables
    integer :: i,iloc,nct,ii,lmax,lmin
    logical :: msk(n)
    logical,parameter  :: Debug =.FALSE.

    msk=.TRUE.
    if(Debug) write(iulog,*)'sort: point #1'
    nct=0
    do i=1,n
       if(list(i) .eq. 0) then 
          msk(i)=.FALSE.
       else
          nct = nct + 1
       endif
    enddo
    if(Debug) write(iulog,*)'sort: point #2   list: ',list
    if(Debug) write(iulog,*)'sort: point #2.1 msk: ',msk

    lmax=maxval(list)
    do i=1,nct
       if(Debug) write(iulog,*)'sort: point #3'

       !     pgf90 Rel 3.1-4i:  minloc() with mask is buggy   
       !     iloc = minloc(list,dim=1,mask=msk)
       lmin=lmax
       iloc=-1      
       do ii=1,n
          if (msk(ii) .and. list(ii)<= lmin) iloc=ii
       enddo
       if (iloc==-1) call abortmp( "sort() error")

       index(i)=iloc
       if(Debug) write(iulog,*)'sort: point #4'
       msk(iloc)=.FALSE.
       if(Debug) write(iulog,*)'sort: point #5'
       if(Debug) write(iulog,*)'sort: i, msk',i,msk
    enddo
    if(Debug) write(iulog,*)'sort: point #6'
    !DBG   write(iulog,*)'sort: list is:',list
    !DBG   write(iulog,*)'sort: index is:',index
    !DBG   stop

  end subroutine sort
  !------------------------------------------------------------------------
  subroutine PrintMeshGraph(xadj,adjncy,adjwgt)
    integer, intent(in)       :: xadj(:),adjncy(:),adjwgt(:)
    integer  :: nelem,nadj,i,j

    nelem = SIZE(xadj)

    do i=1,nelem
       write(iulog,*)'xadj(i):= ',xadj(i)
    enddo
    nadj = xadj(nelem)
    do j=1,nadj-1
       write(iulog,*)'{adjncy(i),adjwgt(i)}:=',adjncy(j),adjwgt(j)
    enddo

  end subroutine PrintMeshGraph
  !------------------------------------------------------------------------
end module metis_mod
