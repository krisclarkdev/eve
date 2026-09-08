# EVE-OS FR201 VM HDMI Passthrough Approach

## Overview

This approach uses virtio-gpu with a DRM/KMS backend to expose the Raspberry Pi CM4's vc4/v3d GPU to a VM running on EVE-OS. This enables direct HDMI display output from the VM.

## Architecture

```
VM (guest OS)
    ↓ virtio-gpu
QEMU virtio-gpu device
    ↓ DRM/KMS backend
Host vc4/v3d GPU driver
    ↓ DRM
/dev/dri/card0, /dev/dri/renderD128
    ↓ vc4/v3d driver
BCM2711 SoC GPU
    ↓ HDMI
Display
```

## Implementation Steps

### 1. Modify QEMU to use vc4 DRM backend

QEMU's virtio-gpu device needs to be configured to use the host's vc4 DRM backend. This requires:

- Building QEMU with DRM/KMS support
- Configuring the virtio-gpu device to use the vc4 DRM backend
- Ensuring the guest OS has the virtio-gpu driver

### 2. Configure VM to use virtio-gpu

The VM configuration needs to include a virtio-gpu device:

```json
{
    "devices": [
        {
            "type": "virtio-gpu",
            "backend": "drm",
            "drm_device": "/dev/dri/card0"
        }
    ]
}
```

### 3. Test on FR201

Deploy a VM with the virtio-gpu device and verify HDMI output.

## Files

- `eve/pkg/pillar/hypervisor/kvm.go` - KVM hypervisor configuration (needs modification)
- `eve/pkg/pillar/hypervisor/xen.go` - Xen hypervisor configuration (needs modification)
- `eve/models/OnLogic.FR201.json` - FR201 device model (needs GPU adapter)

## Known Issues

- QEMU's virtio-gpu DRM backend may not support the vc4 GPU out of the box
- Guest OS needs virtio-gpu driver with DRM support
- HDMI output may require additional configuration

## Alternatives Considered

1. **PCIe passthrough** - Not applicable; vc4 GPU is SoC-integrated, not on PCIe bus
2. **Xen PV framebuffer** - Requires Xen hypervisor modification; complex
3. **Device tree overlay** - Complex and SoC-specific; not portable

## References

- [QEMU virtio-gpu Documentation](https://www.qemu.org/docs/master/system/devices/virtio-gpu.html)
- [vc4 DRM Driver](https://www.kernel.org/doc/html/latest/gpu/vc4.html)
- [EVE-OS KVM Hypervisor](https://wiki.lfedge.org/display/EVE/KVM+Hypervisor)