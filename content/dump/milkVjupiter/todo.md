
sudo cp arch/riscv/boot/Image.gz /run/media/opvolger/jupiter/
make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- -j 12
sudo cp arch/riscv/boot/Image.gz /run/media/opvolger/43a5c970-e3b6-4c7c-9ee7-772319ac7485/
sudo cp arch/riscv/boot/dts/spacemit/k1-x_milkv-jupiter.dtb /run/media/opvolger/43a5c970-e3b6-4c7c-9ee7-772319ac7485/

```bash
fdt_addr_r=0x31000000
usb start
load usb 0:1 ${kernel_addr_r} /Image.gz
load usb 0:1 ${fdt_addr_r} /k1-milkv-jupiter.dtb
setenv bootargs 'root=/dev/mmcblk0p1 rw swiotlb=131072 console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0'
booti $kernel_addr_r - $fdt_addr_r
```


```bash
fdt_addr_r=0x31000000
usb start
load usb 0:1 ${kernel_addr_r} /Image.gz
load usb 0:1 ${fdt_addr_r} /k1-x_milkv-jupiter.dtb
setenv bootargs 'root=/dev/mmcblk2p1 rw radeon.pcie_gen_cap=0x10001 radeon.pcie_lane_cap=0x10000 radeon.modeset=1 iommu=pt pcie_aspm=off radeon.dpm=0 radeon.pcie_gen2=0 swiotlb=65536 console=tty0 console=ttyS0,115200 earlycon rootwait selinux=0'
booti $kernel_addr_r - $fdt_addr_r
```

setenv bootargs 'root=/dev/nvme0n1p6 rw radeon.dpm=0 radeon.pcie_gen2=0 swiotlb=65536 console=tty0 console=ttyS0,115200 earlycon rootwait selinux=0'

setenv bootargs 'root=/dev/mmcblk2p1 rw radeon.dpm=0 radeon.pcie_gen2=0 swiotlb=65536 console=tty0 console=ttyS0,115200 earlycon rootwait selinux=0'

setenv bootargs 'root=/dev/mmcblk2p1 rw radeon.si_support=0 radeon.cik_support=0 amdgpu.pcie_gen_cap=0x10001 amdgpu.pcie_lane_cap=0x10000 amdgpu.modeset=1 amdgpu.dpm=0 amdgpu.pcie_gen2=0 swiotlb=65536 console=tty0 console=ttyS0,115200 earlycon rootwait selinux=0'

setenv bootargs 'root=/dev/mmcblk2p1 rw amdgpu.pcie_gen_cap=0x10001 amdgpu.pcie_lane_cap=0x10000 amdgpu.modeset=1 iommu=pt pcie_aspm=off amdgpu.dpm=0 amdgpu.pcie_gen2=0 cma=512M swiotlb=65536 console=tty0 console=ttyS0,115200 earlycon rootwait selinux=0'


```log
[  286.319942] radeon 0002:01:00.0: ring 0 stalled for more than 10296msec
[  286.327411] radeon 0002:01:00.0: GPU lockup (current fence id 0x0000000000002463 last fence id 0x000000000000246d on ring 0)
[  286.346917] radeon 0002:01:00.0: Saved 311 dwords of commands on ring 0.
[  286.353779] radeon 0002:01:00.0: GPU softreset: 0x00000009
[  286.359354] radeon 0002:01:00.0:   GRBM_STATUS               = 0xE4000828
[  286.366267] radeon 0002:01:00.0:   GRBM_STATUS_SE0           = 0xC0000001
[  286.373151] radeon 0002:01:00.0:   GRBM_STATUS_SE1           = 0x00000001
[  286.380014] radeon 0002:01:00.0:   SRBM_STATUS               = 0x200000C0
[  286.386906] radeon 0002:01:00.0:   SRBM_STATUS2              = 0x00000000
[  286.393769] radeon 0002:01:00.0:   R_008674_CP_STALLED_STAT1 = 0x00000000
[  286.400683] radeon 0002:01:00.0:   R_008678_CP_STALLED_STAT2 = 0x00010802
[  286.407591] radeon 0002:01:00.0:   R_00867C_CP_BUSY_STAT     = 0x00028086
[  286.414489] radeon 0002:01:00.0:   R_008680_CP_STAT          = 0x80038647
[  286.421361] radeon 0002:01:00.0:   R_00D034_DMA_STATUS_REG   = 0x44C83D57
[  286.433686] radeon 0002:01:00.0: GRBM_SOFT_RESET=0x00007F6B
[  286.439390] radeon 0002:01:00.0: SRBM_SOFT_RESET=0x00000100
[  286.446194] radeon 0002:01:00.0:   GRBM_STATUS               = 0x00003828
[  286.453081] radeon 0002:01:00.0:   GRBM_STATUS_SE0           = 0x00000007
[  286.459937] radeon 0002:01:00.0:   GRBM_STATUS_SE1           = 0x00000007
[  286.466822] radeon 0002:01:00.0:   SRBM_STATUS               = 0x200000C0
[  286.473702] radeon 0002:01:00.0:   SRBM_STATUS2              = 0x00000000
[  286.480592] radeon 0002:01:00.0:   R_008674_CP_STALLED_STAT1 = 0x00000000
[  286.487455] radeon 0002:01:00.0:   R_008678_CP_STALLED_STAT2 = 0x00000000
[  286.494313] radeon 0002:01:00.0:   R_00867C_CP_BUSY_STAT     = 0x00000000
[  286.501174] radeon 0002:01:00.0:   R_008680_CP_STAT          = 0x00000000
[  286.508058] radeon 0002:01:00.0:   R_00D034_DMA_STATUS_REG   = 0x44C83D57
[  286.514964] radeon 0002:01:00.0: GPU reset succeeded, trying to resume
[  286.653033] [drm] PCIE GART of 1024M enabled (table at 0x000000000014C000).
[  286.660325] radeon 0002:01:00.0: WB enabled
[  286.664611] radeon 0002:01:00.0: fence driver on ring 0 uses gpu addr 0x0000000040000c00
[  286.672817] radeon 0002:01:00.0: fence driver on ring 3 uses gpu addr 0x0000000040000c0c
[  286.692114] radeon 0002:01:00.0: fence driver on ring 5 uses gpu addr 0x000000000005c418
[  286.717546] [drm] ring test on 0 succeeded in 1 usecs
[  286.722707] [drm] ring test on 3 succeeded in 3 usecs
[  286.904994] [drm] ring test on 5 succeeded in 1 usecs
[  286.910140] [drm] UVD initialized successfully.
[  287.150451] [drm] ib test on ring 0 succeeded in 0 usecs
[  287.155965] [drm] ib test on ring 3 succeeded in 0 usecs
[  287.313145] [drm] ib test on ring 5 succeeded
[  287.527815] ------------[ cut here ]------------
[  287.527833] WARNING: CPU: 2 PID: 1099 at drivers/gpu/drm/ttm/ttm_bo.c:253 ttm_bo_release+0x238/0x2a0
[  287.527865] Modules linked in:
[  287.527875] CPU: 2 UID: 1000 PID: 1099 Comm: kwin_x11 Not tainted 6.16.12+ #10 PREEMPT
[  287.527884] Hardware name: Milk-V Jupiter (DT)
[  287.527888] epc : ttm_bo_release+0x238/0x2a0
[  287.527894]  ra : ttm_bo_put+0x32/0x4c
[  287.527899] epc : ffffffff80dbb110 ra : ffffffff80dbb1aa sp : ffffffc6099abca0
[  287.527903]  gp : ffffffff840ef990 tp : ffffffd70e428cc0 t0 : 0000003fed33e468
[  287.527907]  t1 : 0000000000000402 t2 : 0000000000400036 s0 : ffffffc6099abd20
[  287.527911]  s1 : ffffffd7362fc9e0 a0 : ffffffd7362fc9e0 a1 : ffffffd711785ed0
[  287.527914]  a2 : 0000000000000010 a3 : 0000000000000001 a4 : 0000000000000000
[  287.527918]  a5 : 0000000000000001 a6 : 0000000000000000 a7 : 0000000000000002
[  287.527921]  s2 : ffffffd72c0bb2c0 s3 : ffffffd711785da0 s4 : ffffffd7017fc020
[  287.527925]  s5 : ffffffd72c0bb240 s6 : 000000000000000b s7 : 0000000000000000
[  287.527928]  s8 : 0000000000000000 s9 : 00000000000000b0 s10: 000000000000000c
[  287.527932]  s11: 0000002ab1e44460 t3 : ffffffd70d363e58 t4 : 0000000000000040
[  287.527935]  t5 : 0000003fed33e468 t6 : 0000000000040000
[  287.527938] status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
[  287.527943] [<ffffffff80dbb110>] ttm_bo_release+0x238/0x2a0
[  287.527950] [<ffffffff80dbb1aa>] ttm_bo_put+0x32/0x4c
[  287.527955] [<ffffffff80df219e>] radeon_gem_object_free+0x1e/0x2c
[  287.527966] [<ffffffff80d7a2ca>] drm_gem_object_free+0x12/0x20
[  287.527975] [<ffffffff80d866e6>] drm_gem_dmabuf_release+0x3e/0x64
[  287.527981] [<ffffffff815682ea>] dma_buf_release+0x26/0x74
[  287.527991] [<ffffffff802d3680>] __dentry_kill+0x94/0x174
[  287.528001] [<ffffffff802d3a9e>] dput+0xee/0x198
[  287.528007] [<ffffffff802b8ece>] __fput+0x102/0x230
[  287.528015] [<ffffffff802b904c>] ____fput+0x10/0x18
[  287.528022] [<ffffffff8006e3b0>] task_work_run+0x58/0xac
[  287.528030] [<ffffffff800dab3c>] exit_to_user_mode_loop+0xd8/0xec
[  287.528040] [<ffffffff8212c232>] do_trap_ecall_u+0x2fe/0x388
[  287.528049] [<ffffffff821384b0>] handle_exception+0x150/0x15c
[  287.528064] ---[ end trace 0000000000000000 ]---
[  297.583775] radeon 0002:01:00.0: ring 0 stalled for more than 10120msec
[  297.590520] radeon 0002:01:00.0: GPU lockup (current fence id 0x0000000000002477 last fence id 0x0000000000002491 on ring 0)
[  298.095735] radeon 0002:01:00.0: ring 0 stalled for more than 10632msec
[  298.102493] radeon 0002:01:00.0: GPU lockup (current fence id 0x0000000000002477 last fence id 0x0000000000002491 on ring 0)
[  298.319737] radeon 0002:01:00.0: ring 3 stalled for more than 10180msec
[  298.326502] radeon 0002:01:00.0: GPU lockup (current fence id 0x0000000000000595 last fence id 0x0000000000000596 on ring 3)
[  298.607730] radeon 0002:01:00.0: ring 0 stalled for more than 11144msec
[  298.614454] radeon 0002:01:00.0: GPU lockup (current fence id 0x0000000000002477 last fence id 0x0000000000002491 on ring 0)
[  298.831733] radeon 0002:01:00.0: ring 3 stalled for more than 10692msec
[  298.839142] radeon 0002:01:00.0: GPU lockup (current fence id 0x0000000000000595 last fence id 0x0000000000000596 on ring 3)
[  299.121633] radeon 0002:01:00.0: ring 0 stalled for more than 11656msec
```
repeat the message and than:
```log
[  485.348689] Call Trace:
[  485.351177] [<ffffffff8212ec44>] __schedule+0x3dc/0xcb8
[  485.356482] [<ffffffff8212f548>] schedule+0x28/0xf8
[  485.361443] [<ffffffff82135c0a>] schedule_timeout+0x9a/0xec
[  485.367096] [<ffffffff80ddcc04>] radeon_fence_default_wait+0xb0/0x1ac
[  485.373636] [<ffffffff8156acf6>] dma_fence_wait_timeout+0x5e/0x168
[  485.379895] [<ffffffff8156d232>] dma_resv_wait_timeout+0xaa/0x1b4
[  485.386051] [<ffffffff80dbb1e8>] ttm_bo_delayed_delete+0x24/0x94
[  485.392137] [<ffffffff80068ab6>] process_one_work+0x12e/0x338
[  485.397972] [<ffffffff800690ec>] worker_thread+0x260/0x34c
[  485.403541] [<ffffffff800702b2>] kthread+0xf6/0x1a8
[  485.408491] [<ffffffff8002c33e>] ret_from_fork_kernel+0xe/0xcc
[  485.414420] [<ffffffff821385da>] ret_from_fork_kernel_asm+0x16/0x18
[  485.420802] INFO: task kworker/u44:6:1651 blocked for more than 121 seconds.
[  485.427964]       Tainted: G        W           6.16.12+ #10
[  485.433703] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  485.441636] task:kworker/u44:6   state:D stack:0     pid:1651  tgid:1651  ppid:2      task_flags:0x4208060 flags:0x00000000
[  485.452923] Workqueue: ttm ttm_bo_delayed_delete
[  485.457621] Call Trace:
[  485.460111] [<ffffffff8212ec44>] __schedule+0x3dc/0xcb8
[  485.465429] [<ffffffff8212f548>] schedule+0x28/0xf8
[  485.470385] [<ffffffff82135c0a>] schedule_timeout+0x9a/0xec
[  485.476028] [<ffffffff80ddcc04>] radeon_fence_default_wait+0xb0/0x1ac
[  485.482562] [<ffffffff8156acf6>] dma_fence_wait_timeout+0x5e/0x168
[  485.488809] [<ffffffff8156d232>] dma_resv_wait_timeout+0xaa/0x1b4
[  485.495012] [<ffffffff80dbb1e8>] ttm_bo_delayed_delete+0x24/0x94
[  485.501109] [<ffffffff80068ab6>] process_one_work+0x12e/0x338
[  485.506957] [<ffffffff800690ec>] worker_thread+0x260/0x34c
[  485.512510] [<ffffffff800702b2>] kthread+0xf6/0x1a8
[  485.517435] [<ffffffff8002c33e>] ret_from_fork_kernel+0xe/0xcc
[  485.523347] [<ffffffff821385da>] ret_from_fork_kernel_asm+0x16/0x18
[  485.529715] Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
```

and a reboot or freeze