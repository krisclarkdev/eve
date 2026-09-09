# Virtio-GPU for Windows Guests

Windows guests require virtio-gpu drivers for proper display support.

## Installing virtio-gpu Drivers

1. Download the virtio-win ISO from https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/
2. Attach the ISO to the VM as a CD-ROM drive
3. In Windows Device Manager, update the display adapter driver
4. Browse to the virtio-win ISO and select the virtio-gpu driver

## Driver Location in virtio-win ISO

The virtio-gpu drivers are located in:
- `virtio-win.iso/virtio-gpu-win-*/` (for WDDM drivers)
- `virtio-win.iso/virtio-gpu-win-*/x64/` (for 64-bit systems)

## Verifying Installation

After installation, verify the driver is active:
1. Open Device Manager
2. Expand "Display adapters"
3. Confirm "Red Hat VirtIO GPU" is listed