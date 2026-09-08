# EVE-OS FR201 GPU CDI Approach

## Overview

This approach uses the Container Device Interface (CDI) to expose the Raspberry Pi CM4's vc4/v3d GPU to a container running on EVE-OS. This enables direct HDMI display output from the container.

## Architecture

```
Container (weston)
    ↓ CDI spec
EVE-OS CDI runtime
    ↓ Device nodes
/dev/dri/card0, /dev/dri/renderD128, /dev/vchiq, /dev/vcsm, /dev/vcio
    ↓ vc4/v3d driver
BCM2711 SoC GPU
    ↓ HDMI
Display
```

## Files

- `eve/pkg/rpi/cdi/rpi-cm4.yaml` - CDI specification for vc4/v3d GPU
- `eve/models/OnLogic.FR201.json` - FR201 device model with GPU adapter
- `eve/test-containers/weston/Dockerfile` - Weston Wayland compositor container
- `eve/test-containers/weston/test-gpu-cdi.sh` - Automated test script

## CDI Specification

The CDI file exposes the following devices to the container:
- `/dev/dri/card0` - DRM card device
- `/dev/dri/renderD128` - DRM render node
- `/dev/vchiq` - VideoCore inter-process communication
- `/dev/vcsm` - VideoCore shared memory
- `/dev/vcio` - VideoCore I/O

Environment variables are set for GPU acceleration:
- `GBM_BACKEND=vc4-drm`
- `EGL_PLATFORM=drm`
- `DISPLAY=:0`

## Device Model

The FR201 model includes an HDMI adapter (ztype 7) with CDI support:
```json
{
    "ztype": 7,
    "phylabel": "GPU0",
    "assigngrp": "GPU0",
    "logicallabel": "GPU0",
    "cbattr": {
        "cdi": "rpi.com/vc4-gpu=0"
    }
}
```

## Testing

### Manual Test

1. Build the weston container:
   ```bash
   docker build --platform linux/arm64 -t eve-weston:latest eve/test-containers/weston/
   ```

2. Push to EVE-OS registry or load onto FR201

3. Deploy with GPU adapter:
   ```bash
   zcli app deploy eve-weston:latest --adapter GPU0 --name gpu-test
   ```

4. Check HDMI output for weston desktop

### Automated Test

```bash
./eve/test-containers/weston/test-gpu-cdi.sh <FR201_IP> [user] [pass]
```

## Known Issues

- CDI support in EVE-OS is primarily tested with NVIDIA Jetson devices
- vc4/v3d GPU support may require additional kernel modules or firmware
- Weston may need specific backend configuration for vc4

## Alternatives Considered

1. **VNC** - EVE's built-in VNC support works but requires a VNC client, not direct HDMI
2. **PCIe passthrough** - Not applicable; vc4 GPU is SoC-integrated, not on PCIe bus
3. **Manifest-only /dev/dri** - Blocked by EVE's container isolation model

## References

- [EVE-OS Hardware Model Documentation](https://wiki.lfedge.org/display/EVE/Hardware+Model)
- [Container Device Interface Specification](https://github.com/container-orchestrated-devices/container-device-interface)
- [vc4 DRM Driver](https://www.kernel.org/doc/html/latest/gpu/vc4/index.html)