# Basic writing and formatting syntax for md editor:
* Link: https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax

# What is the differance between memory and disk.
* Memory and hard disk are two essential components of a computer system. Memory refers to the temporary storage used by a computer to perform its operations, while a hard disk is a permanent storage device used to store data and programs.

# command to check memory usage.
* We can use the following command to store the memory usage in a text file.
  `free -m > memory.txt`
  ### Output:
  ![image](https://github.com/user-attachments/assets/ad0d8751-76f1-431d-b5af-4ec56c817555)

# Checking the memory usage in linux using cat command
```
cat /proc/meminfo
```
### Output:
![image](https://github.com/user-attachments/assets/74c92490-55fa-40c9-8c6f-2a416db614fb)

# How to list the memory in Megabytes rather than kB.
```
awk '$3=="kB"{$2=$2/1024;$3="MB"} 1' /proc/meminfo | column -t
```
#### The above command will display some info like,
* `MemTotal` is the total usable physical memory (RAM).
* `MemFree` is the amount of free, unused RAM.
* `MemAvailable` The amount of memory, available for starting new applications, without swapping.
> Now you may have a question that what is means by Swapmemory.
`Swap memory` also known as swap space, is a section of a computer's hard disk or SSD that the operating system (OS) uses to store inactive data from Random Access Memory (RAM). This allows the OS to run even when RAM is full, preventing system slowdowns or crashes 
* ` note: To know more about MemFree vs MemAvailable ref the following link`
```
 https://stackoverflow.com/questions/30869297/difference-between-memfree-and-memavailable
```
* `Buffers` Buffering is the process of preloading data into a reserved area of memory called buffer memory. Buffer memory is a temporary storage area in the main memory (RAM) that stores data transferring between two or more devices or between an application and a device.
* `Cached` Caching is the process of temporarily storing a copy of a given resource so that subsequent requests to the same resource are processed faster. Cache memory is a fast, static random access memory (SRAM) that a computer chip can access more efficiently than the standard dynamic random access memory (DRAM)
* `SwapCached` The amount of swap space that has been cached in RAM, This metric shows the amount of swap space that is currently kept in memory, which can be quickly accessed if needed.
*  `note: For better understanding of SwapCached ref the following link:`
  ```
  https://www.oreilly.com/library/view/understanding-the-linux/0596002130/ch16s03.html
  ```
* `Active` Memory that is actively being used, Active memory is being actively used by processes and is less likely to be reclaimed or freed for other uses.
* `Inactive` Memory that is not actively used but might be reused if needed, Inactive memory includes pages that have not been used recently. It is available to be repurposed for other applications if necessary.
* `Active(anon)` Active anonymous memory pages (not associated with files), This is a subset of active memory that pertains to pages allocated by processes but not backed by files. Active is the total amount of pages in active LRU lists. Inactive is the total amount of pages in inactive LRU lists. For anonymous pages, Active(anon) and Inactive(anon) are the amount of pages in the active and the inactive list.
* `Inactive(anon)` Inactive anonymous memory pages, This represents anonymous pages that are not actively used but can be repurposed if needed. Inactive is the total amount of pages in inactive LRU (Least Recently Used) lists. For anonymous pages, Active(anon) and Inactive(anon) are the amount of pages in the active and the inactive list.
* `Active(file)` Active memory pages that are associated with files, This includes memory pages that are actively used and are backed by files on disk.
* `Inactive(file)`  Inactive memory pages that are associated with files, Memory pages that are associated with files but are not currently in use.
* `Unevictable` Memory pages that cannot be reclaimed or swapped out, These pages are locked in memory and cannot be moved or swapped out.
* `Mlocked` Memory that has been locked into RAM by the mlock system call, Similar to unevictable memory, this memory is also not eligible for swapping.
*  `SwapTotal` Total swap space available, This is the total amount of swap space configured on the system.
*  `SwapFree` The amount of swap space that is not currently being used, This indicates that all of the configured swap space is free and not in use.
*  `Dirty` Memory pages that have been modified but not yet written to disk, These are pages that have pending writes to disk, representing changes that have not yet been flushed.
*  `Writeback` Memory pages that are currently being written to disk, This shows pages that are in the process of being written back to storage.
*  `AnonPages` Memory used by anonymous pages, which are not backed by files, This memory is used by processes for non-file-backed data.
*  `Mapped` Memory used for mapped files and shared memory, This includes memory that is mapped into the address space of processes.
*  `Shmem` Shared memory used by processes, This represents memory allocated for shared memory segments.
*  `KReclaimable` Kernel memory that can be reclaimed, This memory is used by the kernel but can be freed when necessary.
*  `Slab` Memory used by the kernel for data structures, This memory is used by the kernel to manage various internal data structures and objects.
*  `SReclaimable` Slab memory that can be reclaimed, This is a subset of slab memory that can be freed.
*  `Unreclaim` Slab memory that cannot be reclaimed, This memory is part of the slab cache but cannot be easily reclaimed.
*  `KernelStack` Memory used for kernel stacks, This is the memory allocated for the kernel’s stack space.
*  `PageTables` Memory used for page tables, This is the memory used by the kernel to manage virtual memory and translate virtual addresses to physical addresses.
*  `NFS_Unstable` Memory used for unstable NFS data, This represents data that has been written to NFS but is not yet stable.
*  `Bounce` Memory used for I/O operations requiring temporary buffering, This is used for buffering data during I/O operations to ensure proper transfer.
*  `WritebackTmp` Temporary memory used for write-back operations, This memory is used temporarily while data is being written back to storage.
*  `CommitLimit` The total amount of memory that can be allocated, based on swap space and physical RAM, This is a limit calculated to help prevent the system from running out of memory.
*  `Committed_AS` The total amount of memory that has been committed to applications, including both RAM and swap, This indicates how much memory has been allocated but not necessarily used.
*  `VmallocTotal` The total amount of virtual memory available for vmalloc, vmalloc is a function used to allocate large chunks of virtual memory that is not contiguous in physical memory.
*  `VmallocUsed` The amount of virtual memory that is currently used by vmalloc, This shows the amount of the virtual memory allocated by vmalloc that is currently in use.
*  `VmallocChunk` The size of the largest contiguous chunk of virtual memory, Indicates the largest contiguous chunk of virtual memory that can be allocated.
*  `Percpu` Memory allocated per CPU core, This memory is dedicated to each CPU core for storing per-CPU data.
*  `AnonHugePages` Memory used for anonymous huge pages, Huge pages are large memory pages used to improve performance by reducing the overhead of page table management.
*  `ShmemHugePages` Memory allocated for shared memory huge pages, Shared memory huge pages are large memory pages used for shared memory segments. The value of 0 MB indicates that no huge pages are currently allocated for shared memory.
* `ShmemPmdMapped` The amount of memory mapped using a 2MB Page Map Level 2 (PMD) entry for shared memory, This indicates the memory that is mapped using 2MB pages for shared memory, which can help improve performance by reducing the number of page table entries. The value of 0 MB means that no shared memory is mapped with 2MB pages.
* `FileHugePages Memory allocated for file-backed huge pages, File-backed huge pages are large pages used for file-backed memory mappings. A value of 0 MB indicates that no such pages are currently allocated.
* `FilePmdMapped` The amount of memory mapped using a 2MB Page Map Level 2 (PMD) entry for file-backed memory, This shows the memory that is mapped using 2MB pages for file-backed mappings. The 0 MB value indicates that no file-backed memory is mapped with 2MB pages.
* `HugePages_Total` The total number of huge pages configured on the system, Huge pages are larger than standard memory pages, which can improve performance for certain workloads. The value of 0 means no huge pages are configured.
* `HugePages_Free` The number of huge pages that are currently free and available, This indicates the number of huge pages that are not currently in use. The value of 0 means that no huge pages are free.
* `HugePages_Rsvd` The number of huge pages reserved for use but not yet allocated, This shows the number of huge pages reserved for future use. A value of 0 means no huge pages are reserved.
* `HugePages_Surp` The number of surplus huge pages allocated beyond the requested amount, Surplus huge pages are those allocated above the configured limit. A value of 0 indicates no surplus huge pages.
* `Hugepagesize` The size of each huge page in bytes, Huge pages come in larger sizes than the standard page size (which is typically 4 KB). In this case, each huge page is 2 MB in size. This can help reduce the overhead of managing page tables.
* `Hugetlb` Total amount of memory used for huge pages, including both allocated and free huge pages, This metric shows the total amount of memory used for huge pages. A value of 0 MB indicates that no huge pages are currently in use. 
* `DirectMap4k` Amount of memory mapped using 4 KB pages (standard page size), This shows the amount of memory that is directly mapped using the standard 4 KB page size. Direct mapping allows the kernel to map memory into the address space of the process directly.
* `DirectMap2M` Amount of memory mapped using 2 MB pages, This represents the memory mapped using 2 MB pages. This mapping size is larger than the standard 4 KB page, and is used to reduce the number of page table entries needed for managing large amounts of memory.
* `DirectMap1G` Amount of memory mapped using 1 GB pages, This indicates the memory mapped using 1 GB pages. Large pages like this are useful for applications that require very large amounts of contiguous memory, as they reduce the overhead of managing memory.
### Output:
<img width="758" alt="image" src="https://github.com/user-attachments/assets/13c3b727-2ab8-4891-9ef2-f67bc704e3a8">
